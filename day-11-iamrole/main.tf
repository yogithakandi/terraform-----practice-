
# ---------- Create IAM User ----------
resource "aws_iam_user" "example_user" {
  name = "yogitha"
  #path = "/"
  tags = {
    Purpose = "Terraform IAM Demo"
  }
}

# ---------- Create IAM Group ----------
resource "aws_iam_group" "developers" {
  name = "developers"
}

# ---------- Add User to Group ----------
resource "aws_iam_user_group_membership" "example_membership" {
  user = aws_iam_user.example_user.name
  groups = [
    aws_iam_group.developers.name
  ]
}

# ---------- Attach Policy to Group ----------
resource "aws_iam_group_policy_attachment" "group_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# ---------- (Optional) Create Access Key ----------
#resource "aws_iam_access_key" "user_key" {
 # user = aws_iam_user.example_user.name
#}

# ---------- Output ----------
#output "iam_user_name" {
 # value = aws_iam_user.example_user.name
#}

#output "access_key_id" {
 # value = aws_iam_access_key.user_key.id
#}

#output "secret_access_key" {
 # value     = aws_iam_access_key.user_key.secret
  #sensitive = true
#}