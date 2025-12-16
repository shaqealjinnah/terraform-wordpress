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