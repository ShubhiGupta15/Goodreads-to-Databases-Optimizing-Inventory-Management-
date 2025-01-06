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


