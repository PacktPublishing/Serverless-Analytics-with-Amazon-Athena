INSERT INTO packt_serverless_analytics.chapter_3_nyc_taxi_parquet 
SELECT 
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
FROM 
    packt_serverless_analytics.chapter_3_nyc_taxi_csv
WHERE
    year(date_parse(tpep_pickup_datetime,'%Y-%m-%d %H:%i:%s')) = 2017