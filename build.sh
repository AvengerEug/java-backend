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
  clone_tempate-method
  clone_simple-factory
  clone_observer
  clone_jwt-token
  clone_rabbit-mq
  clone_spring
  clone_springboot-study

  echo "=============================================="
  echo "Clone project done."
  echo "=============================================="
}

clone_springboot-study() {
  echo -e "\nClone springboot-study"
  echo "----------------------------------------------"
  if [ ! -e ./basic/springboot-study ]; then
    git clone https://github.com/AvengerEug/springboot-study.git -b $BRANCH ./basic/springboot-study
  fi
}

clone_javase() {
  echo -e "\nClone javase"
  echo "----------------------------------------------"
  if [ ! -e ./basic/javase ]; then
    git clone https://github.com/AvengerEug/javase.git -b $BRANCH ./basic/javase
  fi
}

clone_lib-common() {
  echo -e "\nClone lib-common"
  echo "----------------------------------------------"
  if [ ! -e ./lib/lib-common ]; then
    git clone https://github.com/AvengerEug/lib-common.git -b $BRANCH ./lib/lib-common
  fi
}

clone_dynamic-proxy() {
  echo -e "\nClone dynamic-proxy"
  echo "----------------------------------------------"
  if [ ! -e ./design/dynamic-proxy ]; then
    git clone https://github.com/AvengerEug/dynamic-proxy.git -b $BRANCH ./design/dynamic-proxy
  fi
}

clone_dynamic-proxy-adapter() {
  echo -e "\nClone dynamic-proxy-adapter"
  echo "----------------------------------------------"
  if [ ! -e ./design/dynamic-proxy-adapter ]; then
    git clone https://github.com/AvengerEug/dynamic-proxy-adapter.git -b $BRANCH ./design/dynamic-proxy-adapter
  fi
}

clone_simple-factory() {
  echo -e "\nClone simple-factory"
  echo "----------------------------------------------"
  if [ ! -e ./design/simple-factory ]; then
    git clone https://github.com/AvengerEug/simple-factory.git -b $BRANCH ./design/simple-factory
  fi
}

clone_observer() {
  echo -e "\nClone observer"
  echo "----------------------------------------------"
  if [ ! -e ./design/observer ]; then
    git clone https://github.com/AvengerEug/observer.git -b $BRANCH ./design/observer
  fi
}

clone_tempate-method() {
  echo -e "\nClone template-method"
  echo "----------------------------------------------"
  if [ ! -e ./design/template-method ]; then
    git clone https://github.com/AvengerEug/template-method.git -b $BRANCH ./design/template-method
  fi
}

clone_jwt-token() {
  echo -e "\nClone jwt-token"
  echo "----------------------------------------------"
  if [ ! -e ./javaee/jwt-token ]; then
    git clone https://github.com/AvengerEug/jwt-token.git -b $BRANCH ./javaee/jwt-token
  fi
}

clone_rabbit-mq() {
  echo -e "\nClone rabbit-mq"
  echo "----------------------------------------------"
  if [ ! -e ./rabbitmq ]; then
    git clone https://github.com/AvengerEug/rabbit-mq.git -b $BRANCH ./rabbitmq/rabbit-mq
  fi
}

clone_spring() {
  echo -e "\nClone spring"
  echo "----------------------------------------------"
  if [ ! -e ./basic/spring ]; then
    git clone https://github.com/AvengerEug/spring.git -b $BRANCH ./basic/spring
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