# 建立 EKS Cluster

1. 填妥 `.env` 使用的 EC2 ssh_key (需要在 IaC 外部建立)
2. `export AWS_PROFILE=default`
3. 更新 `terraform.tfvars.json`
4. `terraform apply`
```bash
# 填妥 .env
# 更新 terraform.tfvars.json

export AWS_PROFILE=
terraform apply
```


# Usage

```bash
export AWS_PROFILE=
export EKS_NAME=
aws eks update-kubeconfig --name $EKS_NAME

kubectl get pods -A
```


# Cost

- NAT - 1 顆
- EKS cluster - 1 套
- EC2
  - t3.medium - 1 台
  - t4g.medium - 1 台


# Note

整個建立過程, 主要會花在 EKS Node groups 的建立及銷毀及其管控的 EC2, 耗時約為 20 mins