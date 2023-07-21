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

array=( yellow_tripdata_2018-01.csv
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
	ZIP_FILE="${FILE}.gz"
	echo "Downloading ${FILE} from nyc-tlc"
	aws s3 cp s3://nyc-tlc/csv_backup/${FILE} .
	echo "Performing gzip on ${FILE}"
	gzip ${FILE}
	echo "Uploading ${ZIP_FILE} to S3 bucket ${BUCKET}"
	aws s3 cp ./${ZIP_FILE} s3://$BUCKET/chapter_3/tables/nyc_taxi_csv/
	echo "Cleaning up file ${ZIP_FILE}"
	rm $ZIP_FILE
done

set -x