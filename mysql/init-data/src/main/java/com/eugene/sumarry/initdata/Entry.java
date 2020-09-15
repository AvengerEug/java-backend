package com.eugene.sumarry.initdata;

import com.eugene.sumarry.initdata.service.PayService;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Entry {
    public static void main(String[] args) throws InterruptedException {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        context.getBean(PayService.class).batchInsertWithThreadPool();
    }
}
