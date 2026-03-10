# Database Project – Delivery II

## Overview
This project implements a relational database designed to demonstrate proper database modeling and implementation using SQL. The database structure is represented using an Entity Relationship Model (ERM), and the schema is implemented using a SQL script that creates all tables, defines relationships, and inserts synthetic data.

The SQL script is designed to run in a standard relational database management system such as **MySQL** or **MariaDB**.

---

## Project Files

The submission contains two main components:

### Entity Relationship Model (ERM)
The ERM visually represents the structure of the database and includes:

- All entities
- Attributes for each entity
- Primary keys
- Foreign keys
- Relationship cardinalities
- Data types for attributes

The ERM clearly shows how tables are connected and how data flows between them.

### SQL Schema and Data Script
The SQL file contains all commands required to create and populate the database.

The script includes:

- Creation of the database
- Selection of the database
- Creation of all tables
- Definition of primary keys and foreign keys
- Definition of constraints
- Insertion of synthetic data

---

## Database Implementation

The SQL script performs the following steps:

1. Creates the database.
2. Selects the database for use.
3. Creates all required tables with appropriate attributes and data types.
4. Defines primary keys and foreign key relationships.
5. Inserts synthetic sample data into each table.

These constraints ensure **referential integrity** and maintain consistency between related records.

---

## Synthetic Data

All data used in this project is **synthetic**. Synthetic data is artificially generated and does not correspond to real individuals, customers, or organizations.

The purpose of the synthetic dataset is to:

- Demonstrate that the schema functions correctly
- Verify relationships between tables
- Ensure foreign key constraints are properly enforced

Only a small number of rows are inserted into each table, which is sufficient to demonstrate meaningful relationships.

---

## Running the SQL Script

To run the database:

1. Open **MySQL** or **MariaDB**.
2. Execute the SQL file included in the project.

Example:

```sql
SOURCE database_schema.sql;