
#################################
##### Public Datasets

# Click on the Navigation Menu and click on BigQuery > SQL Workspace

# Click on Hide Preview features

# On the left hand side we can see our project . Pin our project 

Go to https://cloud.google.com/bigquery/public-data and scroll through the page

# Under the section “Accessing public datasets in the Cloud Console” we can see the link

Copy the link 
https://console.cloud.google.com/bigquery?project=bigquery-public-data&page=project 
and open the link in a new browser window

# Star the dataset

# Now go back to the original tab and hit refresh - your original project and the public dataset should both be visible

# Now click on bigquery-public-data and show the list

# Search for chicago_taxi_trips

# Open up the taxi_trips table and show "Schema", "Details", and "Preview"

# => Note the size of the table, it will be expensive to run queries on this table


SELECT
  *
FROM
  `bigquery-public-data.chicago_taxi_trips.taxi_trips` ;

# Note that this processes 76GB of data when it runs

# Select only a few columns

SELECT
  `company`,
  `fare`,
  `payment_type`,
  `trip_end_timestamp`,
  `trip_miles`,
  `trip_seconds`,
  `trip_start_timestamp`
FROM
  `bigquery-public-data.chicago_taxi_trips.taxi_trips` ;

# Observe that this processes only 13.38 GB of data

# Run the query and show

# Click on "Job information", "Results", "JSON", "Execution details"



#################################
##### Creating our own datasets and tables

# Click on our project and create a new dataset called "sales_dataset"


# Within "sales_dataset", click on CREATE TABLE


# Within Create table from: click on ‘Upload’ select a file from Desktop (supermarket_sales.csv), 

# Give the table name as "supermarket_sales" and choose Auto detect schema

# In Advanced

Header rows to skip = 1

# Open "supermarket_sales" and click on "Schema", "Preview", and "Details"

----------------------------------------------------


# Open up Cloud Shell and run this

bq mk \
-t \
--expiration 120 \
--description "My temporary sales table" \
sales_dataset.temp_sales_table \
name:STRING,sales:FLOAT,year:STRING


# Go back to the BigQuery page and refresh, show that the table has been created

# Show the details of the table (it will disappear in 2 minutes we can show that later)

# Cloud shell

bq ls --format prettyjson sales_dataset




#################################
##### Running queries on tables

SELECT * FROM `plucky-respect-310804.sales_dataset.supermarket_sales` LIMIT 1000

# Click on More -> Format and show the query formatted

# Run the query and show the results

# Click on More -> Query settings, show the settings


# Next show this query

SELECT
  City, AVG(Total)
FROM
  `plucky-respect-310804.sales_dataset.supermarket_sales`



# Show the error, in the validator

# Fix the error as shown below

SELECT
  Status, AVG( Life_expectancy_)
FROM
  `plucky-respect-310804.my_dataset.life_expectancy`
GROUP BY 
  Status

#################################
##### Looker Studio

Set up a new condition

SELECT
  *
FROM
  `plucky-respect-310804.sales_dataset.supermarket_sales`
WHERE 
  City = 'Mandalay'


Click on EXPLORE DATASET (Explore with Looker Studio)

# Looker studio opens up and on the right hand side we can see Chart 

Click on Time Series Chart

Click on Data and change:

Date Range Dimension: Date
Dimension : Date
Breakdown Dimension : Gender
Metric : SUM(Total)


# Add a page to the chart

# Add Column Chart


Click on Data and change:

Date Range Dimension: None
Dimension : Product Line
Metric : SUM(Total)


# On the same page add a Pie chart

Click on Data and change:

Date Range Dimension: None
Dimension : Payment
Metric : SUM(Total)


#################################
##### Saved queries and save results to destination table

# Back to the SQL editor

# Click on Save Query, save it as "Mandalay Sales"

# Go to saved Queries on the Left Hand Side and open the query and show that we have this query saved

SELECT
  *
FROM
  `plucky-respect-310804.sales_dataset.supermarket_sales`
WHERE 
  City = 'Mandalay'


# Do NOT run the query

# Click on More > Query settings

Select on Set a destination table for query results
Give dataset name - sales_dataset
Give table name as - mandalay_sales

# Save

# Run the query

# Show the new table created in the same sales_dataset


















