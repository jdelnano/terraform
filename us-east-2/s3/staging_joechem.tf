resource "aws_s3_bucket" "staging_joechem" {
  bucket = "staging-joechem"
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "staging_joechem" {
  bucket = "${aws_s3_bucket.staging_joechem.id}"
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
        "Resource":"arn:aws:s3:::staging-joechem/*"
    }]
}
EOF
}
