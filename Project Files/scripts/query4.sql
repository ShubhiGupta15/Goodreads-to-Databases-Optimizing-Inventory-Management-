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

