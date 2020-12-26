SELECT ride_minutes, number_rides
FROM (SELECT numeric_histogram(10,
    date_diff('minute',
 		date_parse(tpep_pickup_datetime,'%Y-%m-%d %H:%i:%s'),
 		date_parse(tpep_dropoff_datetime, '%Y-%m-%d %H:%i:%s')
         )
)
FROM packt_serverless_analytics.nyc_taxi ) AS x (ride_histogram)
CROSS JOIN 
UNNEST(ride_histogram) AS t (ride_minutes, number_rides);