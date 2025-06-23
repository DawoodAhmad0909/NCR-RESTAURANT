# NCR RESTAURANT DEHLI
## Overview
The NCR_Restaurant_db project is a relational database designed to manage and analyze key operations of a restaurant, including staff management, customer information, menu items, orders, and order details. It leverages SQL to efficiently store, retrieve, and analyze data, enabling the restaurant to make informed business decisions, optimize service, and enhance customer satisfaction.
## Objectives
#### 1. Design a normalized and scalable restaurant database.
#### 2. Insert realistic sample data for staff, menu items, customers, and orders.
#### 3. Retrieve insights using SQL queries to support operations and decision-making.
#### 4. Track order history, special dietary requests, and time-based ordering patterns.
#### 5. Analyze sales performance, customer behavior, and menu item popularity.
#### 6. Identify operational gaps, such as staff with no activity or unused menu items.
#### 7. Calculate key performance metrics, including busiest hours and average order value.

## Database Creation
``` sql
CREATE DATABASE NCR_Restaurant_db;
USE NCR_Restaurant_db;
```
## Table Creation
### Table:Staff
``` sql
CREATE TABLE Staff(
    staff_id    INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    position    TEXT NOT NULL,
    hire_date   DATE,
    salary      DECIMAL(10,2),
    contact     VARCHAR(15) UNIQUE
);

SELECT * FROM Staff;
```
### Table:Menu_items
``` sql
CREATE TABLE Menu_items(
    item_id    INT PRIMARY KEY,
    name       TEXT NOT NULL,
    category   VARCHAR(50),
    price      DECIMAL(10,2) NOT NULL,
    prep_time  INT,
    is_veg     BOOLEAN
);

SELECT * FROM Menu_items;
```
### Table:Customers
``` sql
CREATE TABLE Customers(
    customer_id  INT PRIMARY KEY,
    name         VARCHAR(50) NOT NULL,
    phone        VARCHAR(15) UNIQUE,
    email        TEXT,
    visits       INT
);

SELECT * FROM Customers;
```
### Table:Orders
``` sql
CREATE TABLE Orders(
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    staff_id      INT,
    order_time    DATETIME,
    total_amount  DECIMAL(20,2),
    status        VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

SELECT * FROM Orders;
```
### Table:Order_items
``` sql
CREATE TABLE Order_items(
    order_item_id  INT PRIMARY KEY,
    order_id       INT,
    item_id        INT,
    quantity       INT,
    special_notes  TEXT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Menu_items(item_id)
);

SELECT * FROM Order_items;
```
## Key Queries 
#### 1. List all menu items with their prices, sorted by most expensive first.
``` sql
SELECT * FROM Menu_items
ORDER BY price DESC;
```
#### 2. Show all staff members with their positions and hire dates.
``` sql
SELECT * FROM Staff;
```
#### 3. Display all orders placed during dinner hours (after 6 PM).
``` sql
SELECT *,HOUR(order_time) AS Hour FROM Orders
WHERE HOUR(order_time)>=18;
```
#### 4. Find all vegetarian main course items.
``` sql
SELECT * FROM Menu_items 
WHERE category='Main Course' AND is_veg=TRUE;
```
#### 5. List appetizers that take less than 20 minutes to prepare.
``` sql
SELECT * FROM Menu_items
WHERE category='Appetizer' 
AND prep_time <20;
```
#### 6. Show the average price of items in each category.
``` sql
SELECT category,ROUND(AVG(price),2) AS Average_Price FROM Menu_items
GROUP BY category
ORDER BY category;
```
#### 7. Identify customers who haven't provided an email address.
``` sql
SELECT * FROM Customers
WHERE email IS NULL;
```
#### 8. Find customers who have visited more than 3 times.
``` sql
SELECT * FROM Customers
WHERE visits>3;
```
#### 9. Show the total amount spent by each customer.
``` sql
SELECT c.*, SUM(o.total_amount) AS Total_amount
FROM Customers c 
LEFT JOIN Orders o 
ON o.customer_id=c.customer_id
GROUP BY c.customer_id;
```
#### 10. Display all incomplete orders (status = 'In Progress' or 'Cancelled').
``` sql
SELECT * FROM Orders
WHERE status IN ('Cancelled','In Progress');
```
#### 11. Find orders with a total amount exceeding ₹1000.
``` sql
SELECT * FROM Orders 
WHERE total_amount>1000.0;
```
#### 12. Show the most frequently ordered menu item (by quantity).
``` sql
SELECT m.*, SUM(oi.quantity) AS Total_orders
FROM Menu_items m 
LEFT JOIN Order_items oi 
ON m.item_id=oi.item_id
GROUP BY m.item_id
ORDER BY Total_orders DESC 
LIMIT 2;
```
#### 13. Calculate total sales handled by each staff member.
``` sql
SELECT s.* ,SUM(o.total_amount) AS Total_orders
FROM Staff s 
LEFT JOIN Orders o 
ON s.staff_id=o.staff_id
GROUP BY s.staff_id;
```
#### 14. Find staff members who haven't processed any orders.
``` sql
SELECT s.* ,COUNT(o.order_id) AS Total_orders
FROM Staff s 
LEFT JOIN Orders o 
ON s.staff_id=o.staff_id
GROUP BY s.staff_id
HAVING Total_orders=0;
```
#### 15. Show the busiest order time (hour with most orders).
``` sql
SELECT HOUR(order_time) Hour, COUNT(*) AS Total_Orders FROM Orders
GROUP BY Hour 
ORDER BY Total_Orders DESC
LIMIT 1;
````
#### 16. Calculate the percentage of vegetarian vs non-vegetarian orders.
``` sql
SELECT 
        CASE 
                WHEN m.is_veg=TRUE THEN 'Vegetarion'
        WHEN m.is_veg=FALSE THEN 'Non Vegetarion'
        END AS Type,
    COUNT(oi.order_item_id) AS Total_items, 
    ROUND(COUNT(oi.order_item_id)*100.0/(SELECT COUNT(*) FROM Order_items),2) AS Percentage
FROM Menu_items m 
JOIN Order_items oi 
ON m.item_id=oi.item_id
GROUP BY Type;
```
#### 17. Identify menu items that have never been ordered.
``| sql
SELECT m.*, COUNT(o.order_id) AS Total_orders
FROM Menu_items m 
LEFT JOIN Order_items oi 
ON m.item_id=oi.item_id
LEFT JOIN Orders o 
ON o.order_id=oi.order_id
GROUP BY m.item_id
HAVING Total_orders=0;
```
#### 18. Show the average order value by time of day (lunch vs dinner).
``` sql
SELECT
        CASE 
                WHEN HOUR(order_time) IN(4,5,6) THEN 'Early Breakfast'
                WHEN HOUR(order_time) IN(7,8,9,10) THEN 'Breakfast'
        WHEN HOUR(order_time) IN (11) THEN 'Brunch'
        WHEN HOUR(order_time) IN(12,13,14,15) THEN 'Lunch'
        WHEN HOUR(order_time) IN(16,17) THEN 'Hi_Tea'
        WHEN HOUR(order_time) IN(18,19,20,21,22,23) THEN 'Dinner'
        WHEN HOUR(order_time) IN(24,1,2,3) THEN'Late Dinner'
        END AS Time_of_Day,
    ROUND(AVG(total_amount),2) AS Average_Amount
FROM Orders
GROUP BY Time_of_Day;
```
#### 19. List all orders with special dietary requests (where special_notes is not NULL).
``| sql
SELECT o.* , oi.special_notes
FROM Orders o 
JOIN Order_items oi 
ON oi.order_id=o.order_id
WHERE oi.special_notes IS NOT NULL;
```
#### 20. Find the most common special request note.
``` sql
SELECT special_notes, COUNT(*) AS Total_Requests FROM Order_items
WHERE special_notes IS NOT NULL
GROUP BY special_notes
ORDER BY Total_Requests DESC 
LIMIT 2;
```
## Conclusion
The NCR_Restaurant_db successfully demonstrates the practical use of SQL in managing a restaurant’s backend data operations. With a clean schema and well-structured queries, the database provides valuable insights into customer habits, sales trends, and staff productivity. From identifying top-selling dishes and peak business hours to tracking customer loyalty and dietary preferences, this database can help restaurant managers make informed decisions to improve service quality and profitability.

