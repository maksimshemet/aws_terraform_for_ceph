resource "aws_security_group" "management" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.2.0/24"]
 }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


#NODE 1
resource "aws_network_interface" "public-ceph-01" {
  subnet_id         = aws_subnet.public.id
  private_ips_count = 1
  security_groups   = [aws_security_group.management.id]
}

resource "aws_network_interface" "data-ceph-01" {
  subnet_id         = aws_subnet.data.id
  private_ips_count = 1
}

resource "aws_eip" "ceph-01-pub" {
  vpc                       = true
  network_interface         = aws_network_interface.public-ceph-01.id
}

resource "aws_instance" "ceph-01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "ceph-test"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public-ceph-01.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.data-ceph-01.id
  }

  tags = {
    Name = "ceph-01",
    Env = "ceph-test"
  }
}

resource "aws_ebs_volume" "volume-ceph-01-01" {
    
    availability_zone = aws_instance.ceph-01.availability_zone

    size = 10

    tags = {
      Name = "ceph-01-01",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-01-01" {

    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.volume-ceph-01-01.id
    instance_id = aws_instance.ceph-01.id

}

resource "aws_ebs_volume" "volume-ceph-01-02" {
    
    availability_zone = aws_instance.ceph-01.availability_zone

    size = 10

    tags = {
      Name = "ceph-01-02",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-01-02" {

    device_name = "/dev/sdj"
    volume_id = aws_ebs_volume.volume-ceph-01-02.id
    instance_id = aws_instance.ceph-01.id

}

#NODE 2

resource "aws_network_interface" "public-ceph-02" {
  subnet_id         = aws_subnet.public.id
  private_ips_count = 1
  security_groups   = [aws_security_group.management.id]
}

resource "aws_network_interface" "data-ceph-02" {
  subnet_id         = aws_subnet.data.id
  private_ips_count = 1
}

resource "aws_eip" "ceph-02-pub" {
  vpc                       = true
  network_interface         = aws_network_interface.public-ceph-02.id
}

resource "aws_instance" "ceph-02" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "ceph-test"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public-ceph-02.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.data-ceph-02.id
  }

  tags = {
    Name = "ceph-02",
    Env = "ceph-test"
  }
}

resource "aws_ebs_volume" "volume-ceph-02-01" {
    
    availability_zone = aws_instance.ceph-02.availability_zone

    size = 10

    tags = {
      Name = "ceph-02-01",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-02-01" {

    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.volume-ceph-02-01.id
    instance_id = aws_instance.ceph-02.id

}

resource "aws_ebs_volume" "volume-ceph-02-02" {
    
    availability_zone = aws_instance.ceph-02.availability_zone

    size = 10

    tags = {
      Name = "ceph-02-02",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-02-02" {

    device_name = "/dev/sdj"
    volume_id = aws_ebs_volume.volume-ceph-02-02.id
    instance_id = aws_instance.ceph-02.id

}

#NODE 3

resource "aws_network_interface" "public-ceph-03" {
  subnet_id         = aws_subnet.public.id
  private_ips_count = 1
  security_groups   = [aws_security_group.management.id]
}

resource "aws_network_interface" "data-ceph-03" {
  subnet_id         = aws_subnet.data.id
  private_ips_count = 1
}

resource "aws_eip" "ceph-03-pub" {
  vpc                       = true
  network_interface         = aws_network_interface.public-ceph-03.id
}

resource "aws_instance" "ceph-03" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "ceph-test"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public-ceph-03.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.data-ceph-03.id
  }

  tags = {
    Name = "ceph-03",
    Env = "ceph-test"
  }
}

resource "aws_ebs_volume" "volume-ceph-03-01" {
    
    availability_zone = aws_instance.ceph-03.availability_zone

    size = 10

    tags = {
      Name = "ceph-03-01",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-03-01" {

    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.volume-ceph-03-01.id
    instance_id = aws_instance.ceph-03.id

}

resource "aws_ebs_volume" "volume-ceph-03-02" {
    
    availability_zone = aws_instance.ceph-03.availability_zone

    size = 10

    tags = {
      Name = "ceph-03-02",
      Env = "ceph-test"
  }   
}

resource "aws_volume_attachment" "ebsAttach-03-02" {

    device_name = "/dev/sdj"
    volume_id = aws_ebs_volume.volume-ceph-01-02.id
    instance_id = aws_instance.ceph-01.id

}