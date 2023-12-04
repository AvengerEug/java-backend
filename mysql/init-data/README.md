# ???DB&Table??
## ???DB
```sql
CREATE DATABASE IF NOT EXISTS `test`;
```

## ???Table
```sql
USE test;
CREATE TABLE IF NOT EXISTS `test`.`pay` (
  `pay_id` bigint(11) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(255) NOT NULL,
  `create_time` date NOT NULL,
  `state` tinyint NOT NULL,
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```