resource "aws_s3_bucket" "credentials_secrets_joechem" {
  bucket = "credentials-secrets-joechem"
  acl = "private"
}

#TODO: replace bucket and iam role arn's with variables
resource "aws_s3_bucket_policy" "credentials_secrets_joechem" {
  bucket = "${aws_s3_bucket.credentials_secrets_joechem.id}"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
      "Sid":"AllowPublicRead",
      "Effect":"Allow",
      "Principal":{
        "AWS":"arn:aws:iam::328959061259:role/joechem-role"
      },
    "Action":"s3:GetObject",
    "Resource":"arn:aws:s3:::credentials-secrets-joechem/*"
    },
    {
      "Sid":"AllowPublicRead",
      "Effect":"Allow",
      "Principal":{
        "AWS":"arn:aws:iam::328959061259:role/joechem-role"
      },
    "Action":"s3:ListBucket",
    "Resource":"arn:aws:s3:::credentials-secrets-joechem"
    }
  ]
}
EOF
}

output "credentials_secrets_joechem_bucket_name" {
    value = "${aws_s3_bucket.credentials_secrets_joechem.id}"
}
