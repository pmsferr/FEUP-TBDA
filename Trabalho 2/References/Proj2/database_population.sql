-- PRODUCTS
insert into Products(name_, price)
  values('Big Mac Sandwich', 3.00);
  
insert into Products(name_, price)
  values('Double Cheeseburger Sandwich', 2.00);
  
insert into Products(name_, price)
  values('Cheeseburger Sandwich', 1.25);
    
insert into Products(name_, price)
  values('Hamburger Sandwich', 1.00);
  
insert into Products(name_, price)
  values('4 Chicken Nuggets', 1.00);
  
insert into Products(name_, price)
  values('Batata Pequena', 1.00);

insert into Products(name_, price)
  values('Batata Media', 1.00);
  
insert into Products(name_, price)
  values('Batata Grande', 1.80);

insert into Products(name_, price)
  values('McChicken Sandwich', 2.00);
  
insert into Products(name_, price)
  values('Bebida Pequena', 1.10);
  
insert into Products(name_, price)
  values('Bebida Media', 1.40);
  
insert into Products(name_, price)
  values('Bebida Grande', 1.80);
  
insert into Products(name_, price)
  values('Sundae Chocolate', 1.60);
  
insert into Products(name_, price)
  values('Sundae Morango', 1.60);
  
insert into Products(name_, price)
  values('Filet-O-Fish', 2.00);
  
-- MENUS 
insert into Menus (products_table, size_, price, name_)
  values(
    ProductsRef_tab_t(
      (SELECT ref(p) FROM Products p WHERE name_ = 'Big Mac Sandwich'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Batata Media'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Bebida Media')
    ),
    2,
    5.00,
    'Menu BigMac Medio'
  );

insert into Menus (products_table, size_, price, name_)
  values(
    ProductsRef_tab_t(
      (SELECT ref(p) FROM Products p WHERE name_ = 'Big Mac Sandwich'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Batata Grande'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Bebida Grande')
    ),
    3,
    6.00,
    'Menu BigMac Grande'
  );
  
  
insert into Menus (products_table, size_, price, name_)
  values(
    ProductsRef_tab_t(
      (SELECT ref(p) FROM Products p WHERE name_ = 'McChicken Sandwich'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Batata Media'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Bebida Media')
    ),
    2,
    5.00,
    'Menu McChicken Medio'
  );

insert into Menus (products_table, size_, price, name_)
  values(
    ProductsRef_tab_t(
      (SELECT ref(p) FROM Products p WHERE name_ = 'McChicken Sandwich'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Batata Grande'),
      (SELECT ref(p) FROM Products p WHERE name_ = 'Bebida Grande')
    ),
    3,
    6.00,
    'Menu McChicken Grande'
  );
  
-- EMPLOYEES
insert into Employees (number_, name, admissionDate, category, workTimetable)
  values(
    1,
    'Marcio Tiago',
    to_date('29/10/2012 12:00 AM', 'dd/mm/yyyy hh:mi AM'),
    'POS seller',
    WorkPeriod_tab_t(
      WorkPeriod_t(to_date('01/01/2000 10:00 AM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'), 2, 3),
      WorkPeriod_t(to_date('01/01/2000 10:00 AM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'), 3, 3),
      WorkPeriod_t(to_date('01/01/2000 10:00 AM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'), 4, 2),
      WorkPeriod_t(to_date('01/01/2000 10:00 AM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'), 5, 3),
      WorkPeriod_t(to_date('01/01/2000 10:00 AM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'), 6, 3)
    )
  );
  
insert into Employees (number_, name, admissionDate, category, workTimetable)
  values(
    2,
    'Pedro Teiga',
    to_date('01/10/2010 12:00 AM', 'dd/mm/yyyy hh:mi AM'),
    'POS seller',
    WorkPeriod_tab_t(
      WorkPeriod_t(to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 06:00 PM', 'dd/mm/yyyy hh:mi AM'), 2, 3),
      WorkPeriod_t(to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 06:00 PM', 'dd/mm/yyyy hh:mi AM'), 3, 3),
      WorkPeriod_t(to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 06:00 PM', 'dd/mm/yyyy hh:mi AM'), 4, 2),
      WorkPeriod_t(to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 06:00 PM', 'dd/mm/yyyy hh:mi AM'), 5, 3),
      WorkPeriod_t(to_date('01/01/2000 02:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 06:00 PM', 'dd/mm/yyyy hh:mi AM'), 6, 3)
    )
  );
  
insert into Employees (number_, name, admissionDate, category, workTimetable)
  values(
    3,
    'Jorge Macedo',
    to_date('29/10/2012 12:00 AM', 'dd/mm/yyyy hh:mi AM'),
    'POS seller',
    WorkPeriod_tab_t(
      WorkPeriod_t(to_date('01/01/2000 12:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 04:00 PM', 'dd/mm/yyyy hh:mi AM'), 2, 4),
      WorkPeriod_t(to_date('01/01/2000 12:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 04:00 PM', 'dd/mm/yyyy hh:mi AM'), 3, 4),
      WorkPeriod_t(to_date('01/01/2000 12:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 04:00 PM', 'dd/mm/yyyy hh:mi AM'), 4, 4),
      WorkPeriod_t(to_date('01/01/2000 12:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 04:00 PM', 'dd/mm/yyyy hh:mi AM'), 5, 4),
      WorkPeriod_t(to_date('01/01/2000 12:00 PM', 'dd/mm/yyyy hh:mi AM'),to_date('01/01/2000 04:00 PM', 'dd/mm/yyyy hh:mi AM'), 6, 4)
    )
  );

-- ORDERS
insert into Orders (number_, POS, employee, orderItems, totalPrice)
  values(
    1,
    2,
    (select ref(e) from Employees e where number_ = 1),
    OrderItem_tab_t(
      OrderItem_t((SELECT ref(p) FROM Products p WHERE name_ = '4 Chicken Nuggets'), null, 1),
      OrderItem_t((SELECT ref(p) FROM Products p WHERE name_ = 'Bebida Media'), null, 1)      
    ),
    2.40
  );
  
  
insert into Orders (number_, POS, employee, orderItems, totalPrice)
  values(
    2,
    2,
    (select ref(e) from Employees e where number_ = 1),
    OrderItem_tab_t(
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Menu BigMac Medio'), 1)    
    ),
    5.00
  );
  
insert into Orders (number_, POS, employee, orderItems, totalPrice)
  values(
    3,
    2,
    (select ref(e) from Employees e where number_ = 2),
    OrderItem_tab_t(
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Menu BigMac Medio'), 1)    
    ),
    5.00
  );
  
  
insert into Orders (number_, POS, employee, orderItems, totalPrice)
  values(
    4,
    4,
    (select ref(e) from Employees e where number_ = 3),
    OrderItem_tab_t(
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Menu BigMac Medio'), 1),    
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Menu McChicken Medio'), 1),
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Hamburger Sandwich'), 1),
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Sundae Chocolate'), 2)
    ),
    14.20
  );
  
insert into Orders (number_, POS, employee, orderItems, totalPrice)
  values(
    5,
    3,
    (select ref(e) from Employees e where number_ = 2),
    OrderItem_tab_t(
      OrderItem_t(null, (SELECT ref(p) FROM Menus p WHERE name_ = 'Filet-O-Fish'), 1)
    ),
    2.00
  );

-- TICKETS
insert into Tickets (number_ , init, orderStart, orderEnd, order_)
  values(
    1,
    to_date('04/05/2016 11:03 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:05 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:07 AM', 'dd/mm/yyyy hh:mi AM'),
    (select ref(o) from Orders o where number_ = 1)
  );
  

insert into Tickets (number_ , init, orderStart, orderEnd, order_)
  values(
    2,
    to_date('04/05/2016 11:13 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:18 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:20 AM', 'dd/mm/yyyy hh:mi AM'),
    (select ref(o) from Orders o where number_ = 2)
  );
  
insert into Tickets (number_ , init, orderStart, orderEnd, order_)
  values(
    3,
    to_date('04/05/2016 11:13 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:16 AM', 'dd/mm/yyyy hh:mi AM'),
    to_date('04/05/2016 11:20 AM', 'dd/mm/yyyy hh:mi AM'),
    (select ref(o) from Orders o where number_ = 3)
  );
  
insert into Tickets (number_ , init, orderStart, orderEnd, order_)
  values(
    4,
    to_date('05/05/2016 01:11 PM', 'dd/mm/yyyy hh:mi AM'),
    to_date('05/05/2016 01:19 PM', 'dd/mm/yyyy hh:mi AM'),
    to_date('05/05/2016 01:22 PM', 'dd/mm/yyyy hh:mi AM'),
    (select ref(o) from Orders o where number_ = 4)
  );
  
insert into Tickets (number_ , init, orderStart, orderEnd, order_)
  values(
    5,
    to_date('05/05/2016 04:03 PM', 'dd/mm/yyyy hh:mi AM'),
    to_date('05/05/2016 04:06 PM', 'dd/mm/yyyy hh:mi AM'),
    to_date('05/05/2016 04:11 PM', 'dd/mm/yyyy hh:mi AM'),
    (select ref(o) from Orders o where number_ = 5)
  );