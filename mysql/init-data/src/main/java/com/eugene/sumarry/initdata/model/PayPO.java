package com.eugene.sumarry.initdata.model;

import java.io.Serializable;
import java.util.Date;

public class PayPO implements Serializable {

    private Long payId;

    private String accountId;

    private Date createTime;

    /**
     * 0:成功, 1:失败, 2:冻结
     */
    private Integer state;

    public Long getPayId() {
        return payId;
    }

    public void setPayId(Long payId) {
        this.payId = payId;
    }

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    @Override
    public String toString() {
        return "PayPO{" +
                "payId=" + payId +
                ", accountId='" + accountId + '\'' +
                ", createTime=" + createTime +
                ", state=" + state +
                '}';
    }
}
