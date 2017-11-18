resource "aws_s3_bucket" "buckets" {
  count    = "${length(var.bucket_base_names)}"
  bucket   = "${element(var.bucket_base_names, count.index)}"
}
