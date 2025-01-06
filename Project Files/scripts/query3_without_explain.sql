-- Query 3: Average Rating for Each Author
-- This query calculates the average rating for each author based on the ratings of their books.
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


