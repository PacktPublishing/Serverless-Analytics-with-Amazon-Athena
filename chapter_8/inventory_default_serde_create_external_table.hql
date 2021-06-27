CREATE EXTERNAL TABLE inventory_default_serde (
  inventory_id STRING,
  item_name STRING,
  available_count STRING
)
ROW FORMAT DELIMITED
      FIELDS TERMINATED BY ','
      ESCAPED BY '\\'
      LINES TERMINATED BY '\n'
LOCATION 's3://packt-serverless-analytics-888889908458/chapter_8/inventory/'
TBLPROPERTIES ('serialization.null.format'='',
              'skip.header.line.count'='1')