create external table website_clicks (
  time_epoch BIGINT,
  source_addr STRING,
  page_visited STRING,
  referrer STRING
) ROW FORMAT SERDE
   'com.amazonaws.glue.serde.GrokSerDe'
WITH SERDEPROPERTIES (
   'input.format'='%{NUMBER:time_epoch} %{IP:source_addr} %{URI:page_visited} %{URI:referrer}'
   )
STORED AS INPUTFORMAT
   'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
   'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
   's3://packt-serverless-analytics-888889908458/chapter_8/clickstream/';