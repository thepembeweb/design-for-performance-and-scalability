# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity1" {
  count         = "4"
  ami           = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  tags = {
    name = "Udacity T2"
  }
  vpc_security_group_ids = ["sg-0aaaf7c4ae753ac81"]
  subnet_id              = "subnet-0950ba10a74044f22"
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity2" {
  count         = "2"
  ami           = "ami-0323c3dd2da7fb37d"
  instance_type = "m4.large"
  tags = {
    name = "Udacity M4"
  }
  vpc_security_group_ids = ["sg-0aaaf7c4ae753ac81"]
  subnet_id              = "subnet-0fd660581252e06ab"
}
