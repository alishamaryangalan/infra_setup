#Create IAM Policy
resource "aws_iam_policy" "WebAppS3" {
  name        = "WebAppS3"
  description = "WebAppS3 policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
          ],
          "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}",
              "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}/*"
          ]
      }
  ]
}
EOF
}

#Attach WebAppS3 policy to EC2-CSYE6225 IAM Role
resource "aws_iam_role_policy_attachment" "Attach_WebAppS3_to_EC2-CSYE6225" {
  role       = aws_iam_role.EC2-CSYE6225.name
  policy_arn = aws_iam_policy.WebAppS3.arn
}

#Attach IAM Role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.EC2-CSYE6225.name
}