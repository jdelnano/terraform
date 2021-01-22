resource "aws_s3_bucket" "dev_joechem" {
  bucket = "dev-joechem"
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "dev_joechem" {
  bucket = "${aws_s3_bucket.dev_joechem.id}"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
        "Sid":"AllowPublicRead",
        "Effect":"Allow",
        "Principal":{
            "AWS":"*"
        },
        "Action":"s3:GetObject",
        "Resource":"arn:aws:s3:::dev-joechem/*"
    }]
}
EOF
}
