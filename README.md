# java-backend
<p align="center">
  <a href="#21-java-基础"><img src="https://img.shields.io/badge/-java基础-9cf.svg" alt="java 基础" /></a>
  <a href="#22-微服务"><img src="https://img.shields.io/badge/-微服务-lightgrey.svg" alt="微服务" /></a>
  <a href="#23-设计模式"><img src="https://img.shields.io/badge/-设计模式-ff69b4.svg" alt="设计模式" /></a>
  <a href="#24-spring家族"><img src="https://img.shields.io/badge/-spring家族-blue.svg" alt="spring家族" /></a>
  <a href="#25-mybatis"><img src="https://img.shields.io/badge/-mybatis-orange.svg" alt="mybatis" /></a>
  <a href="#26-分布式"><img src="https://img.shields.io/badge/-分布式-red.svg" alt="分布式" /></a>
  <a href="#27-开源"><img src="https://img.shields.io/badge/-开源-green" alt="开源" /></a>
  <a href="#28-mysql"><img src="https://img.shields.io/badge/-mysql-yellowgreen" alt="mysql" /></a>
</p>

![后端知识脑图](https://github.com/AvengerEug/java-backend/blob/develop/后端知识脑图.png)

脑图链接：[https://www.processon.com/view/link/5ead29fae0b34d05e1bdab1e](https://www.processon.com/view/link/5ead29fae0b34d05e1bdab1e)

## 一、使用步骤

1. clone develop分支至本地
   ```
      git clone https://github.com/AvengerEug/java-backend.git -b develop
   ```
   
2. 执行如下脚本clone所有项目(develop分支)
   ```shell
     BRANCH=develop ./build.sh clone
   ```

3. 使用idea或者eclipse等其他编辑器以maven project的形式导入

4. 在java-backend项目根目录下执行如下命令编译项目:
    ```shell
        ./build.sh install
    ```


## 二、包含模块

### 2.1 java 基础

#### javase

 * java基础知识, [仓库地址:https://github.com/AvengerEug/javase](https://github.com/AvengerEug/javase)

### 2.2 微服务

#### lib-common

 * 会使用到的common类库, 分布式项目经常会有通用的模块, 此工程正是此作用。[仓库地址:https://github.com/AvengerEug/lib-common](https://github.com/AvengerEug/lib-common)

#### jwt-token

 * 基于springboot + jwt-token方法, 实现token认证。[仓库地址:https://github.com/AvengerEug/jwt-token](https://github.com/AvengerEug/jwt-token)

### 2.3 设计模式

#### dynamic-proxy

 * 动态代理设计模式学习。[仓库地址:https://github.com/AvengerEug/dynamic-proxy](https://github.com/AvengerEug/dynamic-proxy)

#### dynamic-proxy-adapter

 * 动态代理与适配器设计模式集成实例。[仓库地址:https://github.com/AvengerEug/dynamic-proxy-adapter](https://github.com/AvengerEug/dynamic-proxy-adapter)

#### tempate-method
 * 模板方法设计模式实例, 构建`spring clould feign client`调用的模板方法。[仓库地址:https://github.com/AvengerEug/tempate-method](https://github.com/AvengerEug/tempate-method)

#### simple-factory
 * 简单工厂设计模式实例, 模拟下单流程。[仓库地址:https://github.com/AvengerEug/simple-factory](https://github.com/AvengerEug/simple-factory)

#### observer
 * 观察者设计模式学习。[仓库地址:https://github.com/AvengerEug/observer](https://github.com/AvengerEug/observer)

### 2.4 spring家族

#### spring

 * spring框架学习。[仓库地址:https://github.com/AvengerEug/spring](https://github.com/AvengerEug/spring)

#### spring-mvc

* spring mvc框架学习。[https://github.com/AvengerEug/spring/tree/develop/spring-mvc](https://github.com/AvengerEug/spring/tree/develop/spring-mvc)

#### spring-boot
 * spring boot框架学习。[https://github.com/AvengerEug/springboot-study](https://github.com/AvengerEug/springboot-study)

#### spring-cloud
 * spring cloud框架学习。[https://github.com/AvengerEug/spring-cloud](https://github.com/AvengerEug/spring-cloud)

### 2.5 mybatis

* mybatis相关总结。[https://github.com/AvengerEug/spring/tree/develop/mybatis](https://github.com/AvengerEug/spring/tree/develop/mybatis)

### 2.6 分布式

#### rabbit-mq

 * 消息队列rabbit-mq学习。[仓库地址:https://github.com/AvengerEug/rabbit-mq](https://github.com/AvengerEug/rabbit-mq)

#### distributed

 * 分布式相关学习。[https://github.com/AvengerEug/distributed](https://github.com/AvengerEug/distributed)

#### redis

  * redis相关总结[https://github.com/AvengerEug/redis-study]

### 2.7 开源

#### spring-boot-zookeeper-client-starter

  * 基于Spring Boot开源的starter[https://github.com/AvengerEug/spring-boot-zookeeper-client-starter](https://github.com/AvengerEug/spring-boot-zookeeper-client-starter)

### 2.8 mysql

#### mysql

  * mysql相关总结[https://github.com/AvengerEug/java-backend/tree/develop/mysql](https://github.com/AvengerEug/java-backend/tree/develop/mysql)