#!/bin/bash
#----------------------------------------------------------------------------------
# This script will copy Chapter 8's sample datasets to an S3 location.
# To use this script, enter the S3 path destination below
#----------------------------------------------------------------------------------

#Fill the below variable in
S3_PATH_DESTINATION=<PUT ROOT OF S3 PATH HERE>

GITHUB_ROOT=https://raw.githubusercontent.com/PacktPublishing/Serverless-Analytics-with-Amazon-Athena/main
CHAPTER=chapter_8

aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/clicks/website-clicks.txt 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/customers/customers.json 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/inventory/inventory.csv 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/marketing/marketing_data.tsv 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sales/sales_data.csv 
