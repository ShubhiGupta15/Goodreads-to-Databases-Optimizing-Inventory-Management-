-- Drop existing tables if they exist to start fresh
DROP TABLE IF EXISTS book_authors CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;
DROP TABLE IF EXISTS languages CASCADE;

-- Create authors table
CREATE TABLE authors (
    authorID VARCHAR(255) PRIMARY KEY,
    name VARCHAR(1000) NOT NULL
);


-- Create publishers table
CREATE TABLE publishers (
    publisherID INT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL
);

-- Create languages table
CREATE TABLE languages (
    language_name VARCHAR(50) PRIMARY KEY
);

-- Create books table
CREATE TABLE books (
    bookID INT PRIMARY KEY,
    title VARCHAR(1000) NOT NULL,
    authors VARCHAR(1000),  -- Authors as a string (multiple authors can be separated by "/")
    average_rating DECIMAL(3, 2),
    isbn TEXT CHECK (isbn ~ '^[0-9X]+$'),      -- Allows numbers and 'X'
    isbn13 TEXT CHECK (isbn13 ~ '^[0-9X]+$'),
    num_pages INT,
    ratings_count INT,
    text_reviews_count INT,
    publication_date DATE,
    publisher VARCHAR(200) NOT NULL,
    language_name VARCHAR(50),
    publisherID INT,
    authorID VARCHAR(255),
    FOREIGN KEY (publisherid) REFERENCES publishers(publisherid),
    FOREIGN KEY (language_name) REFERENCES languages(language_name)
);

-- Create book_authors table
CREATE TABLE book_authors (
    bookID INT REFERENCES books(bookID),
    authorID VARCHAR(255) REFERENCES authors(authorID),
    PRIMARY KEY (bookID, authorID)
);

-- Load data into the authors table
\COPY authors(name,authorID) FROM '../data/authors.csv' WITH CSV HEADER ENCODING 'UTF8';

-- Load data into the publishers table
\COPY publishers(publisherid,publisher_name) FROM '../data/publishers.csv' WITH CSV HEADER ENCODING 'UTF8';

-- Load data into the languages table
\COPY languages(language_name) FROM '../data/languages.csv' WITH CSV HEADER ENCODING 'UTF8';

-- Load data into the books table
\COPY books(bookID,title,authors,average_rating,isbn,isbn13,num_pages,ratings_count,text_reviews_count,publication_date,publisher, language_name, publisherID,authorID) FROM '../data/final_cleaned_data.csv' WITH CSV HEADER ENCODING 'UTF8';

-- Load data into the book_authors table
\COPY book_authors(bookID, authorid) FROM '../data/book_authors.csv' WITH CSV HEADER ENCODING 'UTF8';

-- Verify the data by selecting from the tables
SELECT * FROM authors LIMIT 5;
SELECT * FROM books LIMIT 5;
SELECT * FROM publishers LIMIT 5;
SELECT * FROM languages LIMIT 5;
SELECT * FROM book_authors LIMIT 5;
