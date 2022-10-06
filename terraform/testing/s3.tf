# gọi module s3 từ đường dẫn local và truyền các giá trị vào
module "s3_bucket" {
  source = "../modules/s3"

  bucket_name = "vn-techmaster-devops-0011-testing"

  tags = {
    Env = "testing"
  }
}

# in ra output của s3 module
output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}
