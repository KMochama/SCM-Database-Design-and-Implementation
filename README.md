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

![image](https://github.com/user-attachments/assets/f86dfc9c-d8c9-4923-bb34-119101602018)



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

## Creating the Orders Table with Constraints

```
 CREATE TABLE Orders (
order_id INT PRIMARY KEY IDENTITY,
product_id INT REFERENCES Products(product_id),
supplier_id INT REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
customer_id INT REFERENCES Customers(customer_id),
order_date DATETIME DEFAULT GETDATE(),
status VARCHAR(10) CHECK (status IN ('Pending', 'Completed', 'Shipped', 'Cancelled'))
);
```


# 3.2 Data Insertion

## Data was inserted into the tables using INSERT INTO statements. Example:
```
INSERT INTO Suppliers (supplier_name, region, phone_number, email) VALUES
('ElectroWorld', 'Asia', '+91-1234567890', 'electro@world.com'),
('FashionHub', 'Europe', '+44-9876543210', 'fashion@hub.com');
```


# 3.3 Foreign Key Constraints

## Foreign keys ensure data consistency by enforcing relationships between tables.

```
CREATE TABLE Orderdetails(
orderdetail_id INT PRIMARY KEY IDENTITY,
order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
product_id INT REFERENCES Products(product_id),
quantity INT CHECK (quantity > 0)
);
```



-  order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE
      -  This establishes a foreign key relationship between Orderdetails table and Orders table.
      -  The ON DELETE CASCADE constraint ensures that if a row in the Orders table is deleted, all related rows in the Orderdetails table are automatically deleted.
-  product_id INT REFERENCES Products(product_id)
       -  his establishes a foreign key relationship between Orderdetails table and Products table.
- Constraints:
      -  PRIMARY KEY (orderdetail_id)- Ensures that orderdetail_id is unique and cannot be NULL.
      -  IDENTITY (Auto-increment) on orderdetail_id - Automatically generates a unique value for orderdetail_id whenever a new row is inserted.
      -  CHECK (quantity > 0) - Ensures that quantity must always be greater than zero, preventing invalid data like negative or zero quantities



# 4. Testing Strategy
## 4.1 Data Integrity Testing
-  Verified NOT NULL and CHECK constraints by attempting invalid data inserts.
-  Test CHECK Constraint - Try inserting an invalid LoyaltyStatus (should fail).

```
-- This should fail because 'Platinum' is not in the allowed list ('Regular', 'Silver', 'Gold').

INSERT INTO Customers (customer_name, phone_number, loyalty_status, Address)
VALUES ('John Doe', '+91-3788901284', 'Platinum', '332- set st');  
```

![image](https://github.com/user-attachments/assets/f1fb7f64-2da2-48f3-8ea5-f1c786456a26)


 -  Test NOT NULL Constraint: - Try inserting a row without productID and warehouseID (should fail).

```
-- This should fail because productid and warehouseid should not be null
INSERT INTO Inventories (product_id, warehouse_id, quantity_in_stock, product_category) VALUES
(null, null, 100, 'Electronics');
```

![image](https://github.com/user-attachments/assets/4460918c-b298-4b6a-a94d-6a6ccde40dcd)


# 4.2 Query Execution Testing
-  Executed SELECT queries to verify data retrieval.
-  Used JOIN queries to validate table relationships.

 ```
SELECT c.customer_name, o.order_id, p.product_name, o.status
FROM Orders AS o
JOIN Customers AS c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;
```

![image](https://github.com/user-attachments/assets/e36eb06c-983e-4b2b-8319-8a6e32402cc8)


# 4.3 Referential Integrity Testing
-  Indexed frequently queried columns to optimize search performance.
-  Executed queries with large datasets to measure response times.



# 5. Selecting Data
-  Demonstrates how queries retrieve specific columns and rows from a table by answering some of the Questions below;

**Retrieve the product IDs and names of all products in the inventory**
```
SELECT i.product_id, p.product_name
FROM Inventories AS i 
JOIN Products AS p ON p.product_id = i.product_id;
```

![image](https://github.com/user-attachments/assets/b66bf252-6a61-43e7-8ab8-26a91ff2df20)

**Get the order IDs and corresponding customer names for all completed orders**
```
SELECT o.order_id, c.customer_name 
FROM Orders AS o 
JOIN Customers AS c
ON o.customer_id = c.customer_id
WHERE status = 'Completed';
```
![image](https://github.com/user-attachments/assets/e2a8c692-c4e4-44fb-862d-3390c00d6bb2)


**Fetch the supplier names and contact information for suppliers supplying 'Electronics' products**
```
SELECT DISTINCT s.supplier_name, s.phone_number, s.email
FROM Suppliers AS s
JOIN Supplierproducts AS sp 
ON s.supplier_id = sp.supplier_id
JOIN Products AS p
ON sp.product_id = p.product_id
WHERE p.product_category = 'Electronics';
```

![image](https://github.com/user-attachments/assets/21b36cb3-71e4-4670-aaa5-beb51198637a)

**Retrieve the product IDs and quantities for products with stock levels below 50 units**
```
SELECT product_id, quantity_in_stock
FROM Inventories
WHERE quantity_in_stock < 50;
```
![image](https://github.com/user-attachments/assets/231c81ac-96ed-43a2-8928-6a020f859c2d)

**Get the shipment IDs and delivery dates for all received shipments**
```
SELECT shipment_id, delivery_date
FROM Shipments
WHERE status = 'Received';
```
![image](https://github.com/user-attachments/assets/c6b4576b-ee2e-4c09-8ca4-083a161efa98)


# 6. Filtering (Complex WHERE Clauses): 
  **Retrieve the order IDs and customer names for orders placed between January 1, 2024, and March 31, 2024, with a total order value exceeding $1000**
```
SELECT o.order_id, c.customer_name, (od.quantity * p.unit_price) AS Total_Value
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
JOIN Orderdetails AS od
ON od.product_id = o.product_id
JOIN Products AS p
ON od.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-01-31' AND (od.quantity * p.unit_price) > 1000;
```

![image](https://github.com/user-attachments/assets/3c304ccf-b243-44ca-aadd-3c235ab7e775)

**Get the product IDs and names for products with stock levels below 20 units and belonging to the 'Electronics' category**
```
SELECT i.product_id, p.product_name
FROM Inventories AS i
JOIN Products AS p 
ON i.product_id = p.product_id
WHERE quantity_in_stock < 20 AND p.product_category = 'Electronics';
```
![image](https://github.com/user-attachments/assets/235b50c7-d036-4bfc-aa5c-67f6fbcbf9b1)

**Fetch the supplier names and contact information for suppliers located in 'Asia' and supplying 'Clothing' products**
```
SELECT supplier_name, phone_number, email
FROM Suppliers AS s
JOIN Supplierproducts AS sp
ON s.supplier_id = sp.supplier_id
JOIN Products AS p
ON p.supplier_id = s.supplier_id
WHERE p.product_category = 'Clothing' AND s.region = 'Asia' ;
```

![image](https://github.com/user-attachments/assets/a62cff67-d2b0-487a-895d-635b1ac682a7)

**Retrieve the product IDs and quantities for products received in shipments with a weight exceeding 1000 kg**
```
SELECT pm.product_id, pm.quantity
FROM Productsmovement AS pm 
JOIN Shipments AS sh
ON pm.shipment_id = sh.shipment_id
WHERE weight > 1000 AND pm.movement_type = 'Shipped';
```
![image](https://github.com/user-attachments/assets/87a9ed03-34aa-4e5b-9204-b378f64ccf3b)

**Get the order IDs and customer names for orders with a total order value exceeding $500 placed by customers with a loyalty status of 'Gold'**
```
SELECT o.order_id, c.customer_name, (od.quantity * p.unit_price) AS Total_order_Value
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
JOIN Orderdetails AS od 
ON od.product_id = o.product_id
JOIN Products AS p
ON p.product_id = od.product_id
WHERE c.loyalty_status = 'Gold' AND (od.quantity * p.unit_price) > 500;
```
![image](https://github.com/user-attachments/assets/081b357c-ff33-4562-9d01-874950429eae)

# 7. Sorting:

**Retrieve the shipment IDs and delivery dates for all received shipments, sorted in ascending order of delivery dates**
```
SELECT shipment_id, delivery_date
FROM Shipments
WHERE status = 'Received'
ORDER BY delivery_date;
```
![image](https://github.com/user-attachments/assets/c14d6d07-14d9-46ee-8dbb-5ae6c1c2e9b1)

**Get the product IDs and names of all products in the inventory, sorted alphabetically by product names**
```
SELECT i.product_id, p.product_name  
FROM Inventories AS i
JOIN Products AS p
ON i.product_id = p.product_id
ORDER BY p.product_name ASC;
```

![image](https://github.com/user-attachments/assets/a5396453-67ac-4021-8680-60cb2f65608d)


**Fetch the supplier names and contact information for all suppliers, sorted alphabetically by supplier names**
```
SELECT supplier_name, phone_number, email 
FROM Suppliers
ORDER BY supplier_name ASC;
```

![image](https://github.com/user-attachments/assets/94429872-2045-4934-b5ed-8e9fe8d88dfc)

**Retrieve the order IDs and corresponding customer names for completed orders, sorted alphabetically by customer names**
```
SELECT o.order_id, c.customer_name
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
WHERE o.status = 'Completed'
ORDER BY c.customer_name ASC;
```
![image](https://github.com/user-attachments/assets/fdbec90c-8ea1-4ad0-9770-fdea858113ab)


**Get the product IDs and quantities for products with stock levels below 50 units, sorted in descending order of quantities**
```
SELECT product_id, quantity_in_stock AS quantities
FROM Inventories
WHERE quantity_in_stock < 50
ORDER BY quantities DESC;
```

![image](https://github.com/user-attachments/assets/2b333300-f1da-47f3-9d49-a0adef07920c)

# 8. Distinct:
**Retrieve distinct product categories available in the inventory**

```
SELECT DISTINCT product_category AS Product_Categories
FROM Inventories;
```

![image](https://github.com/user-attachments/assets/01514f9a-a6a1-4104-be12-80300053e77c)

**Get distinct order IDs for all placed orders**

```
SELECT DISTINCT order_id
FROM Orders;
```

![image](https://github.com/user-attachments/assets/0013357a-6981-4994-904d-771250634e38)

**Fetch distinct supplier names for all suppliers**

```
SELECT DISTINCT supplier_name AS Supllier_Names
FROM Suppliers;
```
![image](https://github.com/user-attachments/assets/bb9fa8bc-4800-4de9-82d3-918b49d97e1b)


**Retrieve distinct shipment IDs for all received shipments**

```
SELECT DISTINCT shipment_id
FROM Shipments
WHERE status = 'Received';
```
![image](https://github.com/user-attachments/assets/5d5fb01d-4ef2-4ad6-9785-8624d2b928f9)


**Get distinct customer names for customers who have placed orders**

```
SELECT DISTINCT c.customer_name, o.order_id
FROM Customers AS c
JOIN Orders AS o
ON c.customer_id = o.customer_id;
```

![image](https://github.com/user-attachments/assets/ebec0c6d-8b9a-42db-a656-f489ebd276eb)




# Conclusion
The database was designed following best practices in relational database management. The implementation ensured integrity through constraints and foreign keys. Testing confirmed proper
functionality, data integrity, and performance optimization.



































