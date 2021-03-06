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

echo "using bucket: ${BUCKET}"
echo "using WORKGROUP: ${WORKGROUP}"
set +x

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/raw/master/samples/data/earthquake-data/earthquakes.csv

echo "Uploading earthquakes.csz to S3 bucket ${BUCKET}"
aws s3 cp ./earthquakes.csv s3://$BUCKET/chapter_3/tables/earthquakes/

echo "Removing earthquakes.csv."
rm earthquakes.csv

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/raw/master/samples/data/counties-data/california-counties.json

echo "Uploading california-counties.json to S3 bucket ${BUCKET}"
aws s3 cp ./california-counties.json s3://$BUCKET/chapter_3/tables/california-counties/

echo "Removing california-counties.json."
rm california-counties.json

read -d '' create_earthquakes_table << EndOfMessage
CREATE external TABLE IF NOT EXISTS packt_serverless_analytics.chapter_3_earthquakes
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
STORED AS TEXTFILE LOCATION 's3://${BUCKET}/chapter_3/tables/earthquakes/';
EndOfMessage


read -d '' create_counties_table << EndOfMessage
CREATE external TABLE IF NOT EXISTS packt_serverless_analytics.chapter_3_counties
 (
 Name string,
 BoundaryShape binary
 )
ROW FORMAT SERDE 'com.esri.hadoop.hive.serde.JsonSerde'
STORED AS INPUTFORMAT 'com.esri.json.hadoop.EnclosedJsonInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://${BUCKET}/chapter_3/tables/california-counties/';
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