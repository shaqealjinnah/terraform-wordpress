# Create a remote backend using S3 with native state locking
terraform  {
    backend "s3" {
    bucket = "wordpress-tfbucket"
    key    = "wordpress/terraform.tfstate"
    use_lockfile = true
    region = "ap-southeast-2"
  }
}