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