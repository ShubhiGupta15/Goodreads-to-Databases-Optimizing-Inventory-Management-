-- Query 2: Most Published Publishers Over Time
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

