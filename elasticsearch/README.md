## Elasticsearch(7.4.2  <=> 7.x)

### 一、Elasticsearch介绍

#### 1.1 是什么？

```txt
Elasticsearch时一个分布式的开源搜索和分析引擎，适用于所有类型的数据，包括文本、数字、地理空间、结构化和非结构
化数据。Elasticsearch基于Apache Lucene的基础上开发而成，于2010年首次发布，它将Lucene复杂的api操作抽象成非常
简单的REST风格的API。以简单的REST风格API、分布式特性、速度和扩展性而闻名，是Elastic Stack的核心组件。人们通常
将Elastic Stack称为ELK Stack(代指Elasticsearch、Logstash、Kibana)。
```

#### 1.2 有什么用？

```txt
1、应用程序搜索
2、网站搜索
3、企业搜索
4、日志处理和分析
5、基础设施指标和容器监测
6、应用程序性能监测
7、地理空间数据分析和可视化
8、安全分析
9、业务分析

#  存储、检索、分析
```

#### 1.3 为什么要用它？

```txt
貌似MySQL也支持对数据的存储、检索和分析，那为什么还要用Elasticsearch？俗话说：术业有专攻。MySQL在数据的落地
(持久化存储与管理 CRUD)方面做的比较好，虽然它也有检索的功能，但在数据量大的情况下会导致检索速度下降(MySQL在单
表数据达到百万以上时，检索数据将会出现明显下降)，并且它的检索功能在同一字段检索多个value时，会出现效率低下的情
况。eg: 我在商品列表中搜素'苹果好吃'四字，且对应检索的字段为goods_name, 如果此时需要把goods_name中包
含‘苹’、‘果’、‘好’、‘吃’这四个关键字的商品给搜索出来，我们可能会将key拆分，然后针对goods_name对这四个字做模糊
查询，这样也能实现需求。了解MySQL索引原理的人都知道，这样的一个查询必然会进行全表扫描，全表扫描表示此条SQL查询
效率是极低的，一般都需要进行优化。所以，为了解决MySQL在此需求效率低下的问题，我们可以引入Elasticsearch，它是一
个神器，就算数据量是亿级，检索速度也是毫秒级别。

同时，官方文档的解释为：
Elasticsearch 很快。 由于 Elasticsearch 是在 Lucene 基础上构建而成的，所以在全文本搜索方面表现十分出色。
Elasticsearch 同时还是一个近实时的搜索平台，这意味着从文档索引操作到文档变为可搜索状态之间的延时很短，一般只有
一秒。因此，Elasticsearch 非常适用于对时间有严苛要求的用例，例如安全分析和基础设施监测。

Elasticsearch 具有分布式的本质特征。 Elasticsearch 中存储的文档分布在不同的容器中，这些容器称为分片，可以进行
复制以提供数据冗余副本，以防发生硬件故障。Elasticsearch 的分布式特性使得它可以扩展至数百台（甚至数千台）服务
器，并处理 PB 量级的数据。

Elasticsearch 包含一系列广泛的功能。 除了速度、可扩展性和弹性等优势以外，Elasticsearch 还有大量强大的内置功能
（例如数据汇总和索引生命周期管理），可以方便用户更加高效地存储和搜索数据。

Elastic Stack 简化了数据采集、可视化和报告过程。 通过与 Beats 和 Logstash 进行集成，用户能够在向 
Elasticsearch 中索引数据之前轻松地处理数据。同时，Kibana 不仅可针对 Elasticsearch 数据提供实时可视化，同时还
提供 UI 以便用户快速访问应用程序性能监测 (APM)、日志和基础设施指标等数据。
```

#### 1.4 工作原理

```txt
原始数据会从多个来源（包括日志、系统指标和网络应用程序）输入到 Elasticsearch 中。数据采集指在 Elasticsearch 
中进行索引之前解析、标准化并充实这些原始数据的过程。这些数据在 Elasticsearch 中索引完成之后，用户便可针对他们
的数据运行复杂的查询，并使用聚合来检索自身数据的复杂汇总。在 Kibana 中，用户可以基于自己的数据创建强大的可视
化，分享仪表板，并对 Elastic Stack 进行管理。
```

#### 1.5 如何学习

```txt
Elasticsearch的学习，建议参考官方的英文文档，因为它比较新。当然，它也有一些中文文档，缺点就是中文文档翻译的是
比较老的Elasticsearch版本(基于 Elasticsearch 2.x)，比较新的版本是没有中文文档的。
```

### 二、与MySQL的对比

* 先回顾下在MySQL中如果要存一条数据，我们的一个流程是怎样的？

  > **建库  => 建表 => 插入数据**

  在Elasticsearch中也是如此，只不过使用的名字不一样，流程如下：

  > **建索引 => 建类型 => 插入文档**

  因此，通过上述两个流程的对比，我们可以得出如下的对比结果：

  | MySQL  |       |      Elasticsearch       |
  | :----: | :---: | :----------------------: |
  | 数据库 | <===> |       索引(Index)        |
  |   表   | <===> |        类型(Type)        |
  | 表字段 | <===> |           属性           |
  |  数据  | <===> | 文档(Document，JSON格式) |

* 几个常用的白话：

  > 1、“索引” 二字的概念
  >
  > ​     作为名词时：它类比于MySQL数据库。
  >
  > ​     作为动词时：它类比于MySQL中的插入一条数据。eg: 往ES中索引一条数据  ==> 往ES中插入一条数据
  > 2、装ES相当于装了MySQL
  >
  > 3、创建索引相当于在MySQL中创建数据库
  >
  > 4、创建类型相当于在MySQL中创建表
  >
  > 5、插入文档相当于在MySQL中插入数据
  >
  > 6、为类型添加一个属性相当于MySQL中为表添加一个字段

* 

### 三、Docker部署与安装

* docker安装elasticsearch

  ```shell
  # 1. 拉取镜像
  docker pull elasticsearch:7.4.2
  
  # 2. 本地创建配置文件，控制docker中es中的运行状态
  mkdir -p /mydata/elasticsearch/config
  mkdir -p /mydata/elasticsearch/data
  chmod -R 777 /mydata/elasticsearch
  echo "http.host: 0.0.0.0" >> /mydata/elasticsearch/config/elasticsearch.yml
  
  # 3. 启动es容器 --> 9300是es在集群时的通信端口，挂载了配置文件、数据、插件的目录至本地
  # --restart=always(主机重启后自动运行)
  docker run --name es --restart=always -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e ES_JAVA_OPTS="-Xms64m -Xmx512m" \
  -v /mydata/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
  -v /mydata/elasticsearch/data:/usr/share/elasticsearch/data \
  -v /mydata/elasticsearch/plugins:/usr/share/elasticsearch/plugins \
  -d elasticsearch:7.4.2
  ```

* docker 安装kibana

  ```shell
  # 执行如下命令，若本机无对应镜像，则会先拉取镜像再启动镜像, es的地址要填写真实地址，就算
  # kibana容器和es容器部署在同一台机器上也不能填写127.0.0.1, 不然的话kibana会从自己的docker容器中去查找
  # 发现并没有es相关的服务
  docker run --name kibana --restart=always -e ELASTICSEARCH_HOSTS=http://es地址:es端口 -p 5601:5601 -d kibana:7.4.2
  ```

### 四、常见api

* 使用curl命令操作ES教程：[点击传送门跳转](https://www.elastic.co/guide/en/elasticsearch/reference/7.8/getting-started-install.html#gs-curl)

#### 4.1 _cat

* **GET /_cat**

  ```shell
  # 获取ES集群下所有节点的相关信息
  curl -X GET "localhost:9200/_cat"
  ```

* **GET /_cat/master**

  ```shell
  # 获取到ES集群下master节点的信息
  curl -X GET "localhost:9200/_cat/master"
  ```

* **GET /_cat/health**

  ```shell
  # 检查集群下的各节点的监控情况
  curl -X GET "localhost:9200/_cat/health"
  ```
  
* **GET /_cat/indices**

  ```shell
  # 查看所有的索引 # 对应MySQL就是获取所有的数据库, 类似于 SHOW DATABASES; 命令
  curl -X GET "localhost:9200/_cat/indices"
  ```

#### 4.2 ES存储文档

##### 4.2.1 创建与新增文档

* PUT方法支持创建和新增文档，但有一个特殊点：**`必须要指定文档的id`**，如果文档id在ES中不存在，则创建文档，如果存在，则更新文档。

> ```shell
> PUT /customer/_doc/1
> {
>   "name": "John Doe"
> }
> 
> # 在customer索引中的_doc类型中创建id为1的数据
> curl -X PUT "localhost:9200/customer/_doc/1" -H 'Content-Type: application/json' -d \
> '
>   {
>     "name": "John Doe"
>   }
> '
> 
> # 响应(所有带下划线的key都是元数据)
> {
>     "_index":"customer",  ==> 表示在customer索引下(对应MySQL就是在此数据库下)
>     "_type":"_doc", ==> 在_doc类型下(对应MySQL就是在此表下)
>     "_id":"1",  ==> 在ES中customer索引的_doc类型下存储的文档id为1
>     "_version":1, ==> id为1对应文档的版本为1，每更新一次就会递增一次
>     "result":"created", ==> 当前请求的结果是创建文档，如果文档id已经存在，此时会变成updated
>     "_shards":{ ==> 分片相关的配置，待确定
>         "total":2,
>         "successful":1,
>         "failed":0
>     },
>     "_seq_no":0, ==> 乐观锁并发控制变量，每次更新就会加1
>     "_primary_term":1 ==> 同_seq_no, 也是乐观锁控制变量。主分片重新分配或重启，此字段或发生变化
> }
> ```

* POST方法创建和新增文档，**如果携带了文档ID，处理规则和PUT方法类似**。如果没有携带文档ID，则每次请求都是新增文档

> ```shell
> POST /customer/_doc
> {
>   "name": "John Doe For POST"
> }
> 
> # 在customer索引中的_doc类型中创建id为1的数据
> curl -X POST "localhost:9200/customer/_doc" -H 'Content-Type: application/json' -d \
> '
>   {
>     "name": "John Doe For POST"
>   }
> '
> 
> # 响应
> {
>     "_index":"customer",
>     "_type":"_doc",
>     "_id":"c6z5uHMBMgio-h1Kw_Ve",  ==> 文档的id是es生成的
>     "_version":1,
>     "result":"created",
>     "_shards":{
>         "total":2,
>         "successful":1,
>         "failed":0
>     },
>     "_seq_no":1,
>     "_primary_term":1
> }
> ```

* **POST + _update更新文档**

  ```shell
  curl -X PUT "localhost:9200/customer/_doc/1/_update" -H "Content-Type: application/json" -d \
  '
  {
     "doc": {
         "name": "John Doe1"
     }
  }
  '
  
  # ps: 之前文档中的name为"John Doe", 运行上段命令后，响应结果如下：
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":3,
      "result":"updated",  # result 为updated
      "_shards":{
          "total":2,
          "successful":1,
          "failed":0
      },
      "_seq_no":3,
      "_primary_term":1
  }
  
  # 当再次执行上段命令后，响应结果如下：
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":3,
      "result":"noop",   # result 为noop(no operation)
      "_shards":{
          "total":0,
          "successful":0,
          "failed":0
      },
      "_seq_no":3,
      "_primary_term":1
  }
  
  # 几个结论：
  使用POST + _update更新文档的方式来更新文档有几个特点：
  1、请求体必须为如下格式，key一定要为doc
  {
     "doc": {
         // 具体更新的内容，eg: "name": "John Doe1"
     }
  }
  2、若发送进去的文档数据和现在在ES中的数据相同时，此时的响应体中的result为"noop", 并且，版本号字段version、乐观锁字段_seq_no和_primary_term都不会发生变化
  ```

* **POST + 不带_update**

  ```shell
  curl -X POST "localhost:9200/customer/_doc/1/" -H "Content-Type: application/json" -d \
  '{ "name": "John Doe"}'
  
  # 不带_update的post方式更新文档，不会检查原来的数据，直接覆盖更新，
  # 且版本号、乐观锁字段_seq_no和_primary_term都会发生变化，而且相应中的result字段的值为updated
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":3,
      "result":"updated",
      .....
  }
  ```

  > 结论：post + _update 结合使用，更新文档前会做校验，如果没有任何修改，则不做任何处理，此时的版本号、乐观锁相关字段都不会发生变化

##### 4.2.2 ES中乐观锁的使用

* 在ES中也支持乐观锁，乐观锁的条件是由ES生成的元数据决定的，当我们来获取文档ID为1的文档时：

  ```shell
  curl -X GET "localhost:9200/customer/_doc/1?pretty"
  
  # 响应
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":1,
      "_seq_no":0,
      "_primary_term":1,
      "found":true,
      "_source":{
          "name":"John Doe"
      }
  }
  ```

  从上述响应中可以知道，它的元数据中存在两个字段：**\_seq_no和_primary_term**，假设在高并发情况下，有两个线程想分别更新文档id为1的数据的name为"John Doe1"和"John Doe2"，此时我们可以使用ES内置的乐观锁来保证线程安全：

  ```shell
  # 线程1更新文档id为1的REST请求，query参数if_seq_no=0表示，当_seq_no字段为0时，再校验后面的query参数
  # 当所有带if前缀的query参数都校验通过后，才会执行更新操作
  curl -X PUT "localhost:9200/customer/_doc/1?if_seq_no=0&if_primary_term=1" -H 'Content-Type: application/json' -d \
  '
    {
      "name": "John Doe1"
    }
  '
  
  # 线程2更新文档id为1的REST请求
  curl -X PUT "localhost:9200/customer/_doc/1?if_seq_no=0&if_primary_term=1" -H 'Content-Type: application/json' -d \
  '
    {
      "name": "John Doe2"
    }
  '
  ```

  假设线程1的整个HTTP请求流程比线程2的快(带宽、DNS服务器性能等原因影响)，此时线程1首先完成了文档id为1的更新，此时文档id为1的name变成了"John Doe1"，并且响应结果为：

  ```json
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":2,
      "result":"updated",
      "_shards":{
          "total":2,
          "successful":1,
          "failed":0
      },
      "_seq_no":2,
      "_primary_term":1
  }
  ```

  会发现，**\_seq_no和_primary_term**分别变成了`2`和`1`。此时线程2的请求肯定显示更新失败，结果如下：

  ```json
  {
      "error":{
          "root_cause":[
              {
                  "type":"version_conflict_engine_exception",
                  "reason":"[1]: version conflict, required seqNo [0], primary term [1]. current document has seqNo [2] and primary term [1]",
                  "index_uuid":"Sf3Mr8nNTvC1KujAntaaVw",
                  "shard":"0",
                  "index":"customer"
              }
          ],
          "type":"version_conflict_engine_exception",
          "reason":"[1]: version conflict, required seqNo [0], primary term [1]. current document has seqNo [2] and primary term [1]",
          "index_uuid":"Sf3Mr8nNTvC1KujAntaaVw",
          "shard":"0",
          "index":"customer"
      },
      "status":409
  }
  ```

  响应状态为409，表示请求冲突，达到了乐观锁的效果，如果线程2(在保证线程安全的情况下)还是想更新文档id为1的数据的话，应该要发送get请求，获取到最新的**\_seq_no和_primary_term**

##### 4.2.3 获取指定id的文档(数据)

* 获取id为1的文档信息

  ```shell
  curl -X GET "localhost:9200/customer/_doc/1?pretty"
  
  # 响应
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":2,
      "_seq_no":2,
      "_primary_term":1,
      "found":true,
      "_source":{   # 我们手动保存进去的内容
          "name":"John Doe1"
      }
  }
  ```

##### 4.2.4 删除文档(数据)

* ```shell
  DELETE /customer/_doc/1
  
  curl -X DELETE "localhost:9200/customer/_doc/1"
  
  # 响应结果
  {
      "_index":"customer",
      "_type":"_doc",
      "_id":"1",
      "_version":5,
      "result":"deleted",  # 执行的结果为deleted
      "_shards":{
          "total":2,
          "successful":1,
          "failed":0
      },
      "_seq_no":5,
      "_primary_term":1
  }
  ```

##### 4.2.5 删除索引(数据库)

* ```shell
  DELETE /customer/_doc
  
  curl -X DELETE "localhost:9200/customer"
  
  # 响应结果
  {"acknowledged":true}
  ```

##### 4.2.6 ES删除类型(表)

* ES不支持删除类型的操作，如果要删除的话，可以把索引删除或者把类型中的文档都清空，来实现变相删除

##### 4.2.7 批量导入文档(基于.json后缀名文件)

* ```shell
  # post请求，在customer索引下的_doc类型下执行批量操作(_bulk表示批量操作)
  # 语法格式，请求头的Content-Type为application/text
  POST /customer/_doc/_bulk
  {action: {metadata}} \n
  {requestBody} \n
  {action: {metadata}} \n
  {requestBody} \n
  
  # 其中，action可以为：delete、create、index、update。其中create和index都表示为创建(索引)一个文档，
  # 并且create、index、update下方都要跟一个json对象来表示要操作的的对象.
  # 在ES中的批量导入数据操作中，每个操作都是独立的，不互相影响，若其他的操作失败了，也不会影响自己。
  ```
  
* 执行如下命令

  ```shell
  # 当前目录下，存在一个叫accounts.json的文件，其内部内容存储的格式和上述的一致
  # 表示将accounts.json中的数据批量导入至bank索引中，要在accounts.json文件所在目录中执行如下命令
  curl -H "Content-Type: application/json" -X POST "localhost:9200/bank/_bulk" --data-binary "@accounts.json"
  # 使用上述命令执行完毕后，会创建一个/bank的索引，因为我们没有指定类型，所以默认使用的是_doc
  
  # 因此建议使用如下命令，让数据存储到指定的类型下(若上述命令执行完后，执行下面的命令会失败，
  # 原因是accounts.json中没有显示的指定要将数据存入哪个type中，而在执行上面那段命令时，已经将数据
  # 存入默认的_doc类型中了，而我们在执行指定了type的批量导入操作时，这时候ES不知道该把索引放在
  # 哪个type下了，所以es希望accounts.json数据中至少要指定一个type，所以返回了400错误，要解决
  # 这个问题我们可以修改accounts.json的数据，让它们显示的加入到指定的type中去，或者把bank索引
  # 删除了，再执行此段命令 curl -X DELETE "localhost:9200/bank") 
  curl -H "Content-Type: application/json" -X POST "localhost:9200/bank/account/_bulk" --data-binary "@accounts.json"
  ```

  **PS: accounts.json文件的地址为：[https://raw.githubusercontent.com/elastic/elasticsearch/master/docs/src/test/resources/accounts.json](https://raw.githubusercontent.com/elastic/elasticsearch/master/docs/src/test/resources/accounts.json)**，来源于官方文档：[https://www.elastic.co/guide/en/elasticsearch/reference/7.4/getting-started-index.html#getting-started-batch-processing](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/getting-started-index.html#getting-started-batch-processing)

#### 4.3 ES检索文档

##### 4.3.1 query参数和请求体参数(Query DSL，常用)检索

* 根据account_number字段来升序检索

  ```shell
  # 使用query参数检索
  GET /bank/_search?q=*&sort=account_number:asc
  curl -X GET "localhost:9200/bank/_search?pretty&q=*&sort=account_number:asc"
  
  # 使用请求体参数检索
  GET /bank/_search
  { 
    "query": { "match_all": {} },  # query代表查询条件，若没有，则直接使用match_all
    "sort": [  # sort代表排序规则
      { "account_number": { "order": "asc" }}
    ]
  }
  
  # ps: 写请求体的json对象时，要注意它的格式，使用tab或两个空格缩进，不要存在两个空格和三个空格都存在的
  # 混合格式
  curl -X GET "localhost:9200/bank/_search?pretty" -H "Content-Type: application/json" -d \
  '
  { 
    "query": { "match_all": {} },
    "sort": [
      { "account_number": { "order": "asc" }}
    ]
  }
  '
  
  # 结果
  {
      "took":24,          # 耗时花费了24毫秒
      "timed_out":false,  # 未超时
      "_shards":{         # 分片机制(与集群相关)
          "total":1,
          "successful":1,
          "skipped":0,
          "failed":0
      },
      "hits":{            # 命中相关的信息
          "total":{       
              "value":1000,   # 匹配到的记录数
              "relation":"eq"
          },
          "max_score":null,  # 最大得分，在模糊查找时，此字段很重要
          "hits":[  # 命中的记录，只返回了10条记录，
              {
                  "_index":"bank",  # 所处的索引
                  "_type":"account", # 所处的类型
                  "_id":"0", # 文档的id
                  "_score":null, # 当前记录的得分
                  "_source":{  # 文档保存的信息
                      "account_number":0,
                      "balance":16623,
                      "firstname":"Bradshaw",
                      "lastname":"Mckenzie",
                      "age":29,
                      "gender":"F",
                      "address":"244 Columbus Place",
                      "employer":"Euron",
                      "email":"bradshawmckenzie@euron.com",
                      "city":"Hobucken",
                      "state":"CO"
                  },
                  "sort":[  # 文档的排序
                      0
                  ]
              },
              .....
          ]
      }
  }
  ```

##### 4.3.2 Query DSL查询

* 善用kibana的Dev Tools(http://kibana host:port/app/kibana#/dev_tools/console?_g=())工具，能提供DSL快捷查询，所以，我们只需要了解ES中一些查找的关键字特性。

  ```shell
  GET /bank/_search
  {
    "query": {
      "match_all": {}
    },
    "sort": [
      {
        "balance": {
          "order": "desc"
        }
      }
    ],
    "from": 0,
    "size": 10,
    "_source": ["firstname", "lastname"]
  }
  
  # 此段查询表示，在/bank索引(/bank/_search)中，对所有的文档(match_all)的balance字段降序检索("order": "desc")
  # 并且从排序后的第一个文档开始，只检索10条出来("from": 0, "size": 10)，并且只拿到firstname和lastname字段
  # ("_source": ["firstname", "lastname"])
  ```

* 总结DSL常见查询

  | 查询类别  |      方式       | 示例                                                         | 含义                                                         |
  | :-------: | :-------------: | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | query对象 |    match_all    | GET /bank/_search <br>{   "query": { "match_all": {} }}      | 查询索引中的所有文档，相当于MySQL中不带where条件的查询。但es不查出所有，它自带分页功能，默认查出前**10**条。 |
  | query对象 |      match      | GET /bank/_search?pretty<br/>{"query":{"match_phrase":{"address":"mill lane"}}} | 1. 如果match中匹配的是一个非字符串的字段，那么此时是一个精确查询<br>2. 如果match中匹配的是一个字符串，那么就是一个全文检索。会对这个字符串进行分词，然后将所有文档的对应属性中包含分词后的字符串的文档全部查找出来(**倒排索引的功劳，细看倒排索引章节**)，其中会按照得分进行排序。 |
  | query对象 |  match_phrase   | GET /bank/_search?pretty<br/>{<br/>  "query": { "match_phrase": { "address": "mill lane" } }<br/>} | 短语匹配，查找出仅包含部分短语的文档。示例中，能查找出文档中叫address的属性中包含**mill lane**这个短语的文档 |
  | query对象 |   multi_match   | GET /bank/_search<br/>{"query":{"multi_match":{"query":"Mill Neteria","fields":["address","employer"]}}} | 多字段匹配。针对query中的字符串，也会进行分词查询。最终查询出来的结果就是：`address`字段中包含**Mill**或**Neteria**以及`employer`字段中包含**Mill**或**Neteria**的文档 |
  | query对象 |      bool       | GET /bank/_search<br/>{"query":{"bool":{"must":[{"match":{"gender":"M"}},{"match":{"address":"mill"}}],"must_not":[{"match":{"age":"18"}}],"should":[{"match":{"lastname":"Wallace"}}]}}} | 复杂查询，合并多个查询条件。示例中的语句含义为：查询出**gender**包含**M**以及**address**包含**mill**，并且**age**不等于**18**，同时如果**lastname**包含**Wallace**那更好，可以提高相关性得分，**lastname**不包含**Wallace**也没关系 |
  | bool对象  |     filter      | GET /bank/_search<br/>{"query":{"bool":{"filter":{"range":{"age":{"gte":10,"lte":20}}}}}} | 结果过滤，但是filter不会贡献相关性得分。示例中是查找age属性在10-20之间的文档数据，但是，**它不会贡献相关性得分** |
  | query对象 |      term       | GET /bank/_search<br/>{"query":{"term":{"balance":16623}}}   | (**使用term匹配非文本类型：能查出一条数据**)非文本类型检索首选。term主要用于非文本类型属性的精确匹配。如果我们使用term来对文本类型属性进行检索，因为ES在检索过程中，会对文本类型的属性进行分词。因此，如果使用term来检索文本类型的话，是查不出来数据的。 |
| query对象 |      term       | GET /bank/_search<br/>{"query":{"term":{"address": "244 Columbus Place"}}} | (使用term匹配文本类型：一条数据都差不出来)ES在检索过程中会对"244 Columbus Place"进行分词处理，导致一条数据都查不出来，若把term改成match或者match_phrase的话，能检索出来数据。<br>`推荐使用term来进行非文本类型的精确查询` |
  | query对象 | match + keyword | GET /bank/_search<br/>{"query":{"match":{"address.keyword": "244 Columbus Place"}}} | match是支持模糊检索的，**若我们将match和keyword组合使用，那么效果和match_phrase一模一样，都是文本的精确匹配**<br>`在全文检索时，推荐使用match` |
  

#### 4.4 ES聚合分析数据

##### 4.4.1 聚合和分析

###### 复杂查询一

* 搜索address中包含mill的所有人的年龄分布(eg: 28岁的人有几个、38岁的人有几个)，年龄分布下的平均薪资(28岁的平均薪资、38岁的平均薪资)，所有人的平均年龄、平均薪资。但不显示这些人的详情(只查看聚合信息，设置size为0即可)

  ```shell
  GET /bank/_search
  {
    "query": {
      "match": {
        "address": "mill"
      }
    },
    "size": 0,
    "aggs": {
      "countGroupByAge": {
        "terms": {
          "field": "age",
          "size": 10
        },
        "aggs": {
          "balanceAvg": {
            "avg": {
              "field": "balance"
            }
          }
        }
      },
      "ageAvg": {
        "avg": {
          "field": "age"
        }
      },
      "balanceAvg": {
        "avg": {
          "field": "balance"
        }
      }
    }
  }
  
  # 总结：
  # 1、一个聚合中(aggs)可以包含多个聚合类型
  # 2、aggs在同层级下只能出现一次
  # 3、"size": 0 ==> 表示检索出来的记录为0
  # 4、聚合分析是额外出来的数据，与检索出来的数据是分开的
  # 5、聚合类型：term 类似于分组统计，统计出分组的个数(eg: 这个分组下有多个条记录)
  ```

###### 复杂查询二

* 按照年龄聚合，并且请求这些年龄段的人的平均薪资(嵌套聚合)

  ```shell
  GET /bank/_search
  {
    "query": {
      "match": {
        "address": "mill"
      }
    },
    "size": 0,
    "aggs": {
      "countGroupByAge": {
        "terms": {
          "field": "age",
          "size": 10
        },
        "aggs": {
          "balanceAvg": {
            "avg": {
              "field": "balance"
            }
          }
        }
      },
      "ageAvg": {
        "avg": {
          "field": "age"
        }
      },
      "balanceAvg": {
        "avg": {
          "field": "balance"
        }
      }
    }
  }
  ```

###### 复杂查询三

* 需求三：查出所有年龄分布，并且这些年龄中gender为M的平均薪资和F的平均薪资，以及这个年龄段的总体平均薪资 (eg: 31岁中gender为M的平均薪资，31岁中gender为F的平均薪资, 31岁中整体的平均薪资)

  ```shell
  GET /bank/_search
  {
    "query": {
      "match_all": {}
    }, 
    "size": 0,
    "aggs": {
      "groupByAge": {
        "terms": {
          "field": "age",
          "size": 10
        },
        "aggs": {
          "balanceAvgWithAge": {
            "avg": {
              "field": "balance"
            }
          },
          "groupByGender": {
            "terms": {
              "field": "gender.keyword",
              "size": 10
            },
            "aggs": {
              "balanceAvgWithGender": {
                "avg": {
                  "field": "balance"
                }
              }
            }
          }
        }
      }
    }
  }
  
  # 总结
  # 1、一个坑：在聚合字段时，如果字段类型是文本类型，需要使用它的keywords来进行聚合，
  #    否则es会进行分词，导致失败
  ```

#### 4.5 ES mapping映射

* 映射是定义文档其包含的字段的存储和索引的方式。例如，我们可以定义

  1、哪些字段应该被定义成全文检索字段

  2、哪些字段包含数字、日期或地理位置

  3、日期值的格式

  4、自定义规则来控制动态添加字段的控制

  类似于在MySQL中建表时对字段类型的定义，只不过ES能自动猜测字段的类型，所以我们不需要显示的指定

* mapping相关的官方文档：[https://www.elastic.co/guide/en/elasticsearch/reference/7.4/mapping.html](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/mapping.html)

* 几个规范

  | 属性对应的type |                    含义                    |
  | :------------: | :----------------------------------------: |
  |    keyword     |              检索时是精确查找              |
  |      text      | 检索时会全文检索(利用倒排索引，分词再检索) |

  具体的数据类型可参考[官网：mapping-types](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/mapping-types.html)

##### 4.5.1 获取索引中的映射信息

* 输入如下命令查看

  ```shell
  # 请求
  curl -X GET "localhost:9200/bank/_mapping?pretty"
  
  # 响应结果
  {
    "bank" : {
      "mappings" : {
        "properties" : {
          "account_number" : {
            "type" : "long"
          },
          "address" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "age" : {
            "type" : "long"
          },
          "balance" : {
            "type" : "long"
          },
          "city" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "email" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "employer" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "firstname" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "gender" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "lastname" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          },
          "state" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          }
        }
      }
    }
  }
  
  # 总结：
  # 1. 每个文本类型(text)都会有子属性，且类型为keywork, 这也就是为什么我们可以使用match + keyword
  #    来对文本类型进行精确匹配原因。
  # 2. 我们在往bank索引插入文档时，并没有显示的指定哪个字段是什么类型，全是由ES自己识别的。
  ```

##### 4.5.2 创建一个索引并指定属性的映射

* 在kibana中发送如下请求，或自己修改成curl命令：

  ```shell
  # 显示的指定了该索引下的属性以及属性对应的类型
  PUT /my-index
  {
    "mappings": {
      "properties": {
        "age":    { "type": "integer" },  
        "email":  { "type": "keyword"  }, 
        "name":   { "type": "text"  }     
      }
    }
  }
  ```

##### 4.5.3 动态为已存在的索引添加一个属性

* 在kibana中发送如下请求，或自己修改成curl命令：

  ```shell
  # 为my-index索引下新增一个employee-id属性，并且指定类型为keyword，
  # 同时设置了index为false表示此字段不会走检索流程，也就是不支持此字段的检索条件，
  # 相当于冗余了一个字段
  PUT /my-index/_mapping
  {
    "properties": {
      "employee-id": {
        "type": "keyword",
        "index": false
      }
    }
  }
  ```

##### 4.5.4 修改已经存在的映射 -- 数据迁移

* ES中不支持修改已经存在的映射，因为数据被索引至ES中的话，每条数据都有自己的索引规则，如果我们把它们的

  类型修改了，那么就会影响到所有关于此字段的规则，最终导致这些规则不可用。在[官网](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/mapping.html#update-mapping)中说到，如果我们要更新映射，能做的办法只有创建一个新映射，然后把就映射的数据迁移至新映射中，即**数据迁移**。

* 数据迁移

  ```txt
  我们在批量导入accounts.json文件中的数据时，有提供一种将数据批量导入/bank索引下的account类型下的方式，经过我们对mapping的学习中，我们发现ES建议我们不要使用type，并且在批量导入数据时，我们没有显示的创建映射，我们在查看/bank映射下的数据时，能发现age字段的类型为long。那么，我们就以这个为案例，做一个数据迁移，把/bank索引的account类型下的所有文档迁移到/bank下，并将age的字段类型改成integer。
  ```

  步骤如下：

> 1、创建新映射
>
> ```shell
> PUT /new-bank
> {
>   "mappings": {
>     "properties": {
>       "account_number": { "type": "long" },
>       "address": { "type": "text" },
>       "age": { "type": "integer" },
>       "city": { "type": "keyword" },
>       "email": { "type": "text" },
>       "employer":{ "type": "keyword" },
>       "firstname": { "type": "text" },
>       "gender": { "type": "keyword" },
>       "lastname": { "type": "keyword" },
>       "state": { "type": "keyword" }
>     }
>   }
> }
> ```
>
> 2、数据迁移
>
> ```shell
> # source: 源索引，如果原来的索引有type的话，还需要指定type，如果没有type，则可以省略type
> # dest: 目标索引
> POST _reindex
> {
>   "source": {
>     "index": "bank", 
>     "type": "account"
>   },
>   "dest": {
>     "index": "new-bank"
>   }
> }
> ```



#### 4.6 分词 

##### 4.6.1 标准分词器

* 官方文档：[https://www.elastic.co/guide/en/elasticsearch/reference/7.4/analysis-standard-analyzer.html#analysis-standard-analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/analysis-standard-analyzer.html#analysis-standard-analyzer)

* 测试分词

  ```shell
  # "analyzer": "standard" 表示使用的是标准的分词器
  # 以空格来区分，忽略各种符号
  # 若无空格，则每个中文就是一个分词
  POST _analyze
  {
    "analyzer": "standard",
    "text": "Hello World! Stop the world."
  }
  
  # 结果
  {
    "tokens" : [
      {
        "token" : "hello",
        "start_offset" : 0,
        "end_offset" : 5,
        "type" : "<ALPHANUM>",
        "position" : 0
      },
      {
        "token" : "world",
        "start_offset" : 6,
        "end_offset" : 11,
        "type" : "<ALPHANUM>",
        "position" : 1
      },
      {
        "token" : "stop",
        "start_offset" : 13,
        "end_offset" : 17,
        "type" : "<ALPHANUM>",
        "position" : 2
      },
      {
        "token" : "the",
        "start_offset" : 18,
        "end_offset" : 21,
        "type" : "<ALPHANUM>",
        "position" : 3
      },
      {
        "token" : "world",
        "start_offset" : 22,
        "end_offset" : 27,
        "type" : "<ALPHANUM>",
        "position" : 4
      }
    ]
  }
  ```

##### 4.6.2 IK分词器

* 通过上述的**标准分词器**的体验，我们能发现，如果我们将一段中文来进行分词时，它是将每一个中文都拆分了，这有

  点不友好，比如我们要对文本**阿里巴巴真厉害！**来进行分词，我们肯定想分成**阿里巴巴**和**真厉害**这两个词。因此，

  为了实现这样的需求，我们需要引入开源的**ik分词器**。我们选择跟我们使用的ES版本(7.4.2)一样的分词器。

* ik分词器版本选择地址：[https://github.com/medcl/elasticsearch-analysis-ik/releases](https://github.com/medcl/elasticsearch-analysis-ik/releases)。我们选择7.4.2版本的。安装的

  主要核心就是将分词器文件：[https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.4.2/elasticsearch-analysis-ik-7.4.2.zip](https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.4.2/elasticsearch-analysis-ik-7.4.2.zip)安装到es能识别的**plugins**文件夹下(在es的工作区间中默认都有一个plugins文件夹，把文件解压到里面即可)

* 安装步骤

> 1、下载IK分词器zip包
>
> ```shell
> # 因为我们的ES是以docker的方式安装的，并且在启动ES容器时将ES工作目录的plugins文件夹挂在到了宿主机的
> # /mydata/elasticsearch/plugins目录下，所以我们直接在宿主机的此目录下下载并解压ik分词器即可
> cd /mydata/elasticsearch/plugins && \
> wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.4.2/elasticsearch-analysis-ik-7.4.2.zip
> 
> ```
>
> **PS: 因github下载比较慢，我已将此zip包(ik 7.4.2版本)上传到csdn的个人资源了，可以跳转此[url](https://download.csdn.net/download/avengerEug/12689646)进行下载，并上传到`/mydata/elasticsearch/plugins`路径**
>
> 2、执行如下命令解压zip包
>
> ```shell
> # 一定要把zip包删除，否则在重启ES中，会按照ES记载插件的规则，会
> # 去elasticsearch-analysis-ik-7.4.2.zip中加载一些文件，最终
> # 导致ES重启失败
> unzip elasticsearch-analysis-ik-7.4.2.zip -d ./ik && \
> rm -f elasticsearch-analysis-ik-7.4.2.zip
> ```
>
> 3、重启ES容器
>
> ```shell
> docker restart es
> ```
>
> 4、查看ES容器中已安装好的插件
>
> ```shell
> docker exec -it es /usr/share/elasticsearch/bin/elasticsearch-plugin list
> ```
>
> 5、kibana中测试ik分词器
>
> ```shell
> # 分别使用 ik_smart 和 ik_max_word 来体验ik分词器
> POST _analyze
> {
>   "analyzer": "ik_max_word",
>   "text": "我是中国人"
> }
> 
> # 使用ik_smart分词器结果如下
> {
>   "tokens" : [
>     {
>       "token" : "我",
>       "start_offset" : 0,
>       "end_offset" : 1,
>       "type" : "CN_CHAR",
>       "position" : 0
>     },
>     {
>       "token" : "是",
>       "start_offset" : 1,
>       "end_offset" : 2,
>       "type" : "CN_CHAR",
>       "position" : 1
>     },
>     {
>       "token" : "中国人",
>       "start_offset" : 2,
>       "end_offset" : 5,
>       "type" : "CN_WORD",
>       "position" : 2
>     }
>   ]
> }
> ```
>
> 

##### 4.6.3 扩展IK分词器

* 扩展ik分词器，达到自定义效果。

* 思路：

  ```txt
  主要核心：修改ik分词器配置文件，让它能读取到指定词库，最终根据词库进行分词。
  步骤：
    1、词库是一个txt文档，我们可以把词库丢在nginx上
    2、配置词库的地址，最终ik分词器会根据我们配置的词库地址去获取到txt文档，最终在分词时会根据此词库进行
       分词
  ```

* 案例：我们想让ES进行分词，将**你好，ik自定义分词器**中的**ik自定义分词器**单独分词
  步骤如下：

> 1、创建分词库
>
> ```txt
> 创建一个myWord.txt文件，并填充 ik自定义分词器 内容至myWord.txt文件中，同时以UTF-8的格式保存。
> 详见与当前README.md同目录下的myWord.txt文件
> ```
>
> 2、将**myWord.txt**分词库放置nginx中，只要能通过http请求访问到此资源即可
>
> ```shell
> # 我将通过如下url访问到分词库，换言之，我的nginx部署在192.168.111.147上
> http://192.168.111.147/es/myWord.txt
> ```
>
> 3、修改ik分词器的配置文件
>
> ```shell
> # 修改ik分词器的配置文件, 比如我的ik安装路径为/mydata/elasticsearch/plugins/ik，
> # 因此执行如下命令修改xml文件
> vim /mydata/elasticsearch/plugins/ik/config/IKAnalyzer.cfg.xml
> ```
>
> ik的xml默认配置如下所示：
>
> ```xml
> <?xml version="1.0" encoding="UTF-8"?>
> <!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
> <properties>
>         <comment>IK Analyzer 扩展配置</comment>
>         <!--用户可以在这里配置自己的扩展字典 -->
>         <entry key="ext_dict"></entry>
>          <!--用户可以在这里配置自己的扩展停止词字典-->
>         <entry key="ext_stopwords"></entry>
>         <!--用户可以在这里配置远程扩展字典 -->
>         <!-- <entry key="remote_ext_dict">words_location</entry> -->
>         <!--用户可以在这里配置远程扩展停止词字典-->
>         <!-- <entry key="remote_ext_stopwords">words_location</entry> -->
> </properties>
> ```
>
> 我们只需修改**key为remote_ext_dict**的部分即可，最终的配置如下所示：
>
> ```xml
> <?xml version="1.0" encoding="UTF-8"?>
> <!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
> <properties>
>         <comment>IK Analyzer 扩展配置</comment>
>         <!--用户可以在这里配置自己的扩展字典 -->
>         <entry key="ext_dict"></entry>
>          <!--用户可以在这里配置自己的扩展停止词字典-->
>         <entry key="ext_stopwords"></entry>
>         <!--用户可以在这里配置远程扩展字典 -->
>         <entry key="remote_ext_dict">http://192.168.111/147/es/myWord.txt</entry>
>         <!--用户可以在这里配置远程扩展停止词字典-->
>         <!-- <entry key="remote_ext_stopwords">words_location</entry> -->
> </properties>
> ```
>
> 4、重启es容器
>
> ```shell
> docker restart es
> ```
>
> 5、kibana发送请求测试
>
> ```shell
> # 分别使用 ik_smart 和 ik_max_word 来体验自定义的分词扩展器
> POST _analyze
> {
>   "analyzer": "ik_smart",
>   "text": "你好，ik自定义分词器"
> }
> 
> # 使用ik_smart类型的分词器的结果为：
> {
>   "tokens" : [
>     {
>       "token" : "你好",
>       "start_offset" : 0,
>       "end_offset" : 2,
>       "type" : "CN_WORD",
>       "position" : 0
>     },
>     {
>       "token" : "ik自定义分词器",
>       "start_offset" : 3,
>       "end_offset" : 11,
>       "type" : "CN_WORD",
>       "position" : 1
>     }
>   ]
> }
> ```
>
> **至此，扩展IK分词器实现自定义分词就完成了**



### 五、倒排索引

* Elasticsearch 使用的是一种名为**`倒排索引`**的数据结构，这一结构的设计可以允许十分快速地进行全文本搜索。倒排索引会列出在所有文档中出现的每个特有词汇，并且可以找到包含每个词汇的全部文档。

  **在索引过程中，Elasticsearch 会存储文档并构建倒排索引，这样用户便可以近实时地对文档数据进行搜索**。索引过程是在索引 API 中启动的，通过此 API 您既可向特定索引中添加 JSON 文档，也可更改特定索引中的 JSON 文档。

  在关系型数据库中(比如MySQL)，我们都是根据记录的ID来索引一整条字段的，这就是正向索引。所谓的倒排索引

  就是将记录中的一些值来跟ID进行绑定。比如，在ES中我们为name字段创建一个倒排索引，对**avengerEug**这个词的建立一个倒排索引，比如 **avengerEug:1**，这样的话，当我们来搜索**avengerEug**时，检索一下**倒排索引**，很快就能发现这条记录在ID为1的文档上。

* 倒排索引的构建过程：

  在某个index的某个type下保存如下文档：

  | 文档ID |           文档内容            |
  | :----: | :---------------------------: |
  |   1    |     { "name": "红海行动"}     |
  |   2    |   { "name": "搜索红海行动"}   |
  |   3    |   { "name": "红海特别行动"}   |
  |   4    |    { "name": "红海记录篇"}    |
  |   5    | { "name": "特工红海特别探索"} |

  在将数据索引至ES中，会进行分词存储，索引至ES中的命令为：

  ```shell
  # 注意：需要在kibana的DevTools工具中执行，或者可以借鉴批量导入accounts.json的方法
  POST /honghai/_bulk
  {"index": {"_id": 1}}
  { "name": "红海行动"}
  {"index": {"_id": 2}}
  { "name": "搜索红海行动"}
  {"index": {"_id": 3}}
  { "name": "红海特别行动"}
  {"index": {"_id": 4}}
  { "name": "红海记录篇"}
  {"index": {"_id": 5}}
  { "name": "特工红海特别探索"}
  ```

  > 1、分词(可以自己指定分词) + 分析并存储
  >
  > |   词   |     记录      |
  > | :----: | :-----------: |
  > |  红海  | 1，2，3，4，5 |
  > |  行动  |    1，2，3    |
  > |  搜索  |     2，5      |
  > |  特别  |     3，5      |
  > | 纪录片 |       4       |
  > |  特工  |       5       |
  >
  > 整个存储过程为：
  >
  > 当索引ID为1的文档时，此时会进行分词，分成**红海**和**行动**，因此，会针对这两个值进行**倒排索引**，因此我们可以得出：**红海**和**行动**这两个词在ID为1的文档上。
  >
  > 当索引ID为2的文档时，此时会进行分词，分成**搜索**、**红海**和**行动**。因此，会针对这三个值进行**倒排索引**，进而我们而出，**搜索**这个词在ID为2的文档上。
  >
  > 当索引ID为3、4、5的文档时，流程都大同小异，唯一不同的就是，索引ID为4的文档时，会分成**红海**和**记录篇**，此时并不是统一的按照两个文字进行分词了(`如何分词？分词是否有规则？这需要去确认`)

  > 2、检索并分析
  >
  > 当我们要发送如下请求，来模糊检索name中包含**红海特工行动**的文档时(请求命令如下)，
  >
  > ```shell
  > curl -X GET "localhost:9200/honghai/_search?pretty" -H 'Content-Type: application/json' -d \
  > '
  > {
  >  "query": {
  >    "match": {
  >      "name": "红海特工行动"
  >    }
  >  }
  > }
  > '
  > ```
  >
  > 此时会进行分词检索，ES在查询时，会进行分词，在倒排索引中检索**红海、特工、行动**这三个词，我们通过**红海**这个分词就能筛选出ID为1、2、3、4、5的文档。但是，ES中存在**相关性得分**的机制，我们有三个分词，因此还要确定**特工**、**行动**能筛选出哪些文档。通过上面的倒排索引表可知，通过**特工**分词，能筛选出ID为5的文档，通过**行动**能筛选出ID为1、2、3的文档。因此，我们很容易得知，ID为4的相关性得分肯定最低，因为它仅在**红海**这个分词中出现过，因此它排在最后面。
  >
  > 检索结果如下：
  >
  > ```json
  > {
  > "took" : 3,   // 整个检索耗时3毫秒
  > "timed_out" : false, // 未超时
  > "_shards" : {
  >  "total" : 1,
  >  "successful" : 1,
  >  "skipped" : 0,
  >  "failed" : 0
  > },
  > "hits" : {
  >  "total" : {
  >    "value" : 5,  // 命中5条记录
  >    "relation" : "eq"
  >  },
  >  "max_score" : 2.4384515, // 5条记录中的相关性得分的最高分为2.4384515  
  >  "hits" : [
  >    {
  >      "_index" : "honghai",
  >      "_type" : "_doc",
  >      "_id" : "5",
  >      "_score" : 2.4384515,  // 相关性得分最高的，排第一个
  >      "_source" : {
  >        "name" : "特工红海特别探索"
  >      }
  >    },
  >    {
  >      "_index" : "honghai",
  >      "_type" : "_doc",
  >      "_id" : "3",
  >      "_score" : 2.0978906,
  >      "_source" : {
  >        "name" : "红海特别行动"
  >      }
  >    },
  >    {
  >      "_index" : "honghai",
  >      "_type" : "_doc",
  >      "_id" : "1",
  >      "_score" : 1.4340863,
  >      "_source" : {
  >        "name" : "红海行动"
  >      }
  >    },
  >    {
  >      "_index" : "honghai",
  >      "_type" : "_doc",
  >      "_id" : "2",
  >      "_score" : 1.2345998,
  >      "_source" : {
  >        "name" : "搜索红海行动"
  >      }
  >    },
  >    {
  >      "_index" : "honghai",
  >      "_type" : "_doc",
  >      "_id" : "4",
  >      "_score" : 0.1844294,  // 如我们所料，ID为4的文档的相关性得分最低！
  >      "_source" : {
  >        "name" : "红海记录篇"
  >      }
  >    }
  >  ]
  > }
  > }
  > ```


### 六、ES6.0及其之后的版本推荐将索引中的类型去掉

* 官方参考文档：[https://www.elastic.co/guide/en/elasticsearch/reference/7.4/removal-of-types.html#_why_are_mapping_types_being_removed](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/removal-of-types.html#_why_are_mapping_types_being_removed)

  ```txt
  大致的意思为：
    首先，我们把ES中的type类比成MySQL中的表这是一个错误的观念。因为在MySQL中，相同名字的字段存在不同的
    表中，它们是互不影响的。但是在ES中，因为ES是基于Lucene二次封装的，在Lucene中，并没有type的概念，也
    就是说，ES中不同type下的相同属性名，最终在Lucene处理时，会把它们当成相同的字段，并不会做区分(eg:我
    们在不同type下存了相同名称的字段，并且他们的类型不一样，在我们做删除字段的操作时，那ES调用Lucene的
    API时，到底该删除哪个呢？这可能会造成错误)。况且，如果我们以type来做区分，每个type下存储不同的数据结
    构，这将会导致存储在Lucene中的数据变得很稀疏，会降低Lucene的压缩文档的能力。
  ```

* 未来在ES8.0的版本中，将会彻底移除type。链接：[https://www.elastic.co/guide/en/elasticsearch/reference/7.4/removal-of-types.html#parent-child-mapping-types](https://www.elastic.co/guide/en/elasticsearch/reference/7.4/removal-of-types.html#parent-child-mapping-types)

  

