#################
# Load Balancer #
#################

resource "aws_security_group" "lb" {
  description = "Configure access for the Application Load Balancer"
  name        = "${local.prefix}-alb-access"
  vpc_id      = aws_vpc.main.id

  ingress { # HTTP inbound access (will be redirected to HTTPS)
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] # Allow all
  }

  ingress { # HTTPS inbound access
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"] # Allow all
  }

  egress { # from the load balancer to the API (in the private subnets on ecs)
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "api" {
  name               = "${local.prefix}-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "api" { #target_group is the outgoing target (distributing side) or the load balancer
  name        = "${local.prefix}-api"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # ecs has a private/internal ip address
  port        = 8000 # load balancer will get request on 443 and forward traffic to this port

  health_check {
    path = "/api/health-check/" # ensures that the load balancer forwards traffic to the healthy tasks
  }
}

resource "aws_lb_listener" "api" { #listener is the entry point (recieving side) for the load balancer
  load_balancer_arn = aws_lb.api.arn
  port              = 80
  protocol          = "HTTP" #(for now, later HTTPS with a certificate)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}