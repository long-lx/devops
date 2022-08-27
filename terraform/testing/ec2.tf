# tạo ssh keypair cho ec2 instance, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "devops" {
  key_name = "devops-ssh"

  # replace the below with your public key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmj3WuWnqrXKoYTFe9TURZ+7x8hwtd8x2MAOnpHziFz1hxMyS6/dQoFbcOBvTNoF4yNYBf4TOrNrUiYW6QyKepbF5yK9Q4TU/Nht8eQQ3SuqeM58B3Z416BrA+QO6WwH+PHAdvZsZhHrhLgOFJsNR5PPOBigEK4iZuIzd/iWaRokp27hdrhXJh8n/7ASQ0G+opom4E3q+9kQSW1KrjjZf+SdwWneLQpEMM6mZ+yjCRNBBY9+LgnCfpm0pM18BLdh8Hg6BFwHvSP+8i4NPWc+8rUUmNHUvS/fildwJuFCq8KWdHRrU8+lJhKTJLhtKpVimfwgHbE7CKnc1hAUnIjKLApCenZq3lwBLXHY1ktfI+dzU8tqEOJWKw9GT+M/Z269s44asc5yadRvuW9yosK0+aIvfxtyBcOa2LQlQkPBYu5mKC8wVvm+4LfKzAIOMk0R7Muah7Yy4vde06sLCF5DtzURpDt4rkr/3B13c+MHcOvAoQ1B4b5BtjmIUP1SYmJO177RwHM+mV6IVXb+M0AzNkkgysbNd0uJJyNU8xaD6aC4S2GPMGKXfMnP4gQbcqliIk30qyQ81dbHrfTJ0St5MsVAK58eM4PhtLOpUSy0gBE+ozNq+QkLBrMXrfIdTCwkthmHQIipkImOGODfNra11v3+X75shitnhg1u2vC/Co0Q== devops@techmaster.vn"
}

# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/4.9.0
module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "web-security-group-${var.env}"
  description = "Security group for Web ec2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

## EC2 https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws

# tạo ec2 instances ở public subnet, zone-a
module "ec2_za" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["01"])

  name = "${var.env}-web-za-${each.key}"

  ami                    = "ami-0eaf04122a1ae7b3b" # https://cloud-images.ubuntu.com/locator/ec2/
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devops.key_name
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

# tạo ec2 instances ở public subnet, zone-b
module "ec2_zb" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["01"])

  name = "${var.env}-web-zb-${each.key}"

  ami                    = "ami-0eaf04122a1ae7b3b" # https://cloud-images.ubuntu.com/locator/ec2/
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.devops.key_name
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 1)

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
