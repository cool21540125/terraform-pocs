# =============================================
# init
# =============================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}
provider "aws" {
  region = var.aws_region
}
variable "aws_region" {
  default = ""
}
variable "aws_account" {
  default = ""
}


# =============================================
# Example Data
# =============================================
variable "user_names" {
  description = "Create IAM Users"
  type        = list(string)
  default     = ["Lisa", "Tina", "Katty"]
  # default = ["Irene"]
}

# # =============================================
# # count 範例
# # 不過, 會形成「以資源組成的 Array」
# # 資源直接與陣列索引位置綁死
# # aws_iam.user.example[0]: Lisa
# # aws_iam.user.example[1]: Tina
# # aws_iam.user.example[2]: Katty
# # 假如把 Tina 刪掉, 則會產生悲劇的結果
# # aws_iam.user.example[0]: Lisa
# # aws_iam.user.example[1]: Katty (Tina 更名成 Katty)
# # (原本的 Katty 被砍了)
# # =============================================
# resource "aws_iam_user" "example_list" {
#   count = length(var.user_names)
#   name  = var.user_names[count.index]
# }

# output "all_user_list" {
#   # value = aws_iam_user.example_list
#   value = aws_iam_user.example_list[*].id
#   # value = aws_iam_user.example_list[*].arn
# }


# =============================================
# for_each 範例
# 不過, 會形成「以資源組成的 Map」
# =============================================
resource "aws_iam_user" "example_map" {
  for_each = toset(var.user_names)
  name     = each.value
}

output "all_user_map" {
  # value = aws_iam_user.example_map
  # value = values(aws_iam_user.example_map)
  value = values(aws_iam_user.example_map)[*].arn
}

output "all_user_map_additional" {
  value = <<EOT
    %{for i, name in var.user_names}${name}%{if i < length(var.user_names) - 1}, %{endif}%{endfor}
  EOT
}
