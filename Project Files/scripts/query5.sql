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


