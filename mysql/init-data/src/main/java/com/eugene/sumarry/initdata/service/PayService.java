package com.eugene.sumarry.initdata.service;

import com.eugene.sumarry.initdata.dao.PayDao;
import com.eugene.sumarry.initdata.model.PayPO;
import com.sun.corba.se.impl.resolver.SplitLocalResolverImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.*;

@Service
public class PayService {

    @Autowired
    private PayDao payDao;

    /**
     * 插入100万条数据
     */
    private static volatile Integer MAX_COUNT = 1000000;

    private static volatile Integer BATCH_NUMBER = 10000;

    private static final ThreadPoolExecutor THREAD_POOL = new ThreadPoolExecutor(
            3,
            5,
            3000,
            TimeUnit.MILLISECONDS,
            new LinkedBlockingDeque<>(100),
            Executors.defaultThreadFactory(),
            new ThreadPoolExecutor.CallerRunsPolicy()
    );

    private CountDownLatch countDownLatch = new CountDownLatch(MAX_COUNT/BATCH_NUMBER);

    /**
     * 耗时：155460
     * @throws InterruptedException
     */
    public void batchInsertWithThreadPool() throws InterruptedException {
        long start = System.currentTimeMillis();
        Random random = new Random();
        // 批量插入, 每次批量插入2000
        int count = MAX_COUNT.intValue();
        while ((count = count - BATCH_NUMBER) >= 0) {
            THREAD_POOL.submit(() -> {
                LinkedList<PayPO> linkedList = new LinkedList();
                for (Integer i = 0; i < BATCH_NUMBER; i++) {
                    PayPO po = new PayPO();
                    po.setAccountId(UUID.randomUUID().toString());
                    // 左开右闭区间，[0, 3) 随机获取0, 1, 2
                    po.setState(random.nextInt(3));
                    po.setCreateTime(randomDate("2019-05-11 00:00:00", "2020-09-15 23:59:59"));
                    linkedList.add(po);
                }
                payDao.batchInsert(new ArrayList<>(linkedList));
                countDownLatch.countDown();
                linkedList.clear();
            });
        }
        countDownLatch.await();
        THREAD_POOL.shutdown();
        System.out.printf("耗时：" + (System.currentTimeMillis() - start));
    }

    /**
     * 耗时192912
     * @throws InterruptedException
     */
    public void batchInsert() throws InterruptedException {
        long start = System.currentTimeMillis();
        Random random = new Random();
        LinkedList<PayPO> linkedList = new LinkedList();
        // 批量插入, 每次批量插入2000
        int count = MAX_COUNT.intValue();
        while ((count = count - BATCH_NUMBER) >= 0) {
            for (Integer i = 0; i < BATCH_NUMBER; i++) {
                PayPO po = new PayPO();
                po.setAccountId(UUID.randomUUID().toString());
                // 左开右闭区间，[0, 3) 随机获取0, 1, 2
                po.setState(random.nextInt(3));
                po.setCreateTime(randomDate("2019-05-11 00:00:00", "2020-09-15 23:59:59"));
                linkedList.add(po);
            }
            payDao.batchInsert(new ArrayList<>(linkedList));
            linkedList.clear();
        }

        System.out.printf("耗时：" + (System.currentTimeMillis() - start));
    }

    /**
     * 获取随机日期
     * @param beginDate 起始日期
     * @param endDate 结束日期
     * @return
     */
    public static Date randomDate(String beginDate, String endDate){
        try {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
            Date start = format.parse(beginDate);
            Date end = format.parse(endDate);

            if(start.getTime() >= end.getTime()){
                return null;
            }

            long date = random(start.getTime(),end.getTime());

            return new Date(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static long random(long begin,long end){
        long rtn = begin + (long)(Math.random() * (end - begin));
        if(rtn == begin || rtn == end){
            return random(begin,end);
        }
        return rtn;
    }
}
