# 说明
***此脚本仅适用于用友技术中台，测试为501版本。***

此补丁主要解决一下两方面问题
- Shiro版本过低，存在安全漏洞。通过升级Shiro相关依赖解决。
- Shiro配置问题，原Shiro Login地址为公网地址。通过文本替换方式，更新为客户现场地址。
# 使用说明
1. 将本项目拷贝至Kubernetes主节点
1. 更新前使用`kubectl get deployment -n developer-center -o yaml > developer-center.yaml`命令获取目前所有的部署内容。
1. 更新`update.sh`中相关`LOGIN_URL`、`EXT_TAG`、`BASE_IMAGE`等参数
1. 执行`docker login reg.yyuap.io:81`登陆镜像仓库，登陆账户必须有写`developer-center`库权限
1. 执行`update.sh`文件，进行更新。每个应用更新前，均会打印基本信息，需按`Enter`键进行确认