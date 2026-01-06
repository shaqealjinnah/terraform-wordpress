# Create Custom VPC
resource "aws_vpc" "wordpress_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    

    tags = {
        Name = "wordpress-vpc"
    }
}

# Create Subnet
resource "aws_subnet" "wordpress_public_subnet_1" {
    vpc_id = aws_vpc.wordpress_vpc.id
    availability_zone = "${var.aws_region}a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "wordpress-public-subnet-1"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "wordpress_igw" {
    vpc_id = aws_vpc.wordpress_vpc.id

    tags = {
        Name = "wordpress-internet-gateway"
    }
}

# Create Route Table + Routes
resource "aws_route_table" "wordpress_route_table" {
    vpc_id = aws_vpc.wordpress_vpc.id

    tags = {
        Name = "wordpress-route-table"
    }
}

resource "aws_route" "wordpress_internet_access" {
    route_table_id = aws_route_table.wordpress_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
}

resource "aws_route_table_association" "wordpress_subnet_association" {
    subnet_id = aws_subnet.wordpress_public_subnet_1.id
    route_table_id = aws_route_table.wordpress_route_table.id

}

# Create Security Groups
resource "aws_security_group" "wordpress_security_group" {
    name = "wordpress-security-group"
    description = "Allow HTTP and SSH traffic inbound and all outbound traffic"
    vpc_id = aws_vpc.wordpress_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.wordpress_security_group.id
    description       = "Allow HTTP from the internet"

    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
    security_group_id = aws_security_group.wordpress_security_group.id
    description = "Allow SSH from admin IP"

    cidr_ipv4 = "${var.admin_ip}/32"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "all_access" {
    security_group_id = aws_security_group.wordpress_security_group.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

# Create EC2 Instance bootstrapped with WordPress
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

    user_data = file("${path.module}/../scripts/install_wordpress.sh")

    tags = {
        Name = "wordpress-instance"
    }
}