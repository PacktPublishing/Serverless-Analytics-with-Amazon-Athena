CREATE EXTERNAL TABLE inventory (
  inventory_id BIGINT,
  item_name STRING,
  available_count BIGINT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES ("separatorChar" = ",", "escapeChar" = "\\") 
LOCATION 's3://packt-serverless-analytics-888889908458/chapter_8/inventory/'
TBLPROPERTIES ('skip.header.line.count'='1')
