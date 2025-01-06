-- Query 8: Authors Writing in Multiple Languages
--Find authors who have written books in more than one language.

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




