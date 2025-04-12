terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {}

resource "aws_iam_user" "system_users1" {
   name = var.s_a.u_1
}
resource "aws_iam_user" "system_users2"{
   name = var.s_a.u_2
}      
resource "aws_iam_user" "system_users3"{
   name = var.s_a.u_3
}   
resource "aws_iam_group" "system_admins" {
   name = "system_admins"
}
resource "aws_iam_group_membership" "system" {
   name = "system-admin-group-membership"

   users = [
     var.s_a.u_1,
     var.s_a.u_2,
     var.s_a.u_3
   ]

   group = aws_iam_group.system_admins.name
}
 resource "aws_iam_account_password_policy" "strict" {
   minimum_password_length        = 8
   require_lowercase_characters   = true
   require_numbers                = true
   require_uppercase_characters   = true
   require_symbols                = true
   allow_users_to_change_password = true
 }
resource "aws_iam_group_policy_attachment" "system_admin_policy" {
   group      = aws_iam_group.system_admins.name
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_user" "database_user1"{
    name = "${var.d_u}_1"
}
variable "d_u" {
    type = string
    default = "database_admin_user"
}
resource "aws_iam_user" "database_user2"{
    name = "${var.d_u}_2"
}
resource "aws_iam_user" "database_user3"{
    name = "${var.d_u}_3"
}
resource "aws_iam_group" "database_admins" {
   name = "database_admins"

}
resource "aws_iam_group_membership" "database" {
   name = "database-admin-group-membership"

   users = [
     "${var.d_u}_1",
     "${var.d_u}_2",
     "${var.d_u}_3"
   ]

   group = aws_iam_group.database_admins.name
}
resource "aws_iam_group_policy_attachment" "database_admin_policy" {
   group      = aws_iam_group.database_admins.name
   policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}