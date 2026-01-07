provider "aws" {
  region = "eu-west-3"
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

data "aws_ami" "aws_linux" {
most_recent= true

filter {
name= "name"
values =["al2023-ami-minimal-*-kernel-6.12-x86_64"]
}

filter {
name ="virtualization-type"
values =["hvm"]
}

owners =["137112412989"]
}

resource "aws_instance" "aws_audit" {
ami = data.aws_ami.aws_linux.id
instance_type = "t3.micro"
iam_instance_profile=aws_iam_instance_profile.EC2_ReadOnly.name
vpc_security_group_ids=[aws_security_group.EC2_audit.id]
}

resource "aws_security_group" "EC2_audit" {
name =  "EC2_audit"
description = " Allow SSH on port 22 for my IP adress only"

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_port22"{
security_group_id= aws_security_group.EC2_audit.id
ip_protocol= "tcp"
from_port=22
to_port= 22
cidr_ipv4="104.28.42.24/32"
}

resource "aws_iam_instance_profile" "EC2_ReadOnly"{
name= "EC2_ReadOnly"
role= aws_iam_role.ec2_readonly_role.name
}

data "aws_iam_policy_document" "ec2_assume_role"{
statement {
actions= ["sts:AssumeRole"]

principals {
type= "Service"
identifiers= ["ec2.amazonaws.com"]
}
}
}

resource "aws_iam_role" "ec2_readonly_role" {
name = "ec2_readonly_role"
assume_role_policy= data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_readonly_attach" {
role= aws_iam_role.ec2_readonly_role.name
policy_arn="arn:aws:iam::aws:policy/ReadOnlyAccess"
}

 
