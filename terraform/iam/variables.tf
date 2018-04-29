variable "name" {
  description = "Desired name for the IAM user"
  default     = "cybercloudx-dev"
}

variable "path" {
  description = "Desired path for the IAM user"
  default     = "/"
}


variable "aws_iam_policy" {
  description = "Name of the policy ARN"
  default     = "arn:aws:iam::YOUR_ACCOUNT_NUMBER:policy/s3-policy"
}
