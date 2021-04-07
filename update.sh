#!/usr/bin/env bash
set -eu
# 默认登陆地址
LOGIN_URL=https://developer.yonyoucloud.com/portal/sso/login.jsp
# 时间戳
EXT_TAG=fix-shiro
# 更新方法
# 依赖于几个环境变量
function update() {
  # 输出信息
  echo "Application: ${KUBE_DEPLOYMENT}"
  echo "BaseImage: ${BASE_IMAGE}"
  echo "UpdateImage: ${BASE_IMAGE}-${EXT_TAG}"
  echo "LoginUrl: ${LOGIN_URL}"
  echo "press enter key to continue..."
  read -r
  # 构建镜像
  docker build --build-arg="BASE_IMAGE=${BASE_IMAGE}" --build-arg="LOGIN_URL=${LOGIN_URL}" -t "${BASE_IMAGE}-${EXT_TAG}" .
  # 推送镜像
  docker push "${BASE_IMAGE}-${EXT_TAG}"
  # 更新部署
  patch="[{\"op\": \"replace\", \"path\": \"/spec/template/spec/containers/0/image\", \"value\":\"${BASE_IMAGE}-${EXT_TAG}\"}]"
  kubectl patch deployment "${KUBE_DEPLOYMENT}" -n developer-center --type='json' -p="${patch}"
  # 完成配置
  echo "Complete: ${KUBE_DEPLOYMENT} with ${BASE_IMAGE}-${EXT_TAG}"
}
# app-apply
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-app-resource-apply:20200212203424
KUBE_DEPLOYMENT=app-apply
update

# app-base
BASE_IMAGE=reg.yyuap.io:81/developer-center/dcl-app-link:20200731171032
KUBE_DEPLOYMENT=app-base
update

# changedog-web
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-changedog:20200423200052
KUBE_DEPLOYMENT=changedog-web
update

# confcenter
BASE_IMAGE=reg.yyuap.io:81/developer-center/accesscenter-confcenter:20200717142540
KUBE_DEPLOYMENT=confcenter
update

# dbtask-app
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-dbtask-sync:20200212182017
KUBE_DEPLOYMENT=dbtask-app
update

# dbtask-exam
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-dbtask-exam:20200212181642
KUBE_DEPLOYMENT=dbtask-exam
update

# eos-console
BASE_IMAGE=reg.yyuap.io:81/developer-center/eos-console:20200225153154
KUBE_DEPLOYMENT=eos-console
update

# eos-mq-auth
BASE_IMAGE=reg.yyuap.io:81/developer-center/eos-mq-auth:20200212180745
KUBE_DEPLOYMENT=eos-mq-auth
update

# inotify-manager
BASE_IMAGE=reg.yyuap.io:81/developer-center/inotify-manager:20200212181119
KUBE_DEPLOYMENT=inotify-manager
update

# iuapinsight
BASE_IMAGE=reg.yyuap.io:81/developer-center/iuapinsight:20200212183103
KUBE_DEPLOYMENT=iuapinsight
update

# monitorweb
BASE_IMAGE=reg.yyuap.io:81/developer-center/monitor-console:20200217134058
KUBE_DEPLOYMENT=monitorweb
update

# runtime-log
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-runtime-log:20200212183119
KUBE_DEPLOYMENT=runtime-log
update

# sms
BASE_IMAGE=reg.yyuap.io:81/developer-center/dc-iuapmessage:20200212181702
KUBE_DEPLOYMENT=sms
update

# timer
BASE_IMAGE=reg.yyuap.io:81/developer-center/timer:20200212180812
KUBE_DEPLOYMENT=timer
update

# ycm-yyy
BASE_IMAGE=reg.yyuap.io:81/developer-center/ycm-yyy:20191218105138
KUBE_DEPLOYMENT=ycm-yyy
update