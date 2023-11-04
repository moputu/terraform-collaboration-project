# Load Balancer Configuration
resource "aws_lb" "my_alb" {
  name               = "my-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

}

# Target Group Configuration (Students should complete this section)

resource "aws_lb_target_group" "demo_tg" {  # Define the Target Group configuration here.
    name     = "my-demo-tg"
    port     = 80  # The port that your EC2 instances listen on
    protocol = "HTTP"
    vpc_id   = aws_vpc.demo_vpc.id  # Specify the VPC where the target group should be created
}


# Target Group Configuration (Students should complete this section)
resource "aws_lb_target_group_attachment" "test" { # Define the Target Group Attachment configuration here.
    count            = length(aws_instance.ec2_instance)
    target_group_arn = aws_lb_target_group.demo_tg.arn
    target_id        = aws_instance.ec2_instance[count.index].id  # Replace with the instance ID(s) you want to attach
    port             = 80
}

# Listener Configuration (Students should complete this section)
resource "aws_lb_listener" "front_end" { # Define the Listener configuration here.
    load_balancer_arn = aws_lb.my_alb.arn
    port              = 80  # The port on which the ALB listens
    protocol          = "HTTP"

    default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_tg.arn
    }
}