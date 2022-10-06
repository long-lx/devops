# tạo s3 bucket với các giá trị tham chiếu từ các biến của module (variables.tf)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

# keyword: var.VARIABLE_NAME

resource "aws_s3_bucket" "b" {
  
  bucket = var.bucket_name
  tags   = var.tags
}
