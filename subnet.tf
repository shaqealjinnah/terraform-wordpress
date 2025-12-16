resource "aws_subnet" "wordpress_public_subnet_1" {
    vpc_id = aws_vpc.wordpress_vpc.id
    availability_zone = "${var.aws_region}a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "wordpress-public-subnet-1"
    }
}