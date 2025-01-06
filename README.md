# Library Inventory Optimization using Goodreads Dataset

## Project Goal

The goal of this project is to design an efficient relational schema and database for **library inventory optimization** using the **Goodreads Books dataset**. This involves:

- Importing and structuring the data into **PostgreSQL**.
- Implementing efficient querying mechanisms.
- Analyzing performance improvements through **indexing** and **query optimization techniques**.

The project provides insights into optimizing library operations, including categorization, book recommendations, and usage tracking.

### Key Concepts Applied:
- Designing a conceptual model (**ER diagram**) for a real-world dataset.
- Translating a conceptual model into a **SQL schema**.
- Writing effective **SQL queries**.
- Implementing and deploying **database indexes**.
- Evaluating the performance of SQL queries and indexes.

---

## Dataset

The dataset for this project is sourced from **Goodreads**, a popular online platform for book reviews and recommendations. It provides detailed information on books, metadata, and user ratings and reviews, making it ideal for designing relational schemas and optimizing queries.

### Dataset Overview:
- **Book Information**: Titles, authors, publication details, and genres for categorization and retrieval.
- **User Ratings and Reviews**: Aggregated ratings and review counts for assessing book popularity and recommendations.
- **Additional Features**: Attributes such as ISBN numbers, language, and year of publication, essential for inventory management and identifying unique copies.

[Dataset Link](https://www.kaggle.com/datasets/jealousleopard/goodreadsbooks)

---

## Design Stage Decisions

### Schema Design:
- Identified core entities: `Books`, `Authors`, `Genres`, and `Ratings`.
- Normalized the database to remove redundancy and ensure data integrity.
- Defined primary and foreign keys to establish relationships.

### Relationships:
- **One-to-Many Relationships**: Example - `Author` → `Books`.
- **Many-to-Many Relationships**: Example - `Books` ↔ `Genres` (using a bridge table).

### Indexing:
- Indexed key fields such as `Title`, `Author`, and `Genre` to enhance query performance.
- Added composite indexes for multi-criteria searches.

### Constraints:
- Applied constraints like `NOT NULL`, `UNIQUE` (e.g., ISBN), and foreign keys to ensure data accuracy and integrity.

### Optimization:
- Designed queries for use cases like recommendations, genre-based searches, and identifying popular books.
- Precomputed aggregated fields (e.g., average ratings) to improve query efficiency.

---

## ER Diagram

The ER diagram represents the database design, showcasing entities such as Books, Authors, Genres, and Ratings along with their attributes and relationships.


---

## Conclusion

This project focuses on optimizing a library inventory system by designing a relational database using PostgreSQL. Through data conversion, modeling, and analysis, the system provides insights into book ratings, authors, genres, and other attributes for better inventory management. 

### Deliverables:
- ER models
- DDL/DML statements
- SQL queries

### Outcomes:
- A robust and scalable database system.
- Enhanced operational efficiency.
- Practical demonstration of database systems concepts, enabling data-driven decisions for optimized library inventory management.

---
