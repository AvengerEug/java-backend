#!/bin/bash -e

opts="clone"

BRANCH=${BRANCH:-"master"}

clone() {
  echo "=============================================="
  echo "Clone project with branch $BRANCH"
  echo "=============================================="

  clone_javase
  clone_lib-common
  clone_dynamic-proxy
  clone_dynamic-proxy-adapter
  clone_simple-factory
  clone_jwt-token
  clone_rabbit-mq

  echo "=============================================="
  echo "Clone project done."
  echo "=============================================="
}

clone_javase() {
  echo -e "\nClone javase"
  echo "----------------------------------------------"
  if [ ! -e ./basic/javase ]; then
    git clone https://github.com/EugeneHuang9638/javase.git -b $BRANCH ./basic/javase
  fi
}

clone_lib-common() {
  echo -e "\nClone lib-common"
  echo "----------------------------------------------"
  if [ ! -e ./lib/lib-common ]; then
    git clone https://github.com/EugeneHuang9638/lib-common.git -b $BRANCH ./lib/lib-common
  fi
}

clone_dynamic-proxy() {
  echo -e "\nClone dynamic-proxy"
  echo "----------------------------------------------"
  if [ ! -e ./design/dynamic-proxy ]; then
    git clone https://github.com/EugeneHuang9638/dynamic-proxy.git -b $BRANCH ./design/dynamic-proxy
  fi
}

clone_dynamic-proxy-adapter() {
  echo -e "\nClone dynamic-proxy-adapter"
  echo "----------------------------------------------"
  if [ ! -e ./design/dynamic-proxy-adapter ]; then
    git clone https://github.com/EugeneHuang9638/dynamic-proxy-adapter.git -b $BRANCH ./design/dynamic-proxy-adapter
  fi
}

clone_simple-factory() {
  echo -e "\nClone simple-factory"
  echo "----------------------------------------------"
  if [ ! -e ./design/simple-factory ]; then
    git clone https://github.com/EugeneHuang9638/simple-factory.git -b $BRANCH ./design/simple-factory
  fi
}

clone_jwt-token() {
  echo -e "\nClone jwt-token"
  echo "----------------------------------------------"
  if [ ! -e ./javaee/jwt-token ]; then
    git clone https://github.com/EugeneHuang9638/jwt-token.git -b $BRANCH ./javaee/jwt-token
  fi
}

clone_rabbit-mq() {
  echo -e "\nClone rabbit-mq"
  echo "----------------------------------------------"
  if [ ! -e ./rabbitmq ]; then
    git clone https://github.com/EugeneHuang9638/rabbit-mq.git -b $BRANCH ./rabbitmq/rabbit-mq
  fi
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
  *)
    usage
    ;;
esac