ARG BASE_IMAGE
FROM $BASE_IMAGE
MAINTAINER 李盼庚<lipg@outlook.com>

# 登陆地址配置
ARG LOGIN_URL=https://developer.yonyoucloud.com/portal/sso/login.jsp

# 添加文件
ADD lib/ /tmp/WEB-INF/lib/
ADD shiro_patch.sh /tmp/
ADD shiro_login.sh /tmp/

# 执行补丁
RUN set -eux; \
	\
	chmod +x /tmp/shiro_patch.sh ;\
	chmod +x /tmp/shiro_login.sh ;\
	\
	/tmp/shiro_patch.sh ;\
	/tmp/shiro_login.sh