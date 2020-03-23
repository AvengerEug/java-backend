#!/bin/bash -e

opts="clone install"

BRANCH=${BRANCH:-"master"}

clone() {
  echo "=============================================="
  echo "Clone project with branch $BRANCH"
  echo "=============================================="

  clone_lib-common
  clone_dynamic-proxy-adapter

  echo "=============================================="
  echo "Clone project done."
  echo "=============================================="
}


clone_lib-common() {
  echo -e "\nClone lib-common"
  echo "----------------------------------------------"
  if [ ! -e ./lib/lib-common ]; then
    git clone https://github.com/AvengerEug/lib-common.git -b $BRANCH ./lib/lib-common
  fi
}

clone_dynamic-proxy-adapter() {
  echo -e "\nClone dynamic-proxy-adapter"
  echo "----------------------------------------------"
  if [ ! -e ./design/dynamic-proxy-adapter ]; then
    git clone https://github.com/AvengerEug/dynamic-proxy-adapter.git -b $BRANCH ./design/dynamic-proxy-adapter
  fi
}

install() {
  echo -e "\n Starting install thirdparty-1.0-SNAPSHOT.jar to maven repository"
  cd ./design/dynamic-proxy-adapter/thirdparty
  pwd
  ./mvn-install.sh

  cd ../../../
  pwd
  echo -e "\n Compile && Install root project"
  mvn clean install && mvn clean package
}

usage() {
  echo "USAGE: $0" option key

  echo -e "\nOptions:"
  for opt in $opts; do
    echo "    ${opt}"
  done
  echo -e ""
}


case "$1" in
  clone)
    clone
    ;;
  install)
    install
    ;;
  *)
    usage
    ;;
esac