resource "aws_instance" "ec2_instance" {
  count = 2 #set the desired count here
  ami           = "ami-0db21996a46a72de9" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    echo "<html><body style='background-color:lightblue'><center><h1>Hello World from $IP</h1></center></body></html>" > index.html
    nohup python -m SimpleHTTPServer 80 &
EOF


}
