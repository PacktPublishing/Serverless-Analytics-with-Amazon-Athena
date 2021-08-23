CREATE EXTERNAL TABLE IF NOT EXISTS `packt_serverless_analytics`.`chapter_13_udf_sample_data` (
  YEAR STRING,
  MONTH STRING,
  DAY STRING,
  ACCOUNT_ID STRING,
  AMT BIGINT,
  SOME_BOOLEAN BOOLEAN,
  ENCRYPTED_PAYLOAD STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION 's3://<S3_BUCKET>/packt-serverless-analytics-chapter-13/udf-example/'
