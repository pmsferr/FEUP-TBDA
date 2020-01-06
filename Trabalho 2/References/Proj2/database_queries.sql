-----------------------------------
--- QUERIES -----------------------
-----------------------------------

-- c) Get the daily total amount and number of sales for each employee, as well as the average transaction time.

select t.order_.employee.name as employee, 24*60*avg(t.orderEnd - t.orderStart) as avgTransactionTime_min, 
  sum(t.order_.totalPrice) as totalAmount, TRUNC(t.init) as day, count(*) as numberOfSales
from Tickets t
group by t.order_.employee.name, TRUNC(t.init)
order by day desc;


-- d) Show the menu.

  -- show all menus, with a line for each product a menu includes
select name_ as menu_name, price, size_, value(p).name_ as menu_products
from Menus m, table(m.products_table) p;

  -- show all menus and products, and its prices
select * 
from 
  (
      (select name_ ItemName, price from Menus m)
      UNION ALL
      (select name_ ItemName, price from Products p)
  );


-- e) Compute the weekly total number of work hours for the employees with the category of POS seller.
select e.name, sum(24*(w.finalInstant - w.initialInstant)) as totalHours
from Employees e, table(e.workTimetable) w
where e.category='POS seller'
group by e.name;
