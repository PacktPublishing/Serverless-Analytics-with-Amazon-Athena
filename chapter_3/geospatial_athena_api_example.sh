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
wget https://github.com/Esri/gis-tools-for-hadoop/blob/master/samples/data/earthquake-data/earthquakes.csv

echo "Compressing earthquakes.csv with gzip."
gzip earthquakes.csv

echo "Uploading earthquakes.csz.gz to S3 bucket ${BUCKET}"
aws s3 cp ./earthquakes.csv.gz s3://$BUCKET/chapter_3/tables/earthquakes/

echo "Removing earthquakes.csv.gz."
rm earthquakes.csv.gz

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/blob/master/samples/data/counties-data/california-counties.json

echo "Compressing california-counties.json with gzip."
gzip california-counties.json

echo "Uploading california-counties.json.gz to S3 bucket ${BUCKET}"
aws s3 cp ./california-counties.json.gz s3://$BUCKET/chapter_3/tables/california-counties/

echo "Removing california-counties.json.gz."
rm california-counties.json.gz

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
STORED AS TEXTFILE LOCATION 's3://${BUCKET}/chapter_3/tables/earthquakes/'
TBLPROPERTIES (
  'compressionType'='gzip');
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
LOCATION 's3://${BUCKET}/chapter_3/tables/california-counties/'
TBLPROPERTIES (
  'compressionType'='gzip');
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

