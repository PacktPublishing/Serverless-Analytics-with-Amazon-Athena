import time
import boto3
import os
import logging
import hashlib

logger = logging.getLogger()
logger.setLevel(logging.INFO)

CLIENT = boto3.client('athena')
WORKGROUP = "packt-athena-analytics"
DATABASE = 'packt_serverless_analytics'
BASE_TABLE = 'chapter_9_trades'
ETL_LOCATION = 's3://<YOUR_S3_BUCKET>/chapter_9/'

def lambda_handler(event, context):
    logger.info('Event Arrived: %s', event)
 
    s3_object = event_to_s3_uri(event)
    logger.info('New data arrived in: %s', s3_object)
    
    ensure_trade_table_exists(DATABASE, BASE_TABLE, ETL_LOCATION)
    import_table = make_temp_import_table(DATABASE, s3_object)
    import_data(DATABASE, BASE_TABLE, import_table)
    update_trade_summary(DATABASE, BASE_TABLE)
    
    drop_table(DATABASE, import_table)
    logger.info('Completed handling event')
    return {}

#
# Helper to extract S3 Object URI from event
#
def event_to_s3_uri(event ):
    records = event['Records']
    record = records[0]
    s3_bucket = record['s3']['bucket']['name']
    s3_key = record['s3']['object']['key'].rsplit('/', 1)[0]
    return "s3://" + s3_bucket + "/" + s3_key

#
# Helper function use to run a query and optionally wait for it's result
#
def run_query(query, wait_seconds = 0):
    logger.info('run_query: Preparing to run query %s', query)
    
    query_id = CLIENT.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': DATABASE
        },
        WorkGroup=WORKGROUP
    )['QueryExecutionId']
    
    logger.info('run_query: Started query with id: %s', query_id)
    
    query_result = wait_for_query(query_id, wait_seconds)
    
    logger.info('run_query: Query result: %s', query_result)
    
    return [query_id, query_result]
    
#
# Helper function used to wait for an Athena query to complete
#
def wait_for_query(query_id, max_wait_seconds = 5):
    state = 'RUNNING'

    while (state in ['RUNNING', 'QUEUED'] and max_wait_seconds > 0):
        query_execution = CLIENT.get_query_execution(QueryExecutionId = query_id)

        try:
            state = query_execution['QueryExecution']['Status']['State']
            if state == 'FAILED':
                logger.warn('wait_for_query: Query %s failed: %s', 
                             query_id, 
                             query_execution['QueryExecution']['Status']['StateChangeReason'])
                raise RuntimeError(query_id, query_execution['QueryExecution']['Status']['StateChangeReason'])
            elif state == 'SUCCEEDED':
                return query_execution['QueryExecution']['ResultConfiguration']['OutputLocation']
        except KeyError:
            pass
        
        time.sleep(1)
        max_wait_seconds = max_wait_seconds - 1
        
    return False

#
# Helper function to make a temporary table from an S3 location using a
# pre-determined schema and format
#
def make_temp_import_table(database, import_location):
    logger.info('make_temp_import_table: Preparing temporary table for %s', import_location)
    hash_import_location = hashlib.md5(import_location.encode())
    temp_table_name = 'chapter_9_import_' + hash_import_location.hexdigest()

    temp_table_query = """
        CREATE EXTERNAL TABLE IF NOT EXISTS `DATABASE`.`TABLE_NAME`(
          `symbol` string, 
          `trade_date` string, 
          `price` double, 
          `num_shares` bigint)
        ROW FORMAT DELIMITED 
          FIELDS TERMINATED BY ',' 
        STORED AS INPUTFORMAT 
          'org.apache.hadoop.mapred.TextInputFormat' 
        OUTPUTFORMAT 
          'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
        LOCATION
          'S3_LOCATION'
        TBLPROPERTIES (
          'areColumnsQuoted'='false', 
          'columnsOrdered'='true',
          'delimiter'=',',
          'skip.header.line.count'='1', 
          'typeOfData'='file')
    """.replace("TABLE_NAME", temp_table_name)\
    .replace('DATABASE', database)\
    .replace('S3_LOCATION', import_location)
    
    run_query(temp_table_query, 120)
    
    logger.info('make_temp_import_table: Import table name: %s', temp_table_name)
    return temp_table_name

#
# Helper function to ensure base trade table exists
#
def ensure_trade_table_exists(database, table_name, location):
    logger.info('ensure_trade_table_exists: Preparing  table %s.%s', 
                database, table_name)
    
    base_table_query = """
        CREATE EXTERNAL TABLE IF NOT EXISTS 
        `DATABASE`.`TABLE_NAME`(
          `symbol` string, 
          `trade_date` string, 
          `price` double, 
          `num_shares` bigint)
        PARTITIONED BY (`year` bigint, `month` bigint)
        STORED AS PARQUET
        LOCATION 'S3_LOCATION'
        tblproperties ("parquet.compression"="SNAPPY");
    """.replace("TABLE_NAME", table_name)\
    .replace('DATABASE', database)\
    .replace('S3_LOCATION', location + table_name)

    run_query(base_table_query, 120)
    
#
# Helper function to import data from the import table to the
# base table.
#
def import_data(database, target_table, source_table):
    import_data_query = """
        INSERT INTO DATABASE.TARGET_TABLE_NAME 
        SELECT 
          symbol,
          trade_date,
          price,
          num_shares,
          year(date_parse(trade_date,'%Y-%m-%d %H:%i:%s')) as year,
          month(date_parse(trade_date,'%Y-%m-%d %H:%i:%s')) as month
        FROM 
            DATABASE.IMPORT_TABLE_NAME
    """.replace("TARGET_TABLE_NAME", target_table)\
    .replace('DATABASE', database)\
    .replace('IMPORT_TABLE_NAME', source_table)

    run_query(import_data_query, 120)


#
# Helper function to drop tables
#
def drop_table(database, table):
    logger.info('drop_table: Preparing to drop table %s.%s', database, table)
    drop_table_query ="""
        DROP TABLE DATABASE.`TABLE_NAME`;
    """.replace("TABLE_NAME", table).replace('DATABASE', database)
    
    run_query(drop_table_query, 120)
    

#
# Helper function to generate a trade summary report
#
def update_trade_summary(database, table_name):
    logger.info('update_trade_summary: updating trade summary.')
    
    trade_summary_query = """
    SELECT 
        symbol, 
        sum(num_shares) 
    FROM
        DATABASE.TABLE_NAME 
    GROUP BY symbol
    """.replace("TABLE_NAME", table_name)\
    .replace('DATABASE', database)
    
    query_id = run_query(trade_summary_query, 120)[0]
    result = read_all_results(query_id)
    logger.info('update_trade_summary: %s', result)

#
# Helper function to read all results into a dictionary
#
def read_all_results(query_id):
    results_paginator = CLIENT.get_paginator('get_query_results')
    results_iter = results_paginator.paginate(
        QueryExecutionId=query_id,
        PaginationConfig={
            'PageSize': 1000
        }
    )
    results = []
    data_list = []
    for results_page in results_iter:
        for row in results_page['ResultSet']['Rows']:
            data_list.append(row['Data'])
    for datum in data_list[1:]:
        results.append([x['VarCharValue'] for x in datum])
    return [tuple(x) for x in results]
