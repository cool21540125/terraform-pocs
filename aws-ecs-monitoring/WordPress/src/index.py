import boto3
import logging
from typing import List

log = logging.getLogger()
log.setLevel("INFO")
client = boto3.client("ecs")


class ECS:
    def __init__(self, client, cluster: str, service: str):
        self._client = client
        self._service = service
        self._cluster = cluster

    def redeploy(self):
        svc = self._client.describe_services(
            cluster=self._cluster, services=[self._service]
        )["services"][0]

        self._client.update_service(
            forceNewDeployment=True,
            cluster=self._cluster,
            service=self._service,
            taskDefinition=svc["taskDefinition"],
            desiredCount=svc["desiredCount"],
        )

    @property
    def service(self):
        return self._service


def lambda_handler(event, context):
    """
    1. hard code mapping to ALB and ECS
    2. extract current task-definition version
    3. redeploy ECS Service via current task-definition version
    """
    try:
        metric0 = event["alarmData"]["configuration"]["metrics"][0]
        dimension = metric0["metricStat"]["metric"]["dimensions"]

        alb = dimension["LoadBalancer"]
        tg = dimension["TargetGroup"]
    except Exception:
        log.warning(f"ℹ️ event : {event}")
        log.error(f"❌ Extract alb from CWA Event -- Failed")
        raise

    if (
        alb == "app/takeorder-server/cffdf30aea0860f3"
        and tg == "targetgroup/ecs-takeor-takeorderWordpress/45e40abd9e089b79"
    ):
        ecs = ECS(
            client=client,
            cluster="takeorder",
            service="takeorderWordpress",
        )

    elif (
        alb == "app/OfficialService/ac9481520866a675"
        and tg == "targetgroup/ecs-Server-weibyWordpress/6093c14c34470a56"
    ):
        ecs = ECS(
            client=client,
            cluster="ServerAPI",
            service="weibyWordpress",
        )

    elif (
        alb == "app/WeibyOfficialWebsite/6c1c500f98235cca"
        and tg == "targetgroup/ecs-weibyBlog/235c2213bcab6376"
    ):
        ecs = ECS(
            client=client,
            cluster="ServerAPI",
            service="weibyBlog",
        )

    else:
        # 截至 2024/05, 只有上述 3 個 WordPress 的 ALB. 如果發生此錯誤, 表示可能是:
        # CloudWatch Alarm 誤把 action 拋到這個 Lambda Function (去修改你的 CloudWatch Alarm 的 Lambda action 吧)
        # or
        # 我們有另外建立新的 WordPress (增加上面的 elif, 然後再 terraform apply)
        log.warning(f"ℹ️ event : {event}")
        log.error(f"❌ Unable to process alb: '{alb}'. Should fix code.")
        raise

    try:
        ecs.redeploy()
        log.info(f"✅ ECS Service: `{ecs._service}` update Successfully.")
    except Exception as err:
        # 重新部署 ECS Service 發生問題... 需要排查了QAQ
        log.warning(f"ℹ️ event : {event}")
        log.error(f"❌ Force redeploy ECS Service Failed.")
        log.error(err)
