data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }

}

resource "aws_instance" "wordpress_instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    associate_public_ip_address = true
    subnet_id = aws_subnet.wordpress_public_subnet_1.id
    vpc_security_group_ids = [aws_security_group.wordpress_security_group.id]

    key_name = var.key_name

    user_data = file("${path.module}/install_wordpress.sh")

    tags = {
        Name = "wordpress-instance"
    }
}