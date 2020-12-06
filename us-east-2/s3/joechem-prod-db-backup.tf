resource "aws_s3_bucket" "joechem-prod-db-backup" {
  bucket = "joechem-prod-db-backup"
  acl = "private"
}
