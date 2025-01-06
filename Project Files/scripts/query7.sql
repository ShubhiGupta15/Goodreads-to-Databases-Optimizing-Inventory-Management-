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



