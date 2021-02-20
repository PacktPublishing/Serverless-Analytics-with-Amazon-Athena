CREATE TABLE packt_serverless_analytics.nyc_taxi_partitioned_parquet
WITH (format='PARQUET',
    parquet_compression='SNAPPY',
    partitioned_by=array['year','month'],
    external_location = 's3://<YOUR_S3_BUCKET>/tables/nyc_taxi_partitioned_parquet/')
AS
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
    substr(tpep_pickup_datetime, 1, 4) as year,
    substr(tpep_pickup_datetime, 6, 2) as month
FROM packt_serverless_analytics.nyc_taxi;