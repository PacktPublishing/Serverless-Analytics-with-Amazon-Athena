SELECT
   -- this field uses date functions to get the date of the sales
   date_trunc('day', from_iso8601_timestamp(sales.timestamp)) as sales_date,
   -- This field uses a CASE statement (like an if statement) that determines if there was a marketing
   -- compaign on the date
   CASE WHEN marketing.marketing_id is not null then TRUE else FALSE END as has_marketing_compaign,
   -- each row represents a single sale
   SUM(1) as number_of_sales,
   -- we use the histogram function to get a count of all the states and the number of times they showed up.
   histogram(CASE WHEN cardinality(customers.addresses) > 0 THEN customers.addresses[1].state ELSE NULL END) as states
FROM
-- We join the sales dataset, with marketing and customer tables
   sales
LEFT OUTER JOIN
   marketing
ON
   date_trunc('day', from_iso8601_timestamp(marketing.start_date)) 
    = date_trunc('day', from_iso8601_timestamp(sales.timestamp))
LEFT OUTER JOIN
   customers
ON
   sales.customer_id = customers.customer_id
GROUP BY 1, 2 ORDER BY 3 DESC