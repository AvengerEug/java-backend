package com.eugene.sumarry.initdata;

import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@ComponentScan("com.eugene.sumarry.initdata")
@Configuration
@MapperScan("com.eugene.sumarry.initdata.dao")
public class AppConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource driverManagerDataSource = new DriverManagerDataSource();
        driverManagerDataSource.setUrl("jdbc:mysql://49.235.135.230:3306/test?useUnicode=true&characterEncoding=utf-8&useSSL=false&allowMultiQueries=true");
        driverManagerDataSource.setUsername("root");
        driverManagerDataSource.setDriverClassName("com.mysql.jdbc.Driver");
        driverManagerDataSource.setPassword("root");
        return driverManagerDataSource;
    }

    @Bean
    public SqlSessionFactoryBean sqlSessionFactoryBean() throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource());
        sqlSessionFactoryBean.setTypeAliasesPackage("com.eugene.sumarry.initdata.model");

        // 此处是参考spring解析@ComponentScan的方式搭建的, 指定了正则的resource,
        // org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider.scanCandidateComponents

        // 扫描的配置文件名称没有要求, 唯一要求是:
        //   对应的mapper文件的命名空间要和对应的dao类的全类名一致, 它是按照这样的规则来对应的
        sqlSessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources("classpath:mapper/**/*.xml"));
        sqlSessionFactoryBean.setFailFast(true);
        return sqlSessionFactoryBean;
    }
}
