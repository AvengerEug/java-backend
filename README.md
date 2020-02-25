# java-backend
java技术后端group root项目

## 使用步骤

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


## 包含模块

### javase
 * java基础知识, [仓库地址:https://github.com/AvengerEug/javase](https://github.com/AvengerEug/javase)

### lib-common
 * 会使用到的common类库, 分布式项目经常会有通用的模块, 此工程正是此作用。[仓库地址:https://github.com/AvengerEug/lib-common](https://github.com/AvengerEug/lib-common)

### dynamic-proxy
 * 动态代理设计模式学习。[仓库地址:https://github.com/AvengerEug/dynamic-proxy](https://github.com/AvengerEug/dynamic-proxy)

### dynamic-proxy-adapter
 * 动态代理与适配器设计模式集成实例。[仓库地址:https://github.com/AvengerEug/dynamic-proxy-adapter](https://github.com/AvengerEug/dynamic-proxy-adapter)
  
### tempate-method 
 * 模板方法设计模式实例, 构建`spring clould feign client`调用的模板方法。[仓库地址:https://github.com/AvengerEug/tempate-method](https://github.com/AvengerEug/tempate-method)

### simple-factory
 * 简单工厂设计模式实例, 模拟下单流程。[仓库地址:https://github.com/AvengerEug/simple-factory](https://github.com/AvengerEug/simple-factory)
  
### observer
 * 观察者设计模式学习。[仓库地址:https://github.com/AvengerEug/observer](https://github.com/AvengerEug/observer)

### jwt-token
 * 基于springboot + jwt-token方法, 实现token认证。[仓库地址:https://github.com/AvengerEug/jwt-token](https://github.com/AvengerEug/jwt-token)

### rabbit-mq
 * 消息队列rabbit-mq学习。[仓库地址:https://github.com/AvengerEug/rabbit-mq](https://github.com/AvengerEug/rabbit-mq)

### spring
 * spring框架学习。[仓库地址:https://github.com/AvengerEug/spring](https://github.com/AvengerEug/spring)
 
### spring-boot
 * spring boot框架学习。[https://github.com/AvengerEug/springboot-study](https://github.com/AvengerEug/springboot-study)
 
### spring-cloud
 * spring cloud框架学习。[https://github.com/AvengerEug/spring-cloud](https://github.com/AvengerEug/spring-cloud)