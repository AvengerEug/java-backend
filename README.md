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

4. 因为其中的某些project会依赖与lib-common项目, 所以在拉取项目后需要在java-backend路径下执行mvn clean install命令

