#!/usr/bin/env bash
echo "-----------------------------------"
echo "Start Process Shiro Library Upgrade"
echo "-----------------------------------"
set -eux
# 切换工作目录
cd /tmp
# 补丁目录
patchDir=/tmp/WEB-INF/lib
# 待扫描目录
tomcatDir=/usr/local/tomcat
# 创建组件清单
#depends=(encoder shiro-cache shiro-config-core shiro-config-ogdl shiro-core shiro-crypto-cipher shiro-crypto-core
#  shiro-crypto-hash shiro-ehcache shiro-event shiro-spring shiro-web shiro-lang)
# 处理已解压的文件
function patch_unpacked() {
  # 循环查找相关的jar包
  while IFS= read -r -d '' target; do
    # 开始处理目录
    echo "--- Begin $(dirname "${target}") ---"
    # 获取目标目录
    targetDir=$(dirname "${target}")
    # 清理旧依赖
    rm -rvf "${targetDir}"/shiro*.jar
    rm -rvf "${targetDir}"/encoder-*.jar
    # 更新新依赖
    cp -rvf "${patchDir}"/*.jar "${targetDir}/"
    # 完成目录处理
    echo "--- End ${targetDir} ---"
    echo "---"
    echo "---"
    echo "---"
  done < <(find ${tomcatDir} -name "shiro-core*.jar" -print0)
}
# 处理未解压类型的文件
function patch_packed() {
  # 循环查找所有的war包
  while IFS= read -r -d '' targetWar; do
    # 开始处理war包
    echo "--- Begin ${targetWar} ---"
    # 扫描目标war包,如果存在shiro相关文件
    if [ "$(jar -tf "${targetWar}" | grep jar | grep "shiro-core" | wc -l)" -ne "0" ]; then
      # 删除当前war包中和shiro有关的全部依赖
      while read targetDel; do
        zip -d "${targetWar}" "${targetDel}"
      done < <(jar -tf "${targetWar}" | grep jar | grep "shiro-")
      # 扫描war包，如果存在encoder相关文件，则进行删除
      if [ "$(jar -tf "${targetWar}" | grep jar | grep "encoder-" | wc -l)" -ne "0" ]; then
        # 删除当前war包中和encoder有关的全部依赖
        while read targetDel; do
          zip -d "${targetWar}" "${targetDel}"
        done < <(jar -tf "${targetWar}" | grep jar | grep "encoder-")
      fi
      # 更新war包中的依赖
      jar -uvf "${targetWar}" WEB-INF/lib
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