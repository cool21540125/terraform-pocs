# =============================================
# count 範例
# 不過, 會形成「以資源組成的陣列」
# 資源直接與陣列索引位置綁死
# aws_iam.user.example[0]: Lisa
# aws_iam.user.example[1]: Tina
# aws_iam.user.example[2]: Katty
# 假如把 Tina 刪掉, 則會產生悲劇的結果
# aws_iam.user.example[0]: Lisa
# aws_iam.user.example[1]: Katty (Tina 更名成 Katty)
# (原本的 Katty 被砍了)
# =============================================
variable "user_names" {
  description = "Create IAM Users"
  type = list(string)
  default = [ "Lisa", "Tina", "Katty" ]
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}

output "first_arn" {
  value = aws_iam_user.example[0].arn
  description = "The ARN for the first user"
}

output "all_arns" {
  value = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}