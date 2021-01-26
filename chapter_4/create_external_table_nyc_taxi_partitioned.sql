CREATE EXTERNAL TABLE `packt_serverless_analytics`.`nyc_taxi_partitioned`(
  `vendorid` BIGINT, 
  `tpep_pickup_datetime` STRING, 
  `tpep_dropoff_datetime` STRING, 
  `passenger_count` BIGINT, 
  `trip_distance` DOUBLE, 
  `ratecodeid` BIGINT, 
  `store_and_fwd_flag` STRING, 
  `pulocationid` BIGINT, 
  `dolocationid` BIGINT, 
  `payment_type` BIGINT, 
  `fare_amount` DOUBLE, 
  `extra` DOUBLE, 
  `mta_tax` DOUBLE, 
  `tip_amount` DOUBLE, 
  `tolls_amount` DOUBLE, 
  `improvement_surcharge` DOUBLE, 
  `total_amount` DOUBLE, 
  `congestion_surcharge` DOUBLE)
PARTITIONED BY (`year` INT, `month` INT)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://<YOUR_S3_BUCKET>/tables/nyc_taxi_partitioned/'
TBLPROPERTIES (
  'areColumnsQuoted'='false', 
  'columnsOrdered'='true', 
  'compressionType'='gzip', 
  'delimiter'=',',
  'skip.header.line.count'='1'
)
