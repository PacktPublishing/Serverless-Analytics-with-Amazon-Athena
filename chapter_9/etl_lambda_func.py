import time
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

client = boto3.client('athena')
query = 'SELECT 1'
DATABASE = 'default'
output='s3://packt-serverless-analytics-888889908458/results/'

def lambda_handler(event, context):

    # Execution
    query_id = client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={
            'Database': DATABASE
        },
        ResultConfiguration={
            'OutputLocation': output,
        }
    )['QueryExecutionId']
    
    logger.info('Started query with id: %s', query_id)
    
    query_result = wait_for_query(query_id, 60)
    
    logger.info('Get query result location: %s', query_result)
    
    return {}

#
# Helper function used to wait for an Athena query to complete
#
def wait_for_query(query_id, max_wait_seconds = 5):
    state = 'RUNNING'

    while (state in ['RUNNING', 'QUEUED'] and max_wait_seconds > 0):
        query_execution = client.get_query_execution(QueryExecutionId = query_id)

        try:
            state = query_execution['QueryExecution']['Status']['State']
            if state == 'FAILED':
                return False
            elif state == 'SUCCEEDED':
                return query_execution['QueryExecution']['ResultConfiguration']['OutputLocation']
        except KeyError:
            pass
        
        time.sleep(1)
        max_wait_seconds = max_wait_seconds - 1
        
    return False