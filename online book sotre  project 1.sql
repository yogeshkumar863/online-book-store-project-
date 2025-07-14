create database Online_Bookstore ;
use online_bookstore ;

 # create_table_books 
 
 create table BOOKS(
Book_ID serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int 
);

 # create_table_customers
 
 create table  CUSTOMERS(
Customer_ID serial primary key,
Name varchar (100),
Email varchar (100),
Phone varchar (15),
City varchar (50),
Country varchar (150)
 ) ;
 
 # create_table_ orders
 
  create table ORDERS(
Order_ID serial primary key,
Customer_ID int references CUSTOMERS(Customer_ID),
Book_ID int references Book_ID (Book_ID),
Order_Date date,
Quantity int,
Total_Amount numeric(10,2)
);

# insert data in tables by import data

# 1. retrive all books in the "fiction " genre
select * from books
where Genre='fiction';

#2. find books published after the year 1950
select * from BOOKS 
where published_year>1950;

#3. list all the customers from the canada.
select * from customers
where Country= 'canada';

#4. show orders placed in november 2023.
SELECT * FROM orders
WHERE DATE(Order_Date) BETWEEN '2023-11-01' AND '2023-11-30';

#5.retieve the total stock of books avaiable.
select sum(stock) as total_stock
from books;

#6. find the most expensive book.
select* from books
order by price desc limit 1 ;

#7.show all customers who ordered more than 1 qty of a book.
select* from orders
where Quantity>1;

#8.retrieve all orders where the total amount exceed $20.
select*from orders
where Total_Amount>20;

#9.list all genres available in the books table.
select  distinct genre from books;

#10. find the book lowest stock.
select*from books
order by stock asc limit 5;

#11. calculate the total revenue from all orders.
select sum(Total_Amount) from orders as revenue;

##12.retrieve the total number of books sold for each genre. 
select b. genre,sum(o. quantity) as total_books_sold
from orders o
join books b on o.Book_ID= b.Book_ID
group by b.Genre 
order by total_books_sold ;

#13.find the average price of books in the "fantasy" genre. 
select avg(price) as average_price
from books
where Genre='fantasy';

#14 list customers who have  placed at least 2 orders.
select o.customer_id,c.name,count(o.order_id) as order_count
from orders o
join customers c on c.Customer_ID=o.Customer_ID
group by Customer_ID ,c.Name
having count(Order_ID)>=2;

#15 find the modst frequently order book.
select o.book_id,b.title ,count(o.order_id) as order_count
from orders o
join books b on o.Book_ID= b.Book_ID
group by o.Book_ID, b.Book_ID 
order by order_count desc limit 1;

#16. shoe the top 3 most expensive books of fantasy.
select*from books
where genre='FANTASY'
order by Price desc limit 3;

#17 retrieve the total  qty of bookd sold  by each author.
select b.author,sum(o.Quantity) as total_sold
from orders o
join books b on o.book_id =b.Book_ID
group by b. Author;

#18 list the cities where customers who spend over $30 are located.
select  distinct c. city, Total_Amount
from orders o
join customers c on o.customer_id= c.customer_id
where Total_Amount>30;

#19 find the customer who spent the most on orders.
select c.customer_id,c.name,sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c. customer_id, c.name 
order by total_spent desc limit 1 ;

#20 calculate the stock remaining after fulfilling orders.
select b.book_id,b.title,b.Stock,coalesce(sum(o.quantity),0) as order_quantity,b.Stock - coalesce(sum(o.quantity),0) as remaining_qty
from books b
left join  orders o on b.Book_ID= o.Book_ID
group by b.Book_ID;