
-- Selecting Data:
-- 1. Retrieve the product IDs and names of all products in the inventory.

SELECT i.product_id, p.product_name
FROM Inventories AS i 
JOIN Products AS p ON p.product_id = i.product_id;

-- 2. Get the order IDs and corresponding customer names for all completed orders.
SELECT o.order_id, c.customer_name 
FROM Orders AS o 
JOIN Customers AS c
ON o.customer_id = c.customer_id
WHERE status = 'Completed';

-- 3. Fetch the supplier names and contact information for suppliers supplying 'Electronics' products.
SELECT DISTINCT s.supplier_name, s.phone_number, s.email
FROM Suppliers AS s
JOIN Supplierproducts AS sp 
ON s.supplier_id = sp.supplier_id
JOIN Products AS p
ON sp.product_id = p.product_id
WHERE p.product_category = 'Electronics';

-- 4. Retrieve the product IDs and quantities for products with stock levels below 50 units.
SELECT product_id, quantity_in_stock
FROM Inventories
WHERE quantity_in_stock < 50;

--5. Get the shipment IDs and delivery dates for all received shipments.
SELECT shipment_id, delivery_date
FROM Shipments
WHERE status = 'Received';

/* Filtering (Complex WHERE Clauses): 
6. Retrieve the order IDs and customer names for orders placed between January 1, 2024, 
and March 31, 2024, with a total order value exceeding $1000.*/
SELECT o.order_id, c.customer_name, (od.quantity * p.unit_price) AS Total_Value
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
JOIN Orderdetails AS od
ON od.product_id = o.product_id
JOIN Products AS p
ON od.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-01-31' AND (od.quantity * p.unit_price) > 1000;

--7. Get the product IDs and names for products with stock levels below 20 units and belonging to the 'Electronics' category.
SELECT i.product_id, p.product_name
FROM Inventories AS i
JOIN Products AS p 
ON i.product_id = p.product_id
WHERE quantity_in_stock < 20 AND p.product_category = 'Electronics';

--8. Fetch the supplier names and contact information for suppliers located in 'Asia' and supplying 'Clothing' products.
SELECT supplier_name, phone_number, email
FROM Suppliers AS s
JOIN Supplierproducts AS sp
ON s.supplier_id = sp.supplier_id
JOIN Products AS p
ON p.supplier_id = s.supplier_id
WHERE p.product_category = 'Clothing' AND s.region = 'Asia' ;


--9. Retrieve the product IDs and quantities for products received in shipments with a weight exceeding 1000 kg.
SELECT pm.product_id, pm.quantity
FROM Productsmovement AS pm 
JOIN Shipments AS sh
ON pm.shipment_id = sh.shipment_id
WHERE weight > 1000 AND pm.movement_type = 'Shipped';

/*10. Get the order IDs and customer names for orders with a total order value exceeding $500 
placed by customers with a loyalty status of 'Gold'.*/
SELECT o.order_id, c.customer_name, (od.quantity * p.unit_price) AS Total_order_Value
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
JOIN Orderdetails AS od 
ON od.product_id = o.product_id
JOIN Products AS p
ON p.product_id = od.product_id
WHERE c.loyalty_status = 'Gold' AND (od.quantity * p.unit_price) > 500;


/* Sorting:
11. Retrieve the shipment IDs and delivery dates for all received shipments, sorted in ascending order of delivery dates.*/
SELECT shipment_id, delivery_date
FROM Shipments
WHERE status = 'Received'
ORDER BY delivery_date;

--12. Get the product IDs and names of all products in the inventory, sorted alphabetically by product names.
SELECT i.product_id, p.product_name  
FROM Inventories AS i
JOIN Products AS p
ON i.product_id = p.product_id
ORDER BY p.product_name ASC;

--13. Fetch the supplier names and contact information for all suppliers, sorted alphabetically by supplier names.
SELECT supplier_name, phone_number, email 
FROM Suppliers
ORDER BY supplier_name ASC;

--14. Retrieve the order IDs and corresponding customer names for completed orders, sorted alphabetically by customer names.
SELECT o.order_id, c.customer_name
FROM Orders AS o
JOIN Customers AS c
ON o.customer_id = c.customer_id
WHERE o.status = 'Completed'
ORDER BY c.customer_name ASC;

--15. Get the product IDs and quantities for products with stock levels below 50 units, sorted in descending order of quantities.
SELECT product_id, quantity_in_stock AS quantities
FROM Inventories
WHERE quantity_in_stock < 50
ORDER BY quantities DESC;


/* Distinct:
16. Retrieve distinct product categories available in the inventory.*/
SELECT DISTINCT product_category AS Product_Categories
FROM Inventories;

--17. Get distinct order IDs for all placed orders.
SELECT DISTINCT order_id
FROM Orders;

--18. Fetch distinct supplier names for all suppliers.
SELECT DISTINCT supplier_name AS Supllier_Names
FROM Suppliers;

--19. Retrieve distinct shipment IDs for all received shipments.
SELECT DISTINCT shipment_id
FROM Shipments
WHERE status = 'Received';

--20. Get distinct customer names for customers who have placed orders.
SELECT DISTINCT c.customer_name, o.order_id
FROM Customers AS c
JOIN Orders AS o
ON c.customer_id = o.customer_id;
