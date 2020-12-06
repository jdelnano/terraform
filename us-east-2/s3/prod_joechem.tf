resource "aws_s3_bucket" "prod_joechem" {
  bucket = "prod-joechem"
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "prod_joechem" {
  bucket = "${aws_s3_bucket.prod_joechem.id}"
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
        "Resource":"arn:aws:s3:::prod-joechem/*"
    }]
}
EOF
}
