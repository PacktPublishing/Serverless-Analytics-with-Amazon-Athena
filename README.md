


# Serverless Analytics with Amazon Athena

<a href="https://www.packtpub.com/product/serverless-analytics-with-amazon-athena/9781800562349"><img src="https://static.packt-cdn.com/products/9781800562349/cover/smaller" alt="Power Query Cookbook" height="256px" align="right"></a>

This is the code repository for [Serverless Analytics with Amazon Athena](https://www.packtpub.com/product/serverless-analytics-with-amazon-athena/9781800562349), published by Packt.

**Query structured, unstructured, or semi-structured data in seconds without setting up any infrastructure**

## What is this book about?

Amazon Athena is an interactive query service that makes it easy to analyze data in Amazon S3 using SQL, without needing to manage any infrastructure.

This book begins with an overview of the serverless analytics experience offered by Athena and teaches you how to build and tune an S3 Data Lake using Athena, including how to structure your tables using open-source file formats like Parquet. You’ll learn how to build, secure, and connect to a data lake with Athena and Lake Formation. Next, you’ll cover key tasks such as ad hoc data analysis, working with ETL pipelines, monitoring and alerting KPI breaches using CloudWatch Metrics, running customizable connectors with AWS Lambda, and more. Moving on, you’ll work through easy integrations, troubleshooting and tuning common Athena issues, and the most common reasons for query failure. You will also review tips to help diagnose and correct failing queries in your pursuit of operational excellence. Finally, you’ll explore advanced concepts such as Athena Query Federation and Athena ML to generate powerful insights without needing to touch a single server.

By the end of this book, you’ll be able to build and use a data lake with Amazon Athena to add data-driven features to your app and perform the kind of ad hoc data analysis that often precedes many of today’s ML modeling exercises.

This book covers the following exciting features: 
* Secure and manage the cost of querying your data
* Use Athena ML and User Defined Functions (UDFs) to add advanced features to your reports
* Write your own Athena Connector to integrate with a custom data source
* Discover your datasets on S3 using AWS Glue Crawlers
* Integrate Amazon Athena into your applications
* Setup Identity and Access Management (IAM) policies to limit access to tables and databases in Glue Data Catalog
* Add an Amazon SageMaker Notebook to your Athena queries
* Get to grips with using Athena for ETL pipelines

If you feel this book is for you, get your [copy](https://www.amazon.com/Serverless-Analytics-Amazon-Athena-semi-structured-dp-1800562349/dp/1800562349/ref=mt_other?_encoding=UTF8&me=&qid=1635753407) today!

<a href="https://www.packtpub.com/product/serverless-analytics-with-amazon-athena/9781800562349"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" alt="https://www.packtpub.com/" border="5" /></a>

## Instructions and Navigations
All of the code is organized into folders.

The code will look like the following:
```
try:
    sink.writeFrame(new_and_updated_impressions_dataframe)
    glueContext.commit_transaction(txid1)
except:
    glueContext.abort_transaction(txid1)

```

**Following is what you need for this book:**
Business intelligence (BI) analysts, application developers, and system administrators who are looking to generate insights from an ever-growing sea of data while controlling costs and limiting operational burden, will find this book helpful. Basic SQL knowledge is expected to make the most out of this book.

With the following software and hardware list you can run all code files present in the book (Chapter 1-14).

### Software and Hardware List

| Chapter  | Software required                                                                    | OS required                        |
| -------- | -------------------------------------------------------------------------------------| -----------------------------------|
|  	1-14	   |   	       Amazon Web Services                         			  | Windows, Mac OS X, and Linux (Any) | 		


We also provide a PDF file that has color images of the screenshots/diagrams used in this book. [Click here to download it](http://www.packtpub.com/sites/default/files/downloads/9781800562349_ColorImages.pdf).

### Related products <Other books you may enjoy>
* Learn Amazon SageMaker [[Packt]](https://www.packtpub.com/product/learn-amazon-sagemaker/9781800208919) [[Amazon]](https://www.amazon.com/Learn-Amazon-SageMaker-developers-scientists/dp/180020891X/ref=sr_1_2?dchild=1&keywords=Learn+Amazon+SageMaker&qid=1635754744&s=books&sr=1-2)

* Scalable Data Streaming with Amazon Kinesis [[Packt]](https://www.packtpub.com/product/scalable-data-streaming-with-amazon-kinesis/9781800565401) [[Amazon]](https://www.amazon.com/Scalable-Data-Streaming-Amazon-Kinesis-ebook/dp/B08YM1RJLT/ref=sr_1_1?dchild=1&keywords=Scalable+Data+Streaming+with+Amazon+Kinesis&qid=1635754820&s=books&sr=1-1)
  
## Get to Know the Author(s)
**Anthony Virtuoso** works as a Principal Engineer at Amazon and holds multiple patents in distributed systems, software defined networks, and security. In his eight years at Amazon, he has helped launch several Amazon Web Services, the most recent of which was Amazon Managed Blockchain. As one of the original authors of Athena Query Federation, you'll often find him lurking on the Athena Federation GitHub repository answering questions and shipping bug fixes. When not at work, Anthony obsesses over a different set of customers, namely his wife and two little boys, aged 2 and 5. His kids enjoy doing science experiments with dad, like 3D printing toys, building with Lego, or searching the local pond for tardigrades.

**Mert Turkay Hocanin** is a Principal Big Data Architect at Amazon Web Services within the AWS Glue and AWS Lake Formation services and has previously worked for several other services including Amazon Athena, Amazon EMR, Amazon Managed Blockchain. During his time at AWS, he worked with several Fortune 500 companies on some of the largest data lakes in the world and was involved with the launching of three Amazon Web Services. Prior to being a Big Data Architect, he was a Senior Software Developer within Amazon's retail systems organization building one of the earliest data lakes in the company in 2013. When he is not helping customers build data lakes, he enjoys spending time with his wife-Subrina, son-Tristan, and exploring New York City.

**Aaron Wishnick** works as a Senior Software Engineer at Amazon, where he has been for 7 years. During that time he has worked on Amazon's payment systems, financial intelligence systems, as well as working for AWS on Athena and AWS Proton. When not at work, Aaron and his fiance, Alyssa, are on a quest to determine just how much dog fur is too much, with their husky and malamute, Mina and Wally.
### Download a free PDF

 <i>If you have already purchased a print or Kindle version of this book, you can get a DRM-free PDF version at no cost.<br>Simply click on the link to claim your free PDF.</i>
<p align="center"> <a href="https://packt.link/free-ebook/9781800562349">https://packt.link/free-ebook/9781800562349 </a> </p>