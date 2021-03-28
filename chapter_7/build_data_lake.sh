#!/bin/bash


BUCKET=$1
WORKGROUP=$2

if [ $# -eq 0 ]
  then
    echo "USAGE INFORMATION: This script expects the following arguments"
    echo "\t1. 1st argument to be the name of an S3 Bucket to use for uploads."
    echo "\t2. 2nd argument to be the name of the WorkGroup to use when running queries."
    echo "The script will use default AWS CLI credentails and region information configured when you ran \'aws configure\'."
    exit
fi


echo "*******************************************************"
echo "*              Build Chapter 7 Data Lake              *"
echo "*******************************************************"

echo "using bucket: ${BUCKET}"
echo "using WORKGROUP: ${WORKGROUP}"
set +x

echo "*******************************************************"
echo "*        Downloading NYC Taxi Data (2017-2020)        *"
echo "*******************************************************"

array=( yellow_tripdata_2017-01.csv 
        yellow_tripdata_2017-02.csv
        yellow_tripdata_2017-03.csv
        yellow_tripdata_2017-04.csv
        yellow_tripdata_2017-05.csv
        yellow_tripdata_2017-06.csv
        yellow_tripdata_2017-07.csv
        yellow_tripdata_2017-08.csv
        yellow_tripdata_2017-09.csv
        yellow_tripdata_2017-10.csv
        yellow_tripdata_2017-11.csv
        yellow_tripdata_2017-12.csv
        yellow_tripdata_2018-01.csv 
        yellow_tripdata_2018-02.csv
        yellow_tripdata_2018-03.csv
        yellow_tripdata_2018-04.csv
        yellow_tripdata_2018-05.csv
        yellow_tripdata_2018-06.csv
        yellow_tripdata_2018-07.csv
        yellow_tripdata_2018-08.csv
        yellow_tripdata_2018-09.csv
        yellow_tripdata_2018-10.csv
        yellow_tripdata_2018-11.csv
        yellow_tripdata_2018-12.csv
        yellow_tripdata_2019-01.csv
        yellow_tripdata_2019-02.csv
        yellow_tripdata_2019-03.csv
        yellow_tripdata_2019-04.csv
        yellow_tripdata_2019-05.csv
        yellow_tripdata_2019-06.csv
        yellow_tripdata_2019-07.csv
        yellow_tripdata_2019-08.csv
        yellow_tripdata_2019-09.csv
        yellow_tripdata_2019-10.csv
        yellow_tripdata_2019-11.csv
        yellow_tripdata_2019-12.csv
        yellow_tripdata_2020-01.csv
        yellow_tripdata_2020-02.csv
        yellow_tripdata_2020-03.csv
        yellow_tripdata_2020-04.csv
        yellow_tripdata_2020-05.csv
        yellow_tripdata_2020-06.csv
      )
for i in "${array[@]}"
do
    FILE=$i
    echo "Downloading ${FILE} from nyc-tlc"
    wget https://s3.amazonaws.com/nyc-tlc/trip+data/${FILE}
    echo "Uploading ${FILE} to S3 bucket ${BUCKET}"
    aws s3 cp ./${FILE} s3://$BUCKET/chapter_7/tables/nyc_taxi_csv/
    echo "Cleaning up file ${FILE}"
    rm $FILE
done


echo "*******************************************************"
echo "*       Downloading California Geospatial Data        *"
echo "*******************************************************"

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/raw/master/samples/data/earthquake-data/earthquakes.csv

echo "Uploading earthquakes.csz to S3 bucket ${BUCKET}"
aws s3 cp ./earthquakes.csv s3://$BUCKET/chapter_7/tables/earthquakes/

echo "Removing earthquakes.csv."
rm earthquakes.csv

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/raw/master/samples/data/counties-data/california-counties.json

echo "Uploading california-counties.json to S3 bucket ${BUCKET}"
aws s3 cp ./california-counties.json s3://$BUCKET/chapter_7/tables/california-counties/

echo "Removing california-counties.json."
rm california-counties.json



echo "*******************************************************"
echo "*             Creating Data Lake Tables               *"
echo "*******************************************************"


read -d '' create_earthquakes_table << EndOfMessage
CREATE external TABLE IF NOT EXISTS packt_serverless_analytics.chapter_7_earthquakes
(
 earthquake_date string,
 latitude double,
 longitude double,
 depth double,
 magnitude double,
 magtype string,
 mbstations string,
 gap string,
 distance string,
 rms string,
 source string,
 eventid string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 's3://${BUCKET}/chapter_7/tables/earthquakes/';
EndOfMessage


read -d '' create_counties_table << EndOfMessage
CREATE external TABLE IF NOT EXISTS packt_serverless_analytics.chapter_7_counties
 (
 Name string,
 BoundaryShape binary
 )
ROW FORMAT SERDE 'com.esri.hadoop.hive.serde.JsonSerde'
STORED AS INPUTFORMAT 'com.esri.json.hadoop.EnclosedJsonInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://${BUCKET}/chapter_7/tables/california-counties/';
EndOfMessage

read -d '' create_nyc_taxi_csv << EndOfMessage
CREATE EXTERNAL TABLE `packt_serverless_analytics`.`chapter_7_nyc_taxi_csv`(
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
  's3://${BUCKET}/chapter_7/tables/nyc_taxi_csv/'
TBLPROPERTIES (
  'areColumnsQuoted'='false', 
  'columnsOrdered'='true', 
  'delimiter'=',',
  'skip.header.line.count'='1', 
  'typeOfData'='file');
EndOfMessage

read -d '' create_nyc_taxi_parquet << EndOfMessage
CREATE TABLE packt_serverless_analytics.chapter_7_nyc_taxi_parquet
WITH (
      external_location = 's3://${BUCKET}/chapter_7/tables/nyc_taxi_parquet/',
      format = 'Parquet',
      parquet_compression = 'SNAPPY',
      partitioned_by = ARRAY['year', 'month']
      )
AS SELECT 
    vendorid,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    ratecodeid,
    store_and_fwd_flag,
    pulocationid,
    dolocationid,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    year(date_parse(tpep_pickup_datetime,'%Y-%m-%d %H:%i:%s')) as year,
    month(date_parse(tpep_pickup_datetime,'%Y-%m-%d %H:%i:%s')) as month
FROM packt_serverless_analytics.chapter_7_nyc_taxi_csv
EndOfMessage

echo "Preparing to run create_earthquakes_table query:"
echo $create_earthquakes_table

aws athena start-query-execution \
    --query-string "${create_earthquakes_table}" \
    --work-group "${WORKGROUP}"

echo "Preparing to run create_counties_table query:"
echo $create_counties_table

aws athena start-query-execution \
    --query-string "${create_counties_table}" \
    --work-group "${WORKGROUP}"

echo "Preparing to run create_nyc_taxi_csv query:"
echo $create_nyc_taxi_csv

aws athena start-query-execution \
    --query-string "${create_nyc_taxi_csv}" \
    --work-group "${WORKGROUP}"

echo "Waiting for queries to complete before optimizing table layout."
sleep 30

echo "Preparing to run create_nyc_taxi_parquet query:"
echo $create_nyc_taxi_parquet

aws athena start-query-execution \
    --query-string "${create_nyc_taxi_parquet}" \
    --work-group "${WORKGROUP}"

#
# While we did not automate checking the status or getting the results of queries in this script
# you can do so by using the following commands:
#
# aws athena get-query-execution  --query-execution-id <QUERY_EXECUTION_ID>
# aws athena get-query-results  --query-execution-id <QUERY_EXECUTION_ID>
#
# Its normal for DDL (aka create table) queries to return no results for 'get-query-results'.
# All types of queries will return useful info when calling 'get-query-execution'.
#