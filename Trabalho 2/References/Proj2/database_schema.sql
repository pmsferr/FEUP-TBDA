create or replace type WorkPeriod_t as object(
  initialInstant date,
  finalInstant date,
  dayOfTheWeek number,
  POS number
);

create or replace type Product_t as object(
  name_ varchar2(100),
  price number
);

create or replace type ProductsRef_tab_t as table of ref Product_t;

create or replace type Menu_t as object(
  products_table ProductsRef_tab_t,
  size_ integer,
  price number,
  name_ varchar2(100)
);


create or replace type OrderItem_t as object(
  product ref Product_t,
  menu ref Menu_t,
  quantity integer
);


create or replace type OrderItem_tab_t as table of OrderItem_t;

create or replace type WorkPeriod_tab_t as table of WorkPeriod_t;


create or replace type Employee_t as object(
  number_ integer,
  name VARCHAR2(150),
  admissionDate date,
  category varchar2(100),
  workTimetable WorkPeriod_tab_t
);


create or replace type Order_t as object(
  number_ integer,
  POS integer,
  employee ref Employee_t,
  orderItems OrderItem_tab_t,
  totalPrice number
);


create or replace type Ticket_t as object(
  number_ integer,
  init date,
  orderStart date,
  orderEnd date,
  order_ ref Order_t
);

------------------------------

create table Products of Product_t;

create table Menus of Menu_t
  nested table products_table store as Products_tab;


create table Employees of Employee_t
   nested table workTimetable store as workPeriods_tab;

create table Orders of Order_t
  nested table orderItems store as orderItems_tab;
  
create table Tickets of Ticket_t;
