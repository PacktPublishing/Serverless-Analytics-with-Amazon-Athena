#!/bin/bash
#----------------------------------------------------------------------------------
# This script will copy Chapter 11's sample datasets to an S3 location.
# To use this script, enter the S3 path destination below
#----------------------------------------------------------------------------------

#Fill the below variable in
S3_PATH_DESTINATION=<PUT ROOT OF S3 PATH HERE>

GITHUB_ROOT=https://raw.githubusercontent.com/PacktPublishing/Serverless-Analytics-with-Amazon-Athena/main
CHAPTER=chapter_11

aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sample_datasets/clicks/website-clicks.txt 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sample_datasets/customers/customers.json 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sample_datasets/inventory/inventory.csv 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sample_datasets/marketing/marketing_data.tsv 
aws s3 cp ${GITHUB_ROOT}/${CHAPTER}/sample_datasets/sales/sales_data.csv 
