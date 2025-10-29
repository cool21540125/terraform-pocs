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

# Auto Scaling 功能

此專案已配置完整的 EKS Auto Scaling 功能：

## 功能特色
- **Cluster Autoscaler**: 自動根據 Pod 需求增減 Node
- **Horizontal Pod Autoscaler (HPA)**: 基於 CPU 使用率自動擴展 Pod
- **Metrics Server**: 提供資源使用率監控
- **測試應用程式**: 用於驗證 Auto Scaling 功能

## Auto Scaling 設定
- **CPU 閾值**: 70% (連續 10 分鐘)
- **Node 擴展**: 最小 1 個，最大 5 個 (每個 node group)
- **Pod 擴展**: 最小 2 個，最大 10 個
- **縮減延遲**: 10 分鐘

## 測試 Auto Scaling
```bash
# 1. 確保 kubectl 已連接到 cluster
export AWS_PROFILE=dev
export EKS_NAME=devops
aws eks update-kubeconfig --name $EKS_NAME --region us-west-2

# 2. 執行測試腳本
./test-autoscaling.sh

# 3. 手動檢查狀態
kubectl get nodes
kubectl get hpa
kubectl get pods -l app=test-app
kubectl top pods -l app=test-app
```

## 監控 Cluster Autoscaler
```bash
# 查看 Cluster Autoscaler 日誌
kubectl logs -n kube-system -l app=cluster-autoscaler -f

# 查看 Auto Scaling 事件
kubectl get events --sort-by=.metadata.creationTimestamp
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
  - t3.medium - 1-5 台 (Auto Scaling)
  - t4g.medium - 1-5 台 (Auto Scaling)

# Note

整個建立過程, 主要會花在 EKS Node groups 的建立及銷毀及其管控的 EC2, 耗時約為 20 mins

## Auto Scaling 注意事項

1. **首次部署**: Cluster Autoscaler 需要 2-3 分鐘啟動
2. **擴展時間**: Node 擴展需要 3-5 分鐘，Pod 擴展需要 1-2 分鐘
3. **縮減延遲**: 為避免頻繁擴縮，設定了 10 分鐘的縮減延遲
4. **成本控制**: 設定了最大 Node 數量限制 (每個 node group 最多 5 個)
5. **監控**: 使用 `kubectl top` 命令監控資源使用率