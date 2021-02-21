CREATE EXTERNAL TABLE `packt_serverless_analytics`.`chapter_3_nyc_taxi_csv`(
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
  's3://YOUR_BUCKET_NAME_HERE/chapter_3/tables/nyc_taxi_csv/'
TBLPROPERTIES (
  'areColumnsQuoted'='false', 
  'columnsOrdered'='true', 
  'compressionType'='gzip', 
  'delimiter'=',',
  'skip.header.line.count'='1', 
  'typeOfData'='file')