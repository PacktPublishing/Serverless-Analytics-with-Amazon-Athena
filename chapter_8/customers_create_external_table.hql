CREATE EXTERNAL TABLE customers (
  customer_id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  addresses ARRAY<STRUCT<address:STRING,city:STRING,state:STRING,country:STRING>>,
  extrainfo STRING
)
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://packt-serverless-analytics-888889908458/chapter_8/customers/';