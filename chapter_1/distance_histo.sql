SELECT trip_distance, number_of_rides
FROM 
    (SELECT numeric_histogram(10,trip_distance)
    FROM packt_serverless_analytics.nyc_taxi ) AS x (ride_histogram)
CROSS JOIN UNNEST(ride_histogram) AS t (trip_distance , number_of_rides);