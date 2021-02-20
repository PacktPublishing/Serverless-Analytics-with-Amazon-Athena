INSERT INTO packt_serverless_analytics.nyc_taxi_partitioned_parquet
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
    --Below are partition columns and are always
    --specified at the end of the SELECT statement
    substr(tpep_pickup_datetime, 1, 4) AS year,
    substr(tpep_pickup_datetime, 6, 2) AS month
FROM packt_serverless_analytics.nyc_taxi
WHERE tpep_pickup_datetime = '2020-07';