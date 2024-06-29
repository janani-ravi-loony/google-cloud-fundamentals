
#################################
##### Public Datasets

Click on the Navigation Menu and click on BigQuery > SQL Workspace

Click on Hide Preview features

On the left hand side we can see our project . Pin our project 

Go to https://cloud.google.com/bigquery/public-data and scroll through the page

Under the section “Accessing public datasets in the Cloud Console” we can see the link

Copy the link 
https://console.cloud.google.com/bigquery?project=bigquery-public-data&page=project 
and open the link in a new browser window

Now click on bigquery-public-data and show the list

Search for chicago_taxi_trips

Open up the taxi_trips table and show "Schema", "Details", and "Preview"

=> Note the size of the table, it will be expensive to run queries on this table

Try to run a query Click on "Query Table"

A query will be populated with the cursor just after the "SELECT"

Click on the columns that you are interested in 

Try to run, the query will fail because you have explicitly select your project so you can be billed for this


Select the project from the project drop-down, and query table again

=> Show how many GBs are processed when you run this query on the bottom right

Show the results at the bottom

Click on "Job information", "Results", "JSON", "Execution details"



#################################
##### Creating our own datasets and tables

Click on our project and create a new dataset called my_dataset

Within my_dataset, click on CREATE TABLE

Within Create table from: click on ‘Upload’ select a file from Desktop (life_exp.csv), 
give the table name as "life_expectancy" and choose Auto detect schema

Open life_expectancy and click on "Schema", "Preview", and "Details"


Open up Cloud Shell and run this

bq mk \
-t \
--expiration 120 \
--description "My table" \
my_dataset.my_table \
name:STRING,sales:FLOAT,year:STRING


Go back to the BigQuery page and refresh, show that the table has been created

Show the details of the table (it will disappear in 2 minutes we can show that later)


#################################
##### Running queries on tables

SELECT * FROM `plucky-respect-310804.my_dataset.life_expectancy` LIMIT 1000

Click on More -> Format and show the query formatted

Run the query and show the results

Click on More -> Query settings, show the settings


Next show this query

SELECT
  Status, AVG( Life_expectancy_)
FROM
  `plucky-respect-310804.my_dataset.life_expectancy`


Show the error, in the validator

Fix the error as shown below

SELECT
  Status, AVG( Life_expectancy_)
FROM
  `plucky-respect-310804.my_dataset.life_expectancy`
GROUP BY 
  Status

#################################
##### Data Studio

Set up a new condition

SELECT
  *
FROM
  `plucky-respect-310804.my_dataset.life_expectancy`
WHERE
  Status = "Developed"
  AND Life_expectancy_ >= 70


Click on EXPLORE DATASET (Explore with Data Studio)

# data studio opens up and on the right hand side we can see Chart 

Click on Time Series Chart

Click on Data and change:
Dimension : Year
Breakdown Dimension : Country
Metric : Life_expectancy
Sort : Year (Descending)
Secondary Sort : Life_expectancy


Click on Column Chart

Click on Data and change:
Dimension : Country
Metric : Population


#################################
##### Saved queries and save results to destination table


Click on Save Query, save it as High Life Expectancy

Go to saved Queries on the Left Hand Side and open the query and show that we have this query saved

SELECT
  Country,
  Status,
  Life_expectancy_,
  GDP
FROM
  `plucky-respect-310804.my_dataset.life_expectancy`
WHERE
  Year = 2015


# Do NOT run the query

Click on More > Query settings

Select on Set a destination table for query results
Give dataset name - my_dataset
Give table name as - life_expectancy_subset
Save

Run the query

Show the new table created


















