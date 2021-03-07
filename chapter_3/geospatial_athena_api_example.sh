#!/bin/bash


BUCKET=$1

if [ $# -eq 0 ]
  then
    echo "USAGE INFORMATION: This script expects the 1st argument to be the name of an S3 Bucket to use for uploads."
    echo "The script will use default AWS CLI credentails and region information configured when you ran \'aws configure\'."
    exit
fi

echo "using bucket: $BUCKET"
set +x

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/blob/master/samples/data/earthquake-data/earthquakes.csv

echo "Compressing earthquakes.csv with gzip."
gzip earthquakes.csv

echo "Uploading earthquakes.csz.gz to S3 bucket ${BUCKET}"
aws s3 cp ./earthquakes.csv.gz s3://$BUCKET/chapter_3/tables/earthquakes/

echo "Downloading earthquakes.csv from ESRI github repository."
wget https://github.com/Esri/gis-tools-for-hadoop/blob/master/samples/data/counties-data/california-counties.json

echo "Compressing california-counties.json with gzip."
gzip california-counties.json

echo "Uploading california-counties.json.gz to S3 bucket ${BUCKET}"
aws s3 cp ./california-counties.json.gz s3://$BUCKET/chapter_3/tables/california-counties/

