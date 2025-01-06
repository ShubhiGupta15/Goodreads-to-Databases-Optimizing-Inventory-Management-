
-- Drop existing indexes if they exist
DROP INDEX IF EXISTS idx_books_avg_rating134;
DROP INDEX IF EXISTS idx_books_text_reviews134;
DROP INDEX IF EXISTS idx_books_publication_date134;
DROP INDEX IF EXISTS idx_publishers_name134;
DROP INDEX IF EXISTS idx_book_authors_bookid134;
DROP INDEX IF EXISTS idx_book_authors_authorid134;
DROP INDEX IF EXISTS idx_authors_name134;
DROP INDEX IF EXISTS idx_book_authors_author_book134;
DROP INDEX IF EXISTS idx_books_publisher_date134;
DROP INDEX IF EXISTS idx_books_author_rating134;
DROP INDEX IF EXISTS idx_books_no_reviews134;
DROP INDEX IF EXISTS idx_books_high_ratings_reviews134;
DROP INDEX IF EXISTS idx_books_publisher_name134;
DROP INDEX IF EXISTS idx_books_ratings_reviews134;
DROP INDEX IF EXISTS idx_books_language134;
DROP INDEX IF EXISTS idx_books_author_languages134;
DROP INDEX IF EXISTS idx_books_rare_languages134;

-- Create indexes to optimize queries

-- Index on books table for average_rating, text_reviews_count, and publication_date
CREATE INDEX IF NOT EXISTS idx_books_avg_rating134 ON books (average_rating);
CREATE INDEX IF NOT EXISTS idx_books_text_reviews134 ON books (text_reviews_count);
CREATE INDEX IF NOT EXISTS idx_books_publication_date134 ON books (publication_date);

-- Index on publishers table for name
CREATE INDEX IF NOT EXISTS idx_publishers_name134 ON publishers (name);

-- Index on book_authors table for bookID and authorID
CREATE INDEX IF NOT EXISTS idx_book_authors_bookid134 ON book_authors (bookID);
CREATE INDEX IF NOT EXISTS idx_book_authors_authorid134 ON book_authors (authorID);

-- Index on authors table for name
CREATE INDEX IF NOT EXISTS idx_authors_name134 ON authors (name);

-- Additional indexes for the new queries:

-- Query 1: Top 10 Authors by Total Number of Books
CREATE INDEX IF NOT EXISTS idx_book_authors_author_book134 ON book_authors (authorID, bookID);

-- Query 2: Most Published Publishers Over Time
CREATE INDEX IF NOT EXISTS idx_books_publisher_date134 ON books (publisherID, publication_date);

-- Query 3: Average Rating for Each Author
CREATE INDEX IF NOT EXISTS idx_books_author_rating134 ON books (average_rating, language_name);

-- Query 4: Authors with No Reviews
CREATE INDEX IF NOT EXISTS idx_books_no_reviews134 ON books (text_reviews_count);

-- Query 5: Books with High Ratings and Reviews Published by Active Publishers
CREATE INDEX IF NOT EXISTS idx_books_high_ratings_reviews134 ON books (average_rating DESC, text_reviews_count DESC);
CREATE INDEX IF NOT EXISTS idx_books_publisher_name134 ON publishers (name);

-- Query 6: Authors with the Highest Number of Ratings and Reviews
CREATE INDEX IF NOT EXISTS idx_books_ratings_reviews134 ON books (ratings_count, text_reviews_count);

-- Query 7: Average Ratings by Language
CREATE INDEX IF NOT EXISTS idx_books_language134 ON books (language_name, average_rating);

-- Query 8: Authors Writing in Multiple Languages
CREATE INDEX IF NOT EXISTS idx_books_author_languages134 ON books (language_name);

-- Query 9: Books in Rare Languages
CREATE INDEX IF NOT EXISTS idx_books_rare_languages134 ON books (language_name);
