## Elasticsearch(7.4.2  <=> 7.x)

### 一、Elasticsearch介绍

#### 1.1 是什么？

```txt
Elasticsearch时一个分布式的开源搜索和分析引擎，适用于所有类型的数据，包括文本、数字、地理空间、结构化和非结构化数据。Elasticsearch基于Apache Lucene的基础上开发而成，于2010年首次发布，它将Lucene复杂的api操作抽象成非常简单的REST风格的API。以简单的REST风格API、分布式特性、速度和扩展性而闻名，是Elastic Stack的核心组件。人们通常将Elastic Stack称为ELK Stack(代指Elasticsearch、Logstash、Kibana)。
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
原始数据会从多个来源（包括日志、系统指标和网络应用程序）输入到 Elasticsearch 中。数据采集指在 Elasticsearch 中进行索引之前解析、标准化并充实这些原始数据的过程。这些数据在 Elasticsearch 中索引完成之后，用户便可针对他们的数据运行复杂的查询，并使用聚合来检索自身数据的复杂汇总。在 Kibana 中，用户可以基于自己的数据创建强大的可视化，分享仪表板，并对 Elastic Stack 进行管理。
```

#### 1.5 如何学习

```txt
Elasticsearch的学习，建议参考官方的英文文档，因为它比较新。当然，它也有一些中文文档，缺点就是中文文档翻译的是比较老的Elasticsearch版本(基于 Elasticsearch 2.x)，比较新的版本是没有中文文档的。
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

### 三、倒排索引

* Elasticsearch 使用的是一种名为**`倒排索引`**的数据结构，这一结构的设计可以允许十分快速地进行全文本搜索。倒排索引会列出在所有文档中出现的每个特有词汇，并且可以找到包含每个词汇的全部文档。

  **在索引过程中，Elasticsearch 会存储文档并构建倒排索引，这样用户便可以近实时地对文档数据进行搜索**。索引过程是在索引 API 中启动的，通过此 API 您既可向特定索引中添加 JSON 文档，也可更改特定索引中的 JSON 文档。

* 倒排索引的构建过程：

  在某个index的某个type下保存如下文档：红海行动、搜索红海行动、红海特别行动、红海记录篇、特工红海特别探索

  > 1、分词(可以自己指定分词) + 分析并存储
  >
  > |  词  | 记录 |
  > | :--: | :--: |
  > | 红海 |      |
  > |      |      |
  > |      |      |
  >
  > 

  > 2、检索并分析

### 四、Docker部署与安装

* docker安装elasticsearch

  ```shell
  # 1. 拉取镜像
  docker pull elasticsearch:7.4.2
  
  # 2. 本地创建配置文件，控制docker中es中的运行状态
  mkdir -p /mydata/elasticsearch/config
  mkdir -p /mydata/elasticsearch/data
  chmod -R 777 /mydata/elasticsearch
  echo "http.host:0.0.0.0" >> /mydata/elasticsearch/config/elasticsearch.yml
  
  # 3. 启动es容器 --> 9300是es在集群时的通信端口，挂载了配置文件、数据、插件的目录至本地
  # --restart=always(主机重启后自动运行)
  docker run --name es --restart=always -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e ES_JAVA_OPTS="-Xms64m -Xmx128m" \
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

### 五、常见api

* 使用CURL操作ES教程：[点击传送门跳转](https://www.elastic.co/guide/en/elasticsearch/reference/7.8/getting-started-install.html#gs-curl)

#### 5.1 _cat

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

#### 5.2 创建与新增索引

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

#### 5.3 ES中乐观锁的使用

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

#### 5.4 获取指定id的文档(数据)

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

#### 5.5 删除文档(数据)

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

#### 5.6 删除索引(数据库)

* ```shell
  DELETE /customer/_doc
  
  curl -X DELETE "localhost:9200/customer"
  
  # 响应结果
  {"acknowledged":true}
  ```

#### 5.7 ES删除类型(表)

* ES不支持删除类型的操作，如果要删除的话，可以把索引删除或者把类型中的文档都清空，来实现变相删除

#### 5.8 批量导入文档(基于.json后缀名文件)

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

#### 5.9 ES高级查询

#### 5.9.1 query参数和请求体参数(Query DSL，常用)检索

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

#### 5.9.2 Query DSL查询