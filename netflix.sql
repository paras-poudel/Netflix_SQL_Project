
use netflix_db;
create table netflix (
	show_id	 varchar(10),
    type varchar(500),
	title	varchar(200),
	director	varchar(500),
	cast	varchar(1000),
	country	varchar(200),
	date_added	varchar(100),
	release_year	INT,
	rating	varchar(200), 
    duration	varchar(300),
	listed_in	varchar(500),
    description varchar(500)
);

-- Importing csv file
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select 
	count(*) as total_content
from netflix;

select 
	distinct type
from netflix;

select * from netflix;

-- Objectives
-- 1.Count the number of movies vs TV shows
SELECT 
	type,
    COUNT(*) as total_content
FROM netflix
GROUP by type;

-- 2.Find the most common rating movies and TV shows
SELECT
	type,
	rating
FROM
	(
		SELECT 
			type,
			rating,
			COUNT(*),
            RANK () OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
		FROM netflix
		group by 1,2
	) as t1
WHERE ranking=1;

-- 3. List all movies released in a specific year

SELECT *
FROM netflix
WHERE type IN ('Movie', 'TV Show')
  AND release_year = 2020
ORDER BY 
   CASE WHEN type = 'Movie' THEN 1 ELSE 2 END,  -- Movies first
   title;                                       -- Alphabetical inside each group
   
-- 4. Find the top 5 countries with most content on netflix
WITH RECURSIVE country_split AS (
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
        SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2) AS rest
    FROM netflix
    WHERE country IS NOT NULL
    
    UNION ALL
    
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
    FROM country_split
    WHERE rest <> ''
)
SELECT country, COUNT(*) AS total_content
FROM country_split
WHERE country <> ''   -- 🔑 filter out blank entries
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT 
	*,
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS minutes
FROM netflix
WHERE type = 'Movie'
ORDER BY minutes DESC
LIMIT 5;

-- 6. Find content added in last 5 years   
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

-- 7. Total content added in last 10 years
SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year_added,
    COUNT(*) AS total_content
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 10 YEAR
GROUP BY YEAR(STR_TO_DATE(date_added, '%M %d, %Y'))
ORDER BY year_added;

-- 8. Find all the movies / Tv shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE LOWER(director) LIKE '%rajiv chilaka%';


-- 9. List all Tv shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
  

-- 10. Count the number of content in each genre
WITH RECURSIVE genre_split AS (
		-- Step 1: take the first genre from each row
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
        SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2) AS rest
    FROM netflix
    WHERE listed_in IS NOT NULL

    UNION ALL

		-- Step 2: recursively get the next genre
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
    FROM genre_split
    WHERE rest <> ''
)

	-- Step 3: count content per genre
SELECT genre, COUNT(*) AS total_content
FROM genre_split
WHERE genre <> ''       -- exclude blank entries
GROUP BY genre
ORDER BY total_content DESC;


-- 11. Find each year and average numbers of contents released by India on netflix. Return top 5 years with highest content release.
SELECT 
    release_year,
    COUNT(*) AS total_content
FROM netflix
WHERE country LIKE '%India%'      -- filter only Indian content
GROUP BY release_year              -- group by year of release
ORDER BY total_content DESC        -- sort by highest content released
LIMIT 5;                           -- top 5 years

-- 12. Find how many movies actor 'Salman Khan ' appeared in last 20 years
SELECT *
FROM netflix
WHERE type = 'Movie'                           -- only consider movies
  AND cast LIKE '%Salman Khan%'                -- check if actor is in cast
  AND release_year >= YEAR(CURDATE()) - 10;   -- last 10 years
  
-- 13. Find the top 10 actors who have appeared in the highest number of movies produced in India. 
 
WITH RECURSIVE actor_split AS (
    -- Step 1: take the first actor from each row
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(cast, ',', 1)) AS actor,
        SUBSTRING(cast, LENGTH(SUBSTRING_INDEX(cast, ',', 1)) + 2) AS rest
    FROM netflix
    WHERE type = 'Movie' AND country LIKE '%India%' AND cast IS NOT NULL

    UNION ALL

    -- Step 2: recursively get the next actor
    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
    FROM actor_split
    WHERE rest <> ''
)

-- Step 3: count appearances per actor
SELECT actor, COUNT(*) AS total_movies
FROM actor_split
WHERE actor <> ''        -- exclude blanks
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;               -- top 10 actors

/* 14. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/
SELECT 
    CASE 
        WHEN lower(description) LIKE '%kill%' OR lower(description) LIKE '%violence%' 
            THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_content,
      ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix), 2) AS percentage
FROM netflix
GROUP BY category;




   