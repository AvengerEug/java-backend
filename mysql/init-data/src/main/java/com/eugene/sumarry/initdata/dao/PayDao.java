package com.eugene.sumarry.initdata.dao;

import com.eugene.sumarry.initdata.model.PayPO;

import java.util.List;

public interface PayDao {

    void batchInsert(List<PayPO> list);
}
