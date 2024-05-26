# locals {
#   remediate_ecs_policy = jsondecode(file("config/CwaRemediateEcsPolicy.json"))
# }

# ===============================================================================================
# Role && Policy FIXME: 偵測 Policy.json 的 md5
# ===============================================================================================
resource "aws_iam_role" "cwa-lambda-remediation-role" {
  name        = "CwaLambdaRemediationRole"
  description = "Allows Lambda functions to do remediate, because of CloudWatch Alarm has beed triggered. Created by SRE on 2024-05-24"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "cwa-remediate-ecs-policy" {
  name   = "CwaRemediateEcsPolicy"
  role   = aws_iam_role.cwa-lambda-remediation-role.id
  policy = file("config/CwaRemediateEcsPolicy.json")
}
