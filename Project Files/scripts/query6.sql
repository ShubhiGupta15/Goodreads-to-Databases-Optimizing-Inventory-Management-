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



