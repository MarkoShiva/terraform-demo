#varaibles
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {
  default="aws"
}

#providers

provider "aws" {

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-2"
}

#resources
resource "aws_key_pair" "mykeypair" {
  key_name = "aws"
  public_key = "${file("/home/in1t3r/.ssh/aws.pub")}"
}
resource "aws_instance" "nginx" {
  ami = "ami-922914f7"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  connection {
    user    = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum install nginx -y",
    "sudo service nginx start"
    ]
  }
}

#Output

output "aws_instance_public_dns" {
value = "${aws_instance.nginx.public_dns}"
}
