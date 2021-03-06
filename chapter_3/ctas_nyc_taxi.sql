CREATE TABLE packt_serverless_analytics.chapter_3_nyc_taxi_parquet
WITH (
	  external_location = 's3://YOUR_BUCKET_HERE/chapter_3/tables/nyc_taxi_parquet/',
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
FROM packt_serverless_analytics.chapter_3_nyc_taxi_csv