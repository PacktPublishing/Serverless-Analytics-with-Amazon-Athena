#!/bin/bash

##################################################################################
# In this script, it will create four Cloudwatch Alarms to monitor Query Queue
# time for Amazon Athena. When these alarms go off, they will send
# an SNS notification so that you can setup an email alert, or fire an Lambda to
# take some automated action. 
#
# This script creates seperate alarms for DML and DDL functions so you can control
# their alarms seperately.
#
# !! You must fill in the SNS Arns for warning and error events. 
# !! You must also enable these alarms in the Cloudwatch Alarms dashboard after reviewing
# the metrics. 
#
# For Cloudwatch Alarms documentation, see 
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html
# 
##################################################################################

#WARNING_SNS_ARN=<ENTER SNS ARN HERE>
WARNING_SNS_ARN=arn:aws:sns:us-east-1:888889908458:AlertAccountants.fifo
WARNING_TIME_THRESHOLD_IN_MILLISECONDS=180000.00

#ERROR_SNS_ARN=<ENTER SNS ARN HERE>
ERROR_SNS_ARN=arn:aws:sns:us-east-1:888889908458:AlertAccountants.fifo
ERROR_TIME_THRESHOLD_IN_MILLISECONDS=300000.00

##################################################################################
# This function creates the alarms. 
# We set the evaluation period to 3 and number of data points to 2 to reduce noise. 
##################################################################################
create_alarm()
{
   ALARM_NAME="$1"
   ALARM_DESCRIPTION="$2"
   ALARM_THRESHOLD="$3"
   ALARM_SNS_ARN="$4"
   ATHENA_QUERY_TYPE="$5"

    aws cloudwatch put-metric-alarm \
       --alarm-name ${ALARM_NAME} \
       --alarm-description "${ALARM_DESCRIPTION}" \
       --no-actions-enabled \
       --alarm-actions "${ALARM_SNS_ARN}" \
       --evaluation-periods 3 \
       --datapoints-to-alarm 2 \
       --threshold ${ALARM_THRESHOLD} \
       --comparison-operator 'GreaterThanThreshold' \
       --treat-missing-data 'notBreaching' \
       --metrics '[{"Id":"e1","Label":"AllAthenaQueuedTime","Expression":"MAX(METRICS())","ReturnData":true},{"Id":"m1","ReturnData":false,"MetricStat":{"Period":300,"Stat":"Maximum","Metric":{"MetricName":"QueryQueueTime","Dimensions":[{"Value":"SUCCEEDED","Name":"QueryState"},{"Value":"'${ATHENA_QUERY_TYPE}'","Name":"QueryType"}],"Namespace":"AWS/Athena"}}},{"Id":"m2","ReturnData":false,"MetricStat":{"Period":300,"Stat":"Maximum","Metric":{"MetricName":"QueryQueueTime","Dimensions":[{"Value":"FAILED","Name":"QueryState"},{"Value":"'${ATHENA_QUERY_TYPE}'","Name":"QueryType"}],"Namespace":"AWS/Athena"}}},{"Id":"m3","ReturnData":false,"MetricStat":{"Period":300,"Stat":"Maximum","Metric":{"MetricName":"QueryQueueTime","Dimensions":[{"Value":"CANCELED","Name":"QueryState"},{"Value":"'${ATHENA_QUERY_TYPE}'","Name":"QueryType"}],"Namespace":"AWS/Athena"}}}]'

   echo "Created Alarm : ${ALARM_NAME}"
}

create_alarm "AthenaQueueWaitTimeWarningDDL" "Emails when Athena queries are queued for more than 3 mins" ${WARNING_TIME_THRESHOLD_IN_MILLISECONDS} ${WARNING_SNS_ARN} "DDL"
create_alarm "AthenaQueueWaitTimeWarningDML" "Emails when Athena queries are queued for more than 3 mins" ${WARNING_TIME_THRESHOLD_IN_MILLISECONDS} ${WARNING_SNS_ARN} "DML"
create_alarm "AthenaQueueWaitTimeErrorDDL" "Emails when Athena queries are queued for more than 5 mins" ${ERROR_TIME_THRESHOLD_IN_MILLISECONDS} ${ERROR_SNS_ARN} "DDL"
create_alarm "AthenaQueueWaitTimeErrorDML" "Emails when Athena queries are queued for more than 5 mins" ${ERROR_TIME_THRESHOLD_IN_MILLISECONDS} ${ERROR_SNS_ARN} "DML"