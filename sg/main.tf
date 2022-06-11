resource "aws_security_group" "sg_service" {
  name        = var.security_group_name
  description = var.security_group_desc
  vpc_id      = var.vpc_id
  
  dynamic "ingress" {
     for_each = [ for rule in var.sg_ingress_rules:{
         desc   = rule.description
         port   = rule.ingress_port
         protocol = rule.protocol
         cidr_blocks = rule.cidr_blocks
     }]
      content  {
        description      = ingress.value.desc
        from_port        = ingress.value.port
        to_port          = ingress.value.port
        protocol         = ingress.value.protocol
        cidr_blocks      = ingress.value.cidr_blocks   
      }
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}