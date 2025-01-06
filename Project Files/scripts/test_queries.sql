-- Query 1: Top 10 Authors by Total Number of Books
EXPLAIN ANALYZE
SELECT DISTINCT
    a.name,
    COUNT(b.bookID) AS total_books
FROM 
    authors a
    INNER JOIN book_authors ba ON a.authorID = ba.authorID
    INNER JOIN books b ON ba.bookID = b.bookID
GROUP BY 
    a.name
ORDER BY 
    total_books DESC
LIMIT 10;


-- Query 2: Most Published Publishers Over Time
EXPLAIN ANALYZE
SELECT DISTINCT
    p.publisher_name AS publisher_name,
    COUNT(b.bookID) AS total_books_published,
    MIN(b.publication_date) AS first_publication,
    MAX(b.publication_date) AS latest_publication
FROM 
    publishers p
    INNER JOIN books b ON p.publisherID = b.publisherID
WHERE 
    b.publication_date BETWEEN '2010-01-01' AND '2020-12-31'
GROUP BY 
    p.publisher_name
ORDER BY 
    total_books_published DESC
LIMIT 10;

-- Query 3: Average Rating for Each Author
-- This query calculates the average rating for each author based on the ratings of their books.
EXPLAIN ANALYZE
SELECT DISTINCT
    a.name,
    AVG(b.average_rating) AS avg_rating
FROM 
    authors a
    INNER JOIN book_authors ba ON a.authorID = ba.authorID
    INNER JOIN books b ON ba.bookID = b.bookID
GROUP BY 
    a.name
ORDER BY 
    avg_rating DESC;


-- Query 4: Authors with No Reviews
--This query finds authors whose books have not received any reviews.

EXPLAIN ANALYZE
SELECT DISTINCT
    a.name
FROM 
    authors a
    INNER JOIN book_authors ba ON a.authorID = ba.authorID
    INNER JOIN books b ON ba.bookID = b.bookID
WHERE 
    b.text_reviews_count = 0;

-- Query 5: Books with High Ratings and Reviews Published by Active Publishers
EXPLAIN ANALYZE
SELECT 
    b.title AS book_title,
    b.authors AS author,
    b.average_rating,
    b.text_reviews_count,
    b.num_pages,
    b.publication_date,
    p.publisher_name,
    COUNT(ba.authorID) AS total_authors
FROM 
    books b
    INNER JOIN publishers p ON b.publisherID = p.publisherID
    INNER JOIN book_authors ba ON b.bookID = ba.bookID
    INNER JOIN authors a ON ba.authorID = a.authorID
WHERE 
    b.average_rating > 4.5
    AND b.text_reviews_count > 100
    AND b.publication_date BETWEEN '2000-01-01' AND '2020-12-31'
    AND p.publisher_name IN (
        SELECT 
            publisher_name 
        FROM 
            publishers 
        WHERE 
            LENGTH(name) > 5
    )
GROUP BY 
    b.bookID, b.title, b.authors, b.average_rating, b.text_reviews_count, b.num_pages, b.publication_date, p.publisher_name
ORDER BY 
    b.average_rating DESC, 
    b.text_reviews_count DESC
LIMIT 10;


-- Query 6: Authors with the Highest Number of Ratings and Reviews
--This query finds authors whose books have the highest combined number of ratings and reviews.

EXPLAIN ANALYZE
SELECT DISTINCT
    a.name,
    SUM(b.ratings_count + b.text_reviews_count) AS total_ratings_reviews
FROM 
    authors a
    INNER JOIN book_authors ba ON a.authorID = ba.authorID
    INNER JOIN books b ON ba.bookID = b.bookID
GROUP BY 
    a.name
ORDER BY 
    total_ratings_reviews DESC
LIMIT 10;



-- Query 7: Average Ratings by Language
--Determine the average rating of books for each language

EXPLAIN ANALYZE
SELECT DISTINCT
    b.language_name,
    AVG(b.average_rating) AS avg_rating
FROM 
    books b
GROUP BY 
    b.language_name
ORDER BY 
    avg_rating DESC;



-- Query 8: Authors Writing in Multiple Languages
--Find authors who have written books in more than one language.

EXPLAIN ANALYZE
SELECT DISTINCT
    a.name,
    COUNT(DISTINCT b.language_name) AS total_languages
FROM 
    authors a
    INNER JOIN book_authors ba ON a.authorID = ba.authorID
    INNER JOIN books b ON ba.bookID = b.bookID
GROUP BY 
    a.name
HAVING 
    COUNT(DISTINCT b.language_name) > 1
ORDER BY 
    total_languages DESC;




-- Query 9: Books in Rare Languages
--Retrieve all books written in languages with fewer than 5 books in the database.

EXPLAIN ANALYZE
SELECT DISTINCT
    b.title,
    b.language_name
FROM 
    books b
WHERE 
    b.language_name IN (
        SELECT 
            language_name
        FROM 
            books
        GROUP BY 
            language_name
        HAVING 
            COUNT(bookID) < 5
    )
ORDER BY 
    b.language_name;
