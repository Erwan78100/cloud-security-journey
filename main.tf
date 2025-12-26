provider "aws" {
  region = "eu-west-3" # Paris, cohérent avec ton plan IDF
}
resource "aws_iam_group" "auditors" {
name ="audit-team"
}
resource "aws_iam_group_policy_attachment" "readonly" {
group = aws_iam_group.auditors.name
policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
} 
