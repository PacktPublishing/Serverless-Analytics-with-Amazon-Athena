CREATE EXTERNAL TABLE sales (
    timestamp STRING,
    item_id STRING,
    customr_id INT,
    price DOUBLE,
    shipping_price DOUBLE,
    discount_code STRING
)
ROW FORMAT DELIMITED
      FIELDS TERMINATED BY ','
      ESCAPED BY '\\'
      LINES TERMINATED BY '\n'
LOCATION 's3://packt-serverless-analytics-888889908458/chapter_8/sales/'
TBLPROPERTIES ('serialization.null.format'='',
              'skip.header.line.count'='1')