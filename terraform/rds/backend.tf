terraform {
  backend "s3" {
    bucket = "cybercloudx"
    key    = "rds/state"
    encrypt = "true"
    region = "us-west-2"
  }
}
