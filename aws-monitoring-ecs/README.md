# ECS related monitoring

```zsh
### (測試使用) 直接觸發警報
METRIC_ALARM_NAME="tf-ecs-tasks-high-CPU-notify"
aws cloudwatch set-alarm-state --alarm-name ${METRIC_ALARM_NAME} --state-value ALARM --state-reason "Test Only! Dont Panic."
# 此方式是直接將 CWA 設定為 ALARM 狀態, 指令本身是相對安全的. 並不是直接對 Resource 操作.
# 然而需要注意 Alarm Action 是否會對 Resource 造成影響.


### 
```
