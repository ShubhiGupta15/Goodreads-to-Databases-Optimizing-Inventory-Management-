-- Query 9: Books in Rare Languages
--Retrieve all books written in languages with fewer than 5 books in the database.

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
