#Create IAM User
resource "aws_iam_user" "user" {
  name          = "${var.name}"
  path          = "${var.path}"
}

#Attach IAM policy to user
resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "s3-access"
  users      = ["${aws_iam_user.user.name}"]
  policy_arn = "${var.aws_iam_policy}"
}
