terraform {
  backend "s3" {
    bucket = "cybercloudx"
    key    = "dms/state"
    encrypt = "true"
    region = "us-west-2"
  }
}
