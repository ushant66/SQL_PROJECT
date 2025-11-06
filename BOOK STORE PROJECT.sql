-- use book database
use book;
-- all data from book_store table
SELECT 
    *
FROM
    book_store;
-- add new column publish name and publish date
ALTER TABLE book_store
ADD COLUMN publisher_name VARCHAR(255),
ADD COLUMN publish_date VARCHAR(255);

-- tem safe mode is off
SET SQL_SAFE_UPDATES = 0;

-- split data from publish columns to publish name
UPDATE book_store 
SET 
    publisher_name = TRIM(SUBSTRING_INDEX(publisher, '(', 1));

-- split data from publish column to publish date
UPDATE book_store 
SET 
    publish_date = TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(publisher, '(', - 1),
                    ')',
                    1),
            ')',
            ''));

-- drop main column publish
ALTER TABLE book_store
DROP COLUMN publisher;

-- Find all books with missing or invalid prices
SELECT 
    *
FROM
    book_store
WHERE
    price IS NULL OR price = 0;


-- Display all records from the table
SELECT 
    *
FROM
    book_store;

-- Write an SQL query to display the titles and publish dates of all books that were published before the year 2005.
SELECT 
    TITLE, PUBLISH_DATE
FROM
    book_store
WHERE
    publish_date < 2005
LIMIT 0 , 1000;

-- Show only the title, author, and price of all books
SELECT 
    title, Author, price
FROM
    book_store;

-- Count how many books were published each year
SELECT 
    publish_date, COUNT(*) AS book_per_year
FROM
    book_store
GROUP BY publish_date
ORDER BY publish_date;

-- Find the average book price per publisher
SELECT 
    publisher_name, ROUND(AVG(price), 2) AS avg_price
FROM
    book_store
GROUP BY publisher_name
ORDER BY avg_price DESC;



-- Find the total number of books available in the dataset
SELECT 
    COUNT(*) AS total_book
FROM
    book_store;

-- List all distinct publishers present in the dataset
SELECT DISTINCT
    publisher_name
FROM
    book_store;

-- Find the average price of all books
SELECT 
    AVG(price) AS avg_price
FROM
    book_store;

-- Find the total number of books written by each author
SELECT 
    Author, COUNT(*) AS total_book
FROM
    book_store
GROUP BY Author;

-- Find the highest and lowest priced books
SELECT 
    title, price, Author
FROM
    book_store
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            book_store)
        OR price = (SELECT 
            MIN(price)
        FROM
            book_store);

-- Find the top 5 most expensive books and their authors
SELECT 
    title, Author, Price
FROM
    book_store
ORDER BY price DESC
LIMIT 5;

-- Display authors who have written more than 3 books
SELECT 
    AUTHOR, COUNT(*) AS TOTAL_BOOKS
FROM
    BOOK_STORE
GROUP BY AUTHOR
HAVING COUNT(*) > 3
ORDER BY TOTAL_BOOKS DESC;


-- Rank books by price within each publisher
SELECT PUBLISHER_NAME, TITLE, PRICE, rank() OVER(partition by PUBLISHER_NAME order by PRICE DESC) AS PRICE_RANK FROM book_STORE;

-- Show cumulative number of books published over the years
SELECT PUBLISH_DATE ,COUNT(*) AS BOOK_PUBLISHED,
sum(count(*)) OVER (order by PUBLISH_DATE)AS CUMLATIVE_BOOKS
FROM BOOK_STORE
group by PUBLISH_DATE
order by PUBLISH_DATE;

-- Find the top 3 most expensive books per publisher 
SELECT publisher_name, title, price
FROM (
  SELECT 
    publisher_name,
    title,
    price,
    DENSE_RANK() OVER (PARTITION BY publisher_name ORDER BY price DESC) AS rnk
  FROM book_store
) ranked_books
WHERE rnk <= 3;

-- Find authors who published more than 3 books after 2010 using a CTE
WITH recent_books AS (
    SELECT author, COUNT(*) AS book_count
    FROM book_store
    WHERE publish_date > 2010
    GROUP BY author
)
SELECT author, book_count
FROM recent_books
WHERE book_count > 3;

-- Classify books based on publish year
SELECT title, publish_date,
CASE
    WHEN publish_date < 2000 THEN 'Old'
    WHEN publish_date BETWEEN 2000 AND 2015 THEN 'Medium'
    ELSE 'New'
END AS book_category
FROM book_store;

-- Create a new table for author details
CREATE TABLE author_details (
    author VARCHAR(255),
    country VARCHAR(100),
    birth_year INT
);


-- Insert some sample data
INSERT INTO author_details (author, country, birth_year)
VALUES 
('J.K. Rowling', 'United Kingdom', 1965),
('George Orwell', 'India', 1903),
('Agatha Christie', 'United Kingdom', 1890),
('Dan Brown', 'USA', 1964),
('Chetan Bhagat', 'India', 1974),
('Paulo Coelho', 'Brazil', 1947);

select * FROM  author_details;

-- Show all books with their author’s country USING JOIN
SELECT 
    b.title,
    b.author,
    a.country,
    b.price
FROM 
    book_store b
INNER JOIN 
    author_details a
ON 
    b.author = a.author;
    
--  List all books and their author details (even if author not found in author_details table).
SELECT 
    b.title,
    b.author,
    a.country,
    a.birth_year
FROM 
    book_store b
LEFT JOIN 
    author_details a
ON 
    b.author = a.author;

-- Show all authors, even those whose books are not in the dataset.
SELECT 
    a.author,
    a.country,
    b.title,
    b.price
FROM 
    author_details a
RIGHT JOIN 
    book_store b
ON 
    a.author = b.author;
    
 -- Show all unique authors and books — even unmatched records.
 SELECT 
    b.author, 
    b.title, 
    a.country
FROM 
    book_store b
LEFT JOIN 
    author_details a 
ON 
    b.author = a.author

UNION

SELECT 
    a.author, 
    NULL AS title, 
    a.country
FROM 
    author_details a
WHERE 
    a.author NOT IN (SELECT author FROM book_store);
