CREATE EXTERNAL TABLE marketing (
  start_date STRING,
  end_date STRING,
  marketing_id STRING,
  description STRING
)
ROW FORMAT DELIMITED
      FIELDS TERMINATED BY '\t'
      ESCAPED BY '\\'
      LINES TERMINATED BY '\n'
LOCATION 's3://packt-serverless-analytics-888889908458/chapter_8/marketing/';