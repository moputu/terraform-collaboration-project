resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "demo-vpc"
    Env = "demo"
  }
}

resource "aws_internet_gateway" "demo_gw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id          = aws_vpc.demo_vpc.id
  cidr_block      = element(["10.0.0.0/24", "10.0.1.0/24"], count.index) # Adjust CIDR blocks as needed
  availability_zone = element(["ca-central-1a", "ca-central-1b"], count.index) # Change to desired availability zones
  map_public_ip_on_launch = true
}



# Create private subnets similarly.
resource "aws_subnet" "private_subnet" {
  vpc_id          = aws_vpc.demo_vpc.id
  cidr_block      = "10.0.3.0/24"
  availability_zone = "ca-central-1a" # Change to desired availability zones
  map_public_ip_on_launch = false
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_gw.id
  }
}

resource "aws_route_table_association" "subnet_association" {
  count = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
