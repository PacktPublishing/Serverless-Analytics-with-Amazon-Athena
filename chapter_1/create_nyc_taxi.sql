CREATE EXTERNAL TABLE `nyc_taxi`(
  `vendorid` bigint, 
  `tpep_pickup_datetime` string, 
  `tpep_dropoff_datetime` string, 
  `passenger_count` bigint, 
  `trip_distance` double, 
  `ratecodeid` bigint, 
  `store_and_fwd_flag` string, 
  `pulocationid` bigint, 
  `dolocationid` bigint, 
  `payment_type` bigint, 
  `fare_amount` double, 
  `extra` double, 
  `mta_tax` double, 
  `tip_amount` double, 
  `tolls_amount` double, 
  `improvement_surcharge` double, 
  `total_amount` double, 
  `congestion_surcharge` double)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://packt-serverless-analytics/tables/nyc_taxi/'
TBLPROPERTIES (
  'CrawlerSchemaDeserializerVersion'='1.0', 
  'CrawlerSchemaSerializerVersion'='1.0', 
  'UPDATED_BY_CRAWLER'='packt_serverless_anaytics_chapter_1', 
  'areColumnsQuoted'='false', 
  'averageRecordSize'='144', 
  'classification'='csv', 
  'columnsOrdered'='true', 
  'compressionType'='gzip', 
  'delimiter'=',', 
  'objectCount'='1', 
  'recordCount'='47483', 
  'sizeKey'='10206684', 
  'skip.header.line.count'='1', 
  'typeOfData'='file')