# SCM-Database-Design-and-Implementation

# 1. Introduction
This project comprehensively explains the database design, implementation process, and testing strategy. It includes design decisions, justifications, T-SQL statements, and supporting screenshots from SQL Server Management Studio (SSMS).

---
# 2. Database Design Decisions

## 2.1 Database Design and Decisions
The database is designed to efficiently manage suppliers, customers, orders, shipments, products, and their movement across warehouses. The primary design considerations include: **Normalization and Adherence to 3rd Normal Form (3NF)** The design follows the principles of 3NF to eliminate redundancy, ensure data integrity, and optimize query performance. The database meets 3NF requirements as follows:
- 1st Normal Form (1NF): Each table contains atomic (indivisible) values, ensuring all columns contain only single values, with unique rows identified by primary keys.
- 2nd Normal Form (2NF): All non-key attributes entirely depend on the primary key. For example, in the Orders table, customer_id is linked to a separate Customers table, avoiding partial dependency.
- 3rd Normal Form (3NF): The design removes transitive dependencies, ensuring that non-key attributes depend only on the primary key.
For example, supplier_id in the Products table ensures that supplier details are stored in the Suppliers table rather than duplicating supplier information within the Products table. customer_id in the Orders table links to the Customers table rather than storing customer names directly in Orders, preventing redundancy.

# 2.2 Entity and Table Design
The database stores and manages data related to suppliers, customers, products, orders, warehouses, inventories, shipments, and product movements. The design follows the relational database model with normalized tables to ensure data integrity and minimize redundancy.
Tables Created:
1. Suppliers: Stores supplier details.
2. Customers: Maintains customer information and loyalty status.
3. Orders: Tracks customer orders and their statuses.
4. Order Details: Contains details of each order.
5. Products: Lists available products and their categories.
6. Warehouses: Manages warehouse locations.
7. Inventories: Tracks product stock levels in warehouses.
8. Shipments: Records product shipments from suppliers to warehouses.
9. ProductMovement: Monitors product movement between warehouses and suppliers.
10. SupplierProducts: Links suppliers with the products they supply.

![image](https://github.com/user-attachments/assets/e41979fa-3b4b-4629-9293-3c63f6f0f7dc)


# 3. Implementation Process
## 3.1 Creating Database and Tables
T-SQL was used to create the database schema. The primary and foreign keys were defined to establish relationships between tables.

## Creating the Suppliers Table

```
CREATE TABLE Suppliers (
supplier_id INT PRIMARY KEY IDENTITY,
supplier_name VARCHAR(30),
region VARCHAR(30),
phone_number VARCHAR(20),
email VARCHAR(20)
)
```























