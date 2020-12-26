SELECT trip_distance, number_rides
FROM 
    (SELECT numeric_histogram(5,trip_distance)
       FROM packt_serverless_analytics.nyc_taxi 
       WHERE date_diff('minute',
 		date_parse(tpep_pickup_datetime,'%Y-%m-%d %H:%i:%s'),
 		date_parse(tpep_dropoff_datetime, '%Y-%m-%d %H:%i:%s')
         ) <= 6.328061
    ) AS x (ride_histogram)
CROSS JOIN UNNEST(ride_histogram) AS t (trip_distance , number_rides);
