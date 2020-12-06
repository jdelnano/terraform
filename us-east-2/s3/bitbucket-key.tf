resource "aws_s3_bucket" "bitbucket_repo_key" {
  bucket = "bitbucket-repo-key"
  acl = "private"
}

resource "aws_s3_bucket_policy" "bitbucket_repo_key" {
  bucket = "${aws_s3_bucket.bitbucket_repo_key.id}"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
     {
        "Sid":"AllowPublicRead",
        "Effect":"Allow",
        "Principal":{
            "AWS":"arn:aws:iam::328959061259:role/joechem-role"
        },
        "Action":"s3:GetObject",
        "Resource":"arn:aws:s3:::bitbucket-repo-key/*"
    },
    {
        "Sid":"AllowPublicRead",
        "Effect":"Allow",
        "Principal":{
            "AWS":"arn:aws:iam::328959061259:role/joechem-role"
        },
        "Action":"s3:ListBucket",
        "Resource":"arn:aws:s3:::bitbucket-repo-key"
    }
  ]
}
EOF
}
