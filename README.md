### Netflix Data Analysis in MySQL
This project analyzes the Netflix Movies and TV Shows dataset using MySQL. It includes database setup, data import, exploratory analysis, and advanced SQL queries (CTEs, string functions, grouping) to uncover insights into Netflix’s content catalog.

## Objectives
1. Create and set up a MySQL database for the Netflix dataset
2. Import data from CSV into relational tables
3. Analyze content distribution (Movies vs TV Shows, ratings, durations)
4. Explore trends by year, country, and genre
5. Identify top actors, directors, and countries contributing to Netflix
6. Apply advanced SQL techniques such as recursive CTEs and string manipulation

## Key Features
#  Data Preparation & Setup

#Table creation (netflix)
 CSV import using LOAD DATA INFILE
 Handling secure_file_priv issues for file loading

## Exploratory Analysis
1. Count of Movies vs TV Shows
2. Most common ratings for both Movies and TV Shows
3. Content added in the last 5–10 years
4. Longest movies and TV shows with more than 5 seasons

## Country & Genre Insights
1. Top 5 countries with the most Netflix content
2. Year-wise content release from India
3. Splitting multi-genre fields using recursive CTEs
4. Counting the number of titles per genre

## People Insights
1. Movies/TV Shows by specific directors (e.g., Rajiv Chilaka)
2. Number of movies featuring Salman Khan in the last 10 years
3. Top 10 actors with the highest appearances in Indian movies

## Advanced SQL Techniques
* Recursive CTEs to split comma-separated fields (actors, countries, genres)
* String manipulation (SUBSTRING_INDEX, CAST, TRIM) for extracting values
* Aggregations (COUNT, GROUP BY, ORDER BY) for summarizing data
* Categorization using CASE WHEN (e.g., labeling content as Good or Bad based on description keywords)

## Requirements
MySQL 8.0 or later
Netflix dataset (from Kaggle: Netflix Movies and TV Shows)

## How to Run
#Clone this repository:
 git clone https://github.com/your-username/netflix-mysql-analysis.git
 cd netflix-mysql-analysis

#Create and select a MySQL database:
 CREATE DATABASE netflix_db;
 USE netflix_db;
 Run the SQL script:
 mysql -u your_username -p netflix_db < netflix.sql


#Ensure netflix_titles.csv is placed inside your MySQL secure_file_priv folder
(e.g., C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/).
