CREATE DATABASE NCR_Restaurant_db;
USE NCR_Restaurant_db;

CREATE TABLE Staff(
    staff_id    INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    position    TEXT NOT NULL,
    hire_date   DATE,
    salary      DECIMAL(10,2),
    contact     VARCHAR(15) UNIQUE
);

SELECT * FROM Staff;

INSERT INTO Staff VALUES
	(101, 'Raj Patel', 'Head Chef', '2022-01-15', 5200.00, '9876543210'),
	(102, 'Priya Sharma', 'Waiter', '2022-03-10', 2200.00, '8765432109'),
	(103, 'Amit Singh', 'Manager', '2021-11-05', 6500.00, '7654321098'),
	(104, 'Neha Gupta', 'Sous Chef', '2022-02-20', 4200.00, '6543210987'),
	(105, 'Vikram Joshi', 'Bartender', '2022-04-01', 2800.00, '5432109876');

CREATE TABLE Menu_items(
    item_id    INT PRIMARY KEY,
    name       TEXT NOT NULL,
    category   VARCHAR(50),
    price      DECIMAL(10,2) NOT NULL,
    prep_time  INT,
    is_veg     BOOLEAN
);

SELECT * FROM Menu_items;

INSERT INTO Menu_items VALUES
	(201, 'Butter Chicken', 'Main Course', 325.00, 25, FALSE),
	(202, 'Paneer Tikka', 'Appetizer', 195.00, 15, TRUE),
	(203, 'Dal Makhani', 'Main Course', 185.00, 20, TRUE),
	(204, 'Chicken Biryani', 'Main Course', 275.00, 30, FALSE),
	(205, 'Gulab Jamun', 'Dessert', 95.00, 10, TRUE),
	(206, 'Mango Lassi', 'Beverage', 75.00, 5, TRUE),
	(207, 'Tandoori Roti', 'Bread', 25.00, 7, TRUE),
	(208, 'Chicken Tikka', 'Appetizer', 225.00, 18, FALSE),
	(209, 'Veg Thali', 'Combo', 350.00, 15, TRUE),
	(210, 'Non-Veg Thali', 'Combo', 450.00, 20, FALSE);

CREATE TABLE Customers(
    customer_id  INT PRIMARY KEY,
    name         VARCHAR(50) NOT NULL,
    phone        VARCHAR(15) UNIQUE,
    email        TEXT,
    visits       INT
);

SELECT * FROM Customers;

INSERT INTO Customers VALUES
	(301, 'Arun Kumar', '9123456780', 'arun@email.com', 3),
	(302, 'Meera Desai', '8234567891', 'meera@email.com', 5),
	(303, 'Rohan Iyer', '7345678902', NULL, 2),
	(304, 'Ananya Reddy', '6456789013', 'ananya@email.com', 1),
	(305, 'Kiran Nair', '5567890124', 'kiran@email.com', 4);
	
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

INSERT INTO Orders VALUES
	(401, 301, 102, '2023-06-15 19:30:00', 850.00, 'Completed'),
	(402, 302, 102, '2023-06-15 20:15:00', 650.00, 'Completed'),
	(403, 303, 105, '2023-06-16 12:45:00', 1200.00, 'In Progress'),
	(404, 304, 102, '2023-06-16 13:30:00', 525.00, 'Completed'),
	(405, 305, 105, '2023-06-16 21:00:00', 975.00, 'Completed'),
	(406, 301, 102, '2023-06-17 20:30:00', 730.00, 'Completed'),
	(407, 302, 105, '2023-06-18 13:15:00', 420.00, 'Cancelled'),
	(408, 303, 102, '2023-06-18 19:45:00', 880.00, 'In Progress'),
	(409, 304, 105, '2023-06-19 12:30:00', 650.00, 'Completed'),
	(410, 305, 102, '2023-06-19 20:15:00', 920.00, 'Completed');

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

INSERT INTO Order_items VALUES
	(501, 401, 201, 2, 'Less spicy'),
	(502, 401, 207, 4, NULL),
	(503, 401, 206, 2, 'Less sugar'),
	(504, 402, 202, 1, NULL),
	(505, 402, 203, 1, NULL),
	(506, 402, 207, 2, NULL),
	(507, 403, 204, 3, 'Extra raita'),
	(508, 403, 208, 2, 'Well done'),
	(509, 403, 210, 1, NULL),
	(510, 404, 209, 1, 'No onion no garlic'),
	(511, 404, 206, 1, NULL),
	(512, 405, 201, 1, NULL),
	(513, 405, 202, 2, NULL),
	(514, 405, 205, 2, 'Hot serving'),
	(515, 406, 203, 1, NULL),
	(516, 406, 207, 3, NULL),
	(517, 407, 206, 4, NULL),
	(518, 408, 204, 2, NULL),
	(519, 408, 205, 1, NULL),
	(520, 409, 202, 1, NULL),
	(521, 410, 201, 1, 'Extra gravy');

SELECT * FROM Menu_items
ORDER BY price DESC;

SELECT * FROM Staff;

SELECT *,HOUR(order_time) AS Hour FROM Orders
WHERE HOUR(order_time)>=18;

SELECT * FROM Menu_items 
WHERE category='Main Course' AND is_veg=TRUE;

SELECT * FROM Menu_items
WHERE category='Appetizer' 
AND prep_time <20;

SELECT category,ROUND(AVG(price),2) AS Average_Price FROM Menu_items
GROUP BY category
ORDER BY category;

SELECT * FROM Customers
WHERE email IS NULL;

SELECT * FROM Customers
WHERE visits>3;

SELECT c.*, SUM(o.total_amount) AS Total_amount
FROM Customers c 
LEFT JOIN Orders o 
ON o.customer_id=c.customer_id
GROUP BY c.customer_id;
 
SELECT * FROM Orders
WHERE status IN ('Cancelled','In Progress');

SELECT * FROM Orders 
WHERE total_amount>1000.0;

SELECT m.*, SUM(oi.quantity) AS Total_orders
FROM Menu_items m 
LEFT JOIN Order_items oi 
ON m.item_id=oi.item_id
GROUP BY m.item_id
ORDER BY Total_orders DESC 
LIMIT 2;

SELECT s.* ,SUM(o.total_amount) AS Total_orders
FROM Staff s 
LEFT JOIN Orders o 
ON s.staff_id=o.staff_id
GROUP BY s.staff_id;

SELECT s.* ,COUNT(o.order_id) AS Total_orders
FROM Staff s 
LEFT JOIN Orders o 
ON s.staff_id=o.staff_id
GROUP BY s.staff_id
HAVING Total_orders=0;

SELECT HOUR(order_time) Hour, COUNT(*) AS Total_Orders FROM Orders
GROUP BY Hour 
ORDER BY Total_Orders DESC
LIMIT 1;

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

SELECT m.*, COUNT(o.order_id) AS Total_orders
FROM Menu_items m 
LEFT JOIN Order_items oi 
ON m.item_id=oi.item_id
LEFT JOIN Orders o 
ON o.order_id=oi.order_id
GROUP BY m.item_id
HAVING Total_orders=0;

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

SELECT o.* , oi.special_notes
FROM Orders o 
JOIN Order_items oi 
ON oi.order_id=o.order_id
WHERE oi.special_notes IS NOT NULL;

SELECT special_notes, COUNT(*) AS Total_Requests FROM Order_items
WHERE special_notes IS NOT NULL
GROUP BY special_notes
ORDER BY Total_Requests DESC 
LIMIT 2;