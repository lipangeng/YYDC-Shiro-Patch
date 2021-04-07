#!/usr/bin/env bash
echo "---------------------------------------"
echo "Start Process Shiro Login Configuration"
echo "---------------------------------------"
set -eux
# 切换工作目录
cd /tmp
# 待扫描目录
tomcatDir=/usr/local/tomcat
# 处理已解压类型的包
function patch_unpacked() {
  # 循环查找相关的jar包
  while IFS= read -r -d '' target; do
    # 开始处理配置文件
    echo "--- Begin $(dirname "${target}") ---"
    # 检查是否有相关跳转地址配置
    if [ "$(grep -c 'https://developer.yonyoucloud.com/portal/sso/login.jsp' "${target}")" -ne "0" ]; then
      echo "Match Shiro Login Configuration"
      sed -i "s|https://developer.yonyoucloud.com/portal/sso/login.jsp|${LOGIN_URL}|g" "${target}"
    fi
    # 完成处理配置文件
    echo "--- End ${target} ---"
    echo "---"
    echo "---"
    echo "---"
  done < <(find ${tomcatDir} -name "applicationContext-shiro.xml" -print0)
}
# 处理未解压类型的文件
function patch_packed() {
  # 循环查找所有的war包
  while IFS= read -r -d '' targetWar; do
    # 开始处理war包
    echo "--- Begin ${targetWar} ---"
    # 扫描目标war包,如果存在shiro相关文件
    if [ "$(jar -tf "${targetWar}" | grep -c "applicationContext-shiro.xml")" -ne "0" ]; then
      # 解压配置文件
      rm -rvf WEB-INF/classes/applicationContext-shiro.xml
      jar -xvf "${targetWar}" WEB-INF/classes/applicationContext-shiro.xml
      # 检查是否有相关跳转地址配置
      if [ "$(grep -c 'https://developer.yonyoucloud.com/portal/sso/login.jsp' WEB-INF/classes/applicationContext-shiro.xml)" -ne "0" ]; then
        echo "Match Shiro Login Configuration"
        sed -i "s|https://developer.yonyoucloud.com/portal/sso/login.jsp|${LOGIN_URL}|g" WEB-INF/classes/applicationContext-shiro.xml
        # 更新原始War包
        jar -uvf "${targetWar}" WEB-INF/classes/applicationContext-shiro.xml
      fi
      # 清理目录文件
      rm -rvf WEB-INF/classes/applicationContext-shiro.xml
    fi
    # war包处理完成
    echo "--- End ${targetWar} ---"
    echo "---"
    echo "---"
    echo "---"
  done < <(find ${tomcatDir} -name "*.war" -print0)
}

patch_unpacked
patch_packed
