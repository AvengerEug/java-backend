# mysql相关知识点

## 一、架构图

![mysql架构图](https://github.com/AvengerEug/java-backend/blob/develop/mysql/架构图.png)

## 二、常见的存储引擎与区别

| 存储引擎 | 特点                                                         | 备注                                                         |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| InnoDB   | 1. 支持事务<br>2. 支持行级锁<br>3. 当插入数据时，默认会根据主键进行排序，若未指定主键则会自动生成一个row_id | 如果应用支持事务或需要执行大量的INSERT或UPDATE操作，则应该使用InnoDB |
| MyISAM   | 1. 不具备事务功能<br>2. 只支持表级锁<br>3. 数据插入顺序不变  | 如果应用中需要执行大量的SELECT查询，可以选择MyISAM           |
| Memory   | 数据不会存储到硬盘中，即重启后数据就会丢失                   | 不需要持久化则可以使用Memory                                 |

## 三、InnoDB存储引擎

* 为什么要单独总结InnoDB呢？因为它支持事务，就目前各种业务场景下，很多操作都是要求原子性的，这就体现到了事务的重要性。

### 3.1 InnoDB存储原理

* 数据会存储在硬盘上，在真正需要处理数据时，首先会把数据加载到内存中去。当进行查表时，InnoDB并不是一行一行的读取，在InnoDB中的数据大小单位叫`页`, 在mysql中可以使用如下命令查看页大小: **SHOW GLOBAL STATUS like 'Innodb_page_size';**

  ![默认页大小](https://github.com/AvengerEug/java-backend/blob/develop/mysql/默认页大小.png)

  默认页大小为**16384 byte**, 即`16kb`。对于mysql而言，不管是插入数据还是找出数据，都是以页为基本单位，也就是说，假设我们执行一条sql，它内部存储的内存大小小于`16kb`，此时mysql会继续将后面的数据也加载出来，因为mysql认为你可能后面会用到它们。

* 页结构

  ![页结构](https://github.com/AvengerEug/java-backend/blob/develop/mysql/页结构.png)

  通过上述图可知，固定部分已经占了**38 + 56 + 26 + 8 = 128字节**，相对于**16384字节**而言，微不足道。所以我们在mysql中存储的数据都是在`User Records`和`Free Space`两部分

### 3.2 InnoDB与MyISAM存储数据

* InnoDB与MyISAM建表与存储数据区别

  ```mysql
  --- 建表语句
  CREATE TABLE t1(
    a INT PRIMARY KEY,
    b INT,
    c INT,
    d INT,
    e VARCHAR(20)
  ) ENGINE=InnoDB
  
  --- 初始化数据
  INSERT INTO t1 VALUES
  (4, 3, 1, 1, 'd'),
  (2, 2, 2, 2, 'b'),
  (6, 6, 4, 4, 'f'),
  (1, 1, 1, 1, 'a'),
  (3, 3, 2, 2, 'c'),
  (8, 8, 8, 8, 'h'),
  (5, 2, 3, 5, '3'),
  (7, 4, 5, 5, 'g'),
  (9, 2, 1, 9, 'j'),
  (10, 7, 4, 2, 'l');
  
  --- 建表语句
  CREATE TABLE t2(
    a INT PRIMARY KEY,
    b INT,
    c INT,
    d INT,
    e VARCHAR(20)
  ) ENGINE=MyISAM
  
  --- 初始化数据
  INSERT INTO t2 VALUES
  (4, 3, 1, 1, 'd'),
  (2, 2, 2, 2, 'b'),
  (6, 6, 4, 4, 'f'),
  (1, 1, 1, 1, 'a'),
  (3, 3, 2, 2, 'c'),
  (8, 8, 8, 8, 'h'),
  (5, 2, 3, 5, '3'),
  (7, 4, 5, 5, 'g'),
  (9, 2, 1, 9, 'j'),
  (10, 7, 4, 2, 'l');
  ```

* 插入数据后的结果

  ![InnoDB与MyISAM插入数据区别](https://github.com/AvengerEug/java-backend/blob/develop/mysql/InnoDB和MyISAM插入数据区别.png)

### 3.3 InnoDB聚簇索引索引

* 通过上述内容可以知道，InnoDB在存储数据时默认会按照主键排序，而在此过程中，mysql还做了一件事，就是建立了`聚簇索引`。此`聚簇索引`是一棵**B+树**。我们通过**[https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html](https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html)**网站，根据**t1**表中的主键构建了这样的一棵**B+树**，如下所示：

  ![聚簇索引B+树](https://github.com/AvengerEug/java-backend/blob/develop/mysql/聚簇索引.png)

  可以看到，叶子节点中存储了`t1`表中所有的主键，其实在mysql构建这棵树中，它会存储其他的数据结构，于是，针对上述的数据结构，我重新绘制了一幅图：![聚簇索引2](https://github.com/AvengerEug/java-backend/blob/develop/mysql/聚簇索引2.png)

   可以看到，每一个主键内部维护了剩下的数据部分，也就是当我们执行如下sql时：

  ```mysql
  SELECT * FROM t1 WHERE a = 2;
  ```

  它会先去**聚簇索引**产生的`B+`树去找a=2的节点，首先在根节点中，发现**2 < 5**，于是找左节点，发现**2 < 3**，于是又找3的左节点，此时就找到了2。这个时候就直接将节点2中附带的信息**222b**给返回出去了，所以此时，它走了索引。那么，如何判断一个查询条件有没有走索引呢？这个是由mysql中的**查询优化器**来决定的，对于**查询优化器**而言，它会判断`走索引以及走了索引后的回表操作`和`全表扫描`两种处理方式哪种方式耗时比较少。**ps: 这里涉及的查询优化器和回表操作的概念在后面会提到**

### 3.4 InnoDB二级索引(辅助索引)

* 通过上述描述可以知道，对于InnoDb存储引擎而言，在插入数据的时候会默认创建**聚簇索引**。假设我们需要为其他字段创建索引呢？此时这个索引叫**二级索引(辅助索引)**。为什么这么叫呢？请看下面的分析

* 假设我们要为bcd三个字段创建一个**联合索引**，同上，我们先统计下bcd字段的所有可能出现的值：**111、222、322、311、235、644、455、888、219、742、**，排序后就是`111 > 219 > 222 > 235 > 311 > 322 > 455 > 644 > 742 > 888`。同上，我们使用现有的工具[https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html](https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html)来构建b+树

  ![bcd索引b+树](https://github.com/AvengerEug/java-backend/blob/develop/mysql/bcd索引B+树.png)

  同理，mysql构建出来的B+树会在此基础上加点东西，如下图：

  ![bcd索引B+树2](https://github.com/AvengerEug/java-backend/blob/develop/mysql/bcd索引B+树2.png)

  由上可知，在bcd每个节点内部都维护了当前数据对应的主键，之所以叫做**辅助索引**，就是因为在mysql中，最终都会通过主键去找数据(因为这能保证一定会走聚簇索引)，而我们自定义的索引中，内部维护了当前数据对应的主键，所以最后还会根据这个主键去走聚簇索引。**注意: 这里的每一个节点(数据页)被加载一次就会产生一次IO，之前我们说过，InnerDB引擎中的数据单位为页，在图中可能没有体现出来**。上述所说的`回表`的概念就是：在辅助索引确认的情况下，还要根据辅助索引各节点中对应的主键到`聚簇索引`中去找对应的数据。

### 3.5 索引优缺点

* 一个原则：**一个索引对应一棵B+数**，

* 缺点：

  ```txt
  1. 当我们插入、更新数据的时候，mysql都要重新维护这棵B+树。
  2. 每一个节点就是一个页，所以还需要耗费磁盘中的空间来存储这些数据
  ```

* 优点：加快查询速度

### 3.6 索引实战

* 有了上述图之后，其实一个查询语句有没有走索引就变得很简单了。

* `以下说的走索引只能说有对应的索引存在，具体查询过程中能不能走，还要根据查询优化器得出的结论而言。这里咱们可以做一个猜测，具体的能否走索引，咱们还要根据EXPLAIN关键字来分析`

  ```mysql
  -- 1. 不用说，本来联合索引就是根据bcd来的，肯定会走索引
    select * from t1 where b = 1 and c = 1 and d = 1;
  
  -- 2. b = 1, 可以根据索引定位到b=1的一些节点(页)，所以也是可以走索引的
    select * from t1 where b = 1;
    
  -- 3. 走不了索引，因为只凭一个c mysql无法确认需要定位到节点(页)
    select * from t1 where c = 1;
    
  -- 4. 无法走索引，bcd索引是按照bcd的顺序来搭建的b+树，要定位一个节点(页)，首先必须要定位到b的具体的值或范围
    select * from t1 where b like '%111%';
  
  -- 5. 可以走索引，因为能确定b的一些范围  ->  能确定一些节点
    select * from t1 where b > 1 and b < 20;
    
  -- 6. 能走索引，因为能先根据b > 1 定位到一些节点
    select * from t1 where b > 1 and c > 1;
    
  -- 7. 可以走索引，因为bcd索引对应的b+树就是根据b、c、d字段升序排列的
    select * from t1 order by b, c, d;
  
  -- 8. 不能走索引
    select * from t1 order by b, d, c;
    
  -- 9. 不能走索引
    select * from t1 order by b, c ASC , d DESC;
  ```

* 总结:

  ```txt
  上述说的走索引只能说有对应的索引存在，具体查询过程中能不能走，还要根据查询优化器得出的结论而言。有可能有些语句能走存在的索引，但是查询优化器觉得走索引要花费的时候可能还比全表扫描花费的时间要长。此时最终执行的结果可能是全表扫描
  ```

### 3.7 mysql查询优化器

* 上面说到了，有索引能走至于最后到底走不走还是由mysql的查询优化器决定的，下面我们来了解下mysql的查询优化器

* 如何查看执行一条sql的查询优化器的具体操作呢？

  步骤如下：

  ```txt
  1. 执行如下命令SET optimizer_trace="enabled=on";打开查询优化器的日志追踪功能
  2. 执行一条sql
  3. 运行如下命令:
     SELECT trace FROM information_schema.OPTIMIZER_TRACE;
  ```

* 案例：分析`select * from t1 where b = 1 and c > b;`语句的查询优化器日志，最终会得到如下信息：

  ```json
  trace: {
    "steps": [
      {
        "join_preparation": {
          "select#": 1,
          "steps": [
            {
              "expanded_query": "/* select#1 */ select `t1`.`a` AS `a`,`t1`.`b` AS `b`,`t1`.`c` AS `c`,`t1`.`d` AS `d`,`t1`.`e` AS `e` from `t1` where ((`t1`.`b` = 1) and (`t1`.`c` > `t1`.`b`))"
            }
          ]
        }
      },
      {
        "join_optimization": {
          "select#": 1,
          "steps": [
            {
              "condition_processing": {
                "condition": "WHERE",
                "original_condition": "((`t1`.`b` = 1) and (`t1`.`c` > `t1`.`b`))",
                "steps": [
                  {
                    "transformation": "equality_propagation",
                    "resulting_condition": "((`t1`.`c` > 1) and multiple equal(1, `t1`.`b`))"
                  },
                  {
                    "transformation": "constant_propagation",
                    "resulting_condition": "((`t1`.`c` > 1) and multiple equal(1, `t1`.`b`))"
                  },
                  {
                    "transformation": "trivial_condition_removal",
                    "resulting_condition": "((`t1`.`c` > 1) and multiple equal(1, `t1`.`b`))"
                  }
                ]
              }
            },
            {
              "substitute_generated_columns": {
              }
            },
            {
              "table_dependencies": [
                {
                  "table": "`t1`",
                  "row_may_be_null": false,
                  "map_bit": 0,
                  "depends_on_map_bits": [
                  ]
                }
              ]
            },
            {
              "ref_optimizer_key_uses": [
                {
                  "table": "`t1`",
                  "field": "b",
                  "equals": "1",
                  "null_rejecting": false
                }
              ]
            },
            {
              "rows_estimation": [
                {
                  "table": "`t1`",
                  "range_analysis": {
                    "table_scan": {
                      "rows": 10,
                      "cost": 5.1
                    },
                    "potential_range_indexes": [
                      {
                        "index": "PRIMARY",
                        "usable": false,
                        "cause": "not_applicable"
                      },
                      {
                        "index": "idx_t1_bcd",
                        "usable": true,
                        "key_parts": [
                          "b",
                          "c",
                          "d",
                          "a"
                        ]
                      }
                    ],
                    "setup_range_conditions": [
                    ],
                    "group_index_range": {
                      "chosen": false,
                      "cause": "not_group_by_or_distinct"
                    },
                    "analyzing_range_alternatives": {
                      "range_scan_alternatives": [
                        {
                          "index": "idx_t1_bcd",
                          "ranges": [
                            "1 <= b <= 1 AND 1 < c"
                          ],
                          "index_dives_for_eq_ranges": true,
                          "rowid_ordered": false,
                          "using_mrr": false,
                          "index_only": false,
                          "rows": 1,
                          "cost": 2.21,
                          "chosen": true
                        }
                      ],
                      "analyzing_roworder_intersect": {
                        "usable": false,
                        "cause": "too_few_roworder_scans"
                      }
                    },
                    "chosen_range_access_summary": {
                      "range_access_plan": {
                        "type": "range_scan",
                        "index": "idx_t1_bcd",
                        "rows": 1,
                        "ranges": [
                          "1 <= b <= 1 AND 1 < c"
                        ]
                      },
                      "rows_for_plan": 1,
                      "cost_for_plan": 2.21,
                      "chosen": true
                    }
                  }
                }
              ]
            },
            {
              "considered_execution_plans": [
                {
                  "plan_prefix": [
                  ],
                  "table": "`t1`",
                  "best_access_path": {
                    "considered_access_paths": [
                      {
                        "access_type": "ref",
                        "index": "idx_t1_bcd",
                        "rows": 1.4286,
                        "cost": 1.7143,
                        "chosen": true
                      },
                      {
                        "rows_to_scan": 1,
                        "access_type": "range",
                        "range_details": {
                          "used_index": "idx_t1_bcd"
                        },
                        "resulting_rows": 1,
                        "cost": 2.41,
                        "chosen": false
                      }
                    ]
                  },
                  "condition_filtering_pct": 100,
                  "rows_for_plan": 1.4286,
                  "cost_for_plan": 1.7143,
                  "chosen": true
                }
              ]
            },
            {
              "access_type_changed": {
                "table": "`t1`",
                "index": "idx_t1_bcd",
                "old_type": "ref",
                "new_type": "range",
                "cause": "uses_more_keyparts"
              }
            },
            {
              "attaching_conditions_to_tables": {
                "original_condition": "((`t1`.`b` = 1) and (`t1`.`c` > 1))",
                "attached_conditions_computation": [
                ],
                "attached_conditions_summary": [
                  {
                    "table": "`t1`",
                    "attached": "((`t1`.`b` = 1) and (`t1`.`c` > 1))"
                  }
                ]
              }
            },
            {
              "refine_plan": [
                {
                  "table": "`t1`",
                  "pushed_index_condition": "((`t1`.`b` = 1) and (`t1`.`c` > 1))",
                  "table_condition_attached": null
                }
              ]
            }
          ]
        }
      },
      {
        "join_execution": {
          "select#": 1,
          "steps": [
          ]
        }
      }
    ]
  }
  ```

  分析：

  * **join_preparation**阶段(预准备阶段)

    

    ```json
    {
        "join_preparation": {
            "select#": 1,
            "steps": [
                {
                    "expanded_query": "/* select#1 */ select `t1`.`a` AS `a`,`t1`.`b` AS `b`,`t1`.`c` AS `c`,`t1`.`d` AS `d`,`t1`.`e` AS `e` from `t1` where ((`t1`.`b` = 1) and (`t1`.`c` > `t1`.`b`))"
                }
            ]
        }
    }
    
    //此阶段一般是对sql语句进行整理，即内部会为变量添加别名、标识字段属于哪个表等等
    ```

  * **join_optimization**阶段

    ```json
    // 此阶段为优化阶段，设计的部分比较多，但只需要查看最终要的"rows_estimation"部分即可:
    {
        "rows_estimation": [
            {
                "table": "`t1`",
                "range_analysis": {
                    // 全表扫描的成本
                    "table_scan": {
                        "rows": 10,
                        // 权重为 5.1
                        "cost": 5.1  
                    },
                    // 可能存在的范围索引
                    "potential_range_indexes": [ 
                        {
                            "index": "PRIMARY",
                            // 表示主键索引不可用
                            "usable": false,  
                            "cause": "not_applicable"
                        },
                        {
                            "index": "idx_t1_bcd",
                            // 表示可以使用此索引
                            "usable": true, 
                            "key_parts": [
                                "b",
                                "c",
                                "d",
                                "a"
                            ]
                        }
                    ],
                    "setup_range_conditions": [
                    ],
                    "group_index_range": {
                        "chosen": false,
                        "cause": "not_group_by_or_distinct"
                    },
                    // 分析idx_t1_bcd索引
                    "analyzing_range_alternatives": { 
                        "range_scan_alternatives": [
                            {
                                "index": "idx_t1_bcd",
                                "ranges": [
                                    "1 <= b <= 1 AND 1 < c"
                                ],
                                "index_dives_for_eq_ranges": true,
                                "rowid_ordered": false,
                                "using_mrr": false,
                                "index_only": false,
                                "rows": 1,
                                // 发现最后的权重为2.21
                                "cost": 2.21,  
                                "chosen": true
                            }
                        ],
                        "analyzing_roworder_intersect": {
                            "usable": false,
                            "cause": "too_few_roworder_scans"
                        }
                    },
                    // 最终决定使用什么策略
                    "chosen_range_access_summary": {  
                        "range_access_plan": {
                            "type": "range_scan",
                            "index": "idx_t1_bcd",
                            "rows": 1,
                            "ranges": [
                                "1 <= b <= 1 AND 1 < c"
                            ]
                        },
                        "rows_for_plan": 1,
                        "cost_for_plan": 2.21,
                        "chosen": true
                    }
                }
            }
        ]
    }
    ```

    通过`chosen_range_access_summary`中的结果，最终使用的是**idx_t1_bcd**索引，而且是通过**范围**查找的。

  * 其他部分显得不那么重要了，直接忽略。。。。

* 如何做决策？该进行全表扫描还是走索引?

  在mysql中，有一个约定俗成的规定：如果要加载一个页的数据，则需要`1`(可以理解成一个权重)，如果要读取一行数据则需要`0.2`。所以，针对查询优化器而言，它每次查询时需要确认全表扫描的权重，其次再根据具体条件去确定扫描所需的权重(如果是辅助索引的话，扫描时间还要包含回表的的时间)。最终将全表扫描得出的权重与根据条件查询得出的权重进行比较，权重小的方案获胜.

  * 全表扫描权重计算公式：`全表扫描成本 = 表中数据所占的页数 * 1 + 行数 * 0.2`

    * 使用如下命令查看表中的详细信息(包括数据长度等信息):

      ```mysql
      -- 此表有可能会出现数据不同步的情况，因为在mysql中，如果修改的数据超过整体的百分之10的话，mysql会开一个线程去同步SHOW TABLE STATUS LIKE '表名';命令的结果
      -- 除此之外，mysql还支持手动同步，同步命令: 
      -- ANALYZE TABLE '表名'
      SHOW TABLE STATUS LIKE '表名';
      ```

      ![查看表中所有数据的大小](https://github.com/AvengerEug/java-backend/blob/develop/mysql/查看表中所有数据的大小.png)

      所以t1表的全表扫描的成本为：`Data_length / 16384 * 1 + Rows * 0.2 = 16384/16384 * 1 + 10 * 0.2 = 3`  即全表扫描时的权重为`3`  => 这里为什么会与上述的`table_scan`得出的全表扫描权重`5.1`不一致呢？`这里待确认为什么会这样？？？？？？？？？？`。不过按照上述mysql自己输出的记录来看，最终走的是`idx_t1_bcd`索引，类型为`range_scan`。使用explain查看如下：

      ![案例](https://github.com/AvengerEug/java-backend/blob/develop/mysql/案例.png)


