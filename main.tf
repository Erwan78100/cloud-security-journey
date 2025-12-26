provider "aws" {
  region = "eu-west-3" # Paris, cohérent avec ton plan IDF
}
resource "aws_iam_user_group_membership" "equipe_auditeur" {
user=aws_iam_user.user1.name
groups=[
aws_iam_group.auditors.name
]
}
resource "aws_iam_user" "user1" {
name="erwan_dev"
}
resource "aws_iam_group" "auditors" {
name ="audit-team"
}
resource "aws_iam_group_policy_attachment" "readonly" {
group = aws_iam_group.auditors.name
policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
} 
