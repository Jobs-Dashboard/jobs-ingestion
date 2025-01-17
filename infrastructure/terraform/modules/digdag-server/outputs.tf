#
# Outputs of this module
#

output "aws_instance_arn" {
  value = aws_instance._.arn
}
output "aws_eip_public_ip" {
  value = aws_eip._.public_ip
}
output "aws_s3_bucket_name" {
  value = aws_s3_bucket._.bucket
}
