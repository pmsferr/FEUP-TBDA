----------------------------------
---Copying Relational Tables------
----------------------------------
Drop Table Regions_Rel;
Create Table Regions_Rel as
Select * From GTD10.Regions;

Drop Table Countries_Rel;
Create Table Countries_Rel as
Select * From GTD10.Countries;

Drop Table Locations_Rel;
Create Table Locations_Rel as
Select * From GTD10.Locations;

Drop Table Jobs_Rel;
Create Table Jobs_Rel as
Select * From GTD10.Jobs;

Drop Table Employees_Rel;
Create Table Employees_Rel as
Select * From GTD10.Employees;

Drop Table Departments_Rel;
Create Table Departments_Rel as
Select * From GTD10.Departments;

Drop Table Job_History_Rel;
Create Table Job_History_Rel as
Select * From GTD10.Job_History;


------------------------------
------ Type Declaration ------
------------------------------

--Region_t
create or replace type Region_t as object 
   ( 
     region_id NUMBER,
	 region_name VARCHAR2(25 BYTE)
	 );
	 

--Country_t
create or replace type Country_t as object 
   ( 
     country_id CHAR(2 BYTE),
	 country_name VARCHAR2(40 BYTE),
	 REGION ref REGION_T
	 );
	 
	 
--CountriesRef_tab_t 
create or replace type CountriesRef_tab_t as table of ref Country_t; 
	 
	 
--Location_t
create or replace type Location_t as object 
   ( 
     location_id NUMBER(4,0),
	 street_address VARCHAR2(40 BYTE),
	 postal_code VARCHAR2(12 BYTE),
	 city VARCHAR2(30 BYTE),
	 state_province VARCHAR2(25 BYTE),
	 COUNTRY ref COUNTRY_T 	 
	 );
	 
--LocationsRef_tab_t 
create or replace type LocationsRef_tab_t as table of ref Location_t; 


--Job_t
create or replace type Job_t as object 
   ( 
     job_id VARCHAR2(10 BYTE),
	 job_title VARCHAR2(35 BYTE),
	 min_salary NUMBER(6,0),
     max_salary NUMBER(6,0)
	 
	 );

create or replace type Employee_t as object 
   ( 
     employee_id NUMBER(4,0),
	 first_name VARCHAR2(20 BYTE),
	 last_name VARCHAR2(20 BYTE),
	 email VARCHAR2(25 BYTE),
	 phone_number VARCHAR2(20 BYTE),
	 hire_date DATE,
	 JOB ref JOB_T,
	 salary NUMBER(8,2),
	 commission_pct NUMBER(2,2),
	 manager ref EMPLOYEE_T,
     DEPARTMENT ref DEPARTMENT_T
	 
	 );

	 
--EmployeesRef_tab_t 
create or replace type EmployeesRef_tab_t as table of ref Employee_t; 

--Department_t
create or replace type Department_t as object 
   ( 
     department_id NUMBER(4,0),
	 department_name VARCHAR2(30 BYTE),
	 manager ref  EMPLOYEE_T,
	 location ref LOCATION_T
	 
	 ); 
	 
	 
--DeparmentsRef_tab_t 
create or replace type DepartmentsRef_tab_t as table of ref Department_t; 

	 
--Job_History_t
create or replace type Job_History_t as object 
   ( 
     
	 EMPLOYEE ref EMPLOYEE_T,
	 start_date DATE,
     end_date DATE,
	 job ref JOB_T,
	 DEPARTMENT ref DEPARTMENT_T 
	 
	 ); 
	 

--Job_HistoryRef_tab_t 
create or replace type Job_HistoryRef_tab_t  as table of ref Job_History_t;



	  
-- Region Countries
alter type Region_t
add attribute (COUNTRIES CountriesRef_tab_t) CASCADE;

-- Country Locations
alter type Country_t
add attribute (LOCATIONS LocationsRef_tab_t) CASCADE;

-- Location Departments
alter type Location_t
add attribute (DEPARTMENTS DepartmentsRef_tab_t) CASCADE;

-- Department Employees
alter type Department_t
add attribute (EMPLOYEES EmployeesRef_tab_t) CASCADE;

-- Department Job_History
alter type Department_t
add attribute (Job_History Job_HistoryRef_tab_t) CASCADE;

-- Employee Job_History
alter type Employee_t
add attribute (Job_History Job_HistoryRef_tab_t) CASCADE;

-- Employee Employees
alter type Employee_t
add attribute (EMPLOYEES EmployeesRef_tab_t) CASCADE;

-- Employee Departments
alter type Employee_t
add attribute (DEPARTMENTS DepartmentsRef_tab_t) CASCADE;

-- Job Employees
alter type Job_t
add attribute (EMPLOYEES EmployeesRef_tab_t) CASCADE;

-- Job Job_History
alter type Job_t
add attribute (Job_History Job_HistoryRef_tab_t) CASCADE;


----------------------------
------ Table Creation ------
----------------------------


-- Regions
create table Regions of Region_t
	nested table Countries store as Region_Countries;

-- Countries
create table Countries of Country_t
	nested table Locations store as Country_Locations;
	
-- Locations
create table Locations of Location_t
	nested table Departments store as Location_Departments;
	
-- Departments
create table Departments of Department_t
	nested table Employees store as Department_Employees,
	nested table Job_History store as Department_Job_History;
	
-- Employees
create table Employees of Employee_t
	nested table Job_History store as Employee_Job_History,
	nested table Employees store as Employee_Employees,
	nested table Departments store as Employee_Departments;
	
-- Jobs
create table Jobs of Job_t
	nested table Employees store as Job_Employees,
	nested table Job_History store as Job_Job_History;
	
-- Job_History
create table Job_History of Job_History_t;


-----------------------------
------ Data Migration -------
-----------------------------

-- Regions
delete from Regions;
insert into Regions (REGION_ID,REGION_NAME)
select r.REGION_ID, r.REGION_NAME
from Regions_Rel r;

-- Jobs
delete from Jobs;
insert into Jobs (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY)
select j.JOB_ID, j.JOB_TITLE, j.MIN_SALARY, j.MAX_SALARY
from Jobs_Rel j;

-- Countries

delete from Countries;
insert into Countries (COUNTRY_ID,COUNTRY_NAME,REGION)
select c.COUNTRY_ID, c.COUNTRY_NAME, null
from Countries_Rel c;

-- Locations
delete from Locations;
insert into Locations (LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY,STATE_PROVINCE,COUNTRY)
select l.LOCATION_ID, l.STREET_ADDRESS, l.POSTAL_CODE, l.CITY, l.STATE_PROVINCE, null
from Locations_Rel l;


-- Departments

delete from Departments;
insert into Departments (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER,LOCATION)
select d.DEPARTMENT_ID, d.DEPARTMENT_NAME, null, null 
from Departments_Rel d;


-- Employees
delete from Employees;
insert into Employees (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB,SALARY,COMMISSION_PCT,MANAGER ,DEPARTMENT)
select e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.EMAIL, e.PHONE_NUMBER, e.HIRE_DATE, null, e.SALARY, e.COMMISSION_PCT, null, null
from Employees_Rel e;


Update Countries c
Set c.Region = (SELECT ref(r) FROM Regions r WHERE r.Region_id = (Select Region_id from Countries_Rel WHERE countries_rel.country_id = c.country_id));

Update Locations l
Set l.Country = (SELECT ref(c) From Countries c WHERE c.Country_ID = (SELECT Country_id from Locations_Rel WHERE Locations_rel.Location_id = l.location_id));

Update Departments d
Set d.Manager = (Select ref(e) From Employees e WHERE e.employee_ID = (SELECT manager_id from Departments_Rel WHERE Departments_rel.Department_id = d.department_id)),
d.location = (Select ref(l) From Locations l Where l.location_ID = (Select location_id From Departments_Rel Where Departments_rel.Department_id = d.department_id));

Update Employees e
Set e.Job = (Select ref(j) From Jobs j Where j.Job_ID = (Select job_id from Employees_Rel Where Employees_Rel.Employee_id = e.Employee_id)),
e.Manager = (Select ref(e2) From Employees e2 Where e2.Employee_Id = (Select manager_id from Employees_Rel Where Employees_Rel.Employee_id = e.Employee_id)),
e.Department = (Select ref(d) From Departments d Where d.department_id = (Select department_id from Employees_Rel Where Employees_Rel.Employee_id = e.Employee_id));

-- Job_History
delete from Job_History;
insert into Job_History (EMPLOYEE,START_DATE,END_DATE,JOB,DEPARTMENT)
select (select ref(e) From Employees e Where e.employee_id = jh.employee_id), jh.START_DATE, jh.END_DATE, (select ref(j) From Jobs j where j.job_id = jh.job_id), (select ref(d) From Departments d where d.department_id=jh.department_id)
from Job_History_Rel jh;


-------------------------------
------ Nested Migration ------
-------------------------------


--Jobs Job_History
update Jobs j
set j.Job_History = 
cast(multiset(select ref(jh) from Job_History jh where j.job_id = jh.job.job_id) as Job_HistoryRef_tab_t);

--Jobs Employees
update Jobs j
set j.Employees = 
cast(multiset(select ref(e) from Employees e where j.job_id = e.job.job_id) as EmployeesRef_tab_t);

--Employees Job_History
update Employees e
set e.Job_History = 
cast(multiset(select ref(jh) from Job_History jh where e.employee_id = jh.employee.employee_id) as Job_HistoryRef_tab_t);

--Employees Employees
update Employees e
set e.Employees = 
cast(multiset(select ref(e2) from Employees e2 where e.employee_id = e2.manager.employee_id) as EmployeesRef_tab_t);

--Employees Departments
update Employees e
set e.Departments = 
cast(multiset(select ref(d) from Departments d where e.employee_id = d.manager.employee_id) as DepartmentsRef_tab_t);

--Departments Job_History
update Departments d
set d.Job_History = 
cast(multiset(select ref(jh) from Job_History jh where d.department_id = jh.department.department_id) as Job_HistoryRef_tab_t);

--Departments Employees
update Departments d
set d.Employees = 
cast(multiset(select ref(e) from Employees e where d.department_id = e.department.department_id) as EmployeesRef_tab_t);

--Locations Departments
update Locations l
set l.Departments = 
cast(multiset(select ref(d) from Departments d where l.location_id = d.location.location_id) as DepartmentsRef_tab_t);

--Countries Locations
update Countries c
set c.Locations =   
cast(multiset(select ref(l) from Locations l where c.country_id = l.country.country_id) as LocationsRef_tab_t);

--Regions Countries
update Regions r
set r.Countries = 
cast(multiset(select ref(c) from Countries c where r.region_id = c.region.region_id) as CountriesRef_tab_t);


-----------------------------------

------ Function Declaration  ------

-----------------------------------

alter type Employee_t
add member function GetMaxSalary(d REF Department_t) return float cascade;

alter type Employee_t
add member function GetNEmployees(d REF Department_t) return integer cascade;

alter type Employee_t
add member function GetNEmployees(d REF Department_t, j REF Job_t) return integer cascade;

alter type Country_t
add member function GetAvgSalary(l REF Location_t) return float cascade;

alter type Country_t
add member function GetAvgSalary(c REF Country_t) return float cascade;


----------------------------------

------ Function Definition  ------

----------------------------------

create or replace type body Employee_t as
    member function GetMaxSalary(d REF Department_t) return float is
        max_salary float;
    begin
        Select max(e.salary) into max_salary from Employees e where e.department = d;
        return max_salary;
    end GetMaxSalary;

    member function GetNEmployees(d REF Department_t) return integer is
        n_employees integer;
    begin
        select count(*) into n_employees from Employees e where e.department = d;
        return n_employees;
    end GetNEmployees;

    member function GetNEmployees(d REF Department_t, j REF Job_t) return integer is
        n_employees integer;
    begin
        select count(*) into n_employees from Employees e where e.department = d and e.job = j;
        return n_employees;
    end GetNEmployees;
end;

create or replace type body Country_t as
    
    member function GetAvgSalary(c REF Country_t) return float is
        average float;
    begin
        select round(nvl(avg(value(e).salary),0)*100)/100 into average from Countries c2, table(c2.locations) l, table(value(l).departments) d, table(value(d).employees) e
        where c = ref(c2);
        return average;
    end GetAvgSalary;

    member function GetAvgSalary(l REF Location_t) return float is
        average float;
    begin
        select round(nvl(avg(value(e).salary),0)*100)/100 into average from Locations l2, table(l2.departments) d, table(value(d).employees) e
        where ref(l2) = l;
        return average;
    end GetAvgSalary;
end;

---------------------

------ Queries ------

---------------------


--Query 1
select e.department.department_name as Department_Name , count(*) as N_Employees from Employees e group by e.department;

       --OR

select distinct e.department.department_name as Department_Name , e.GetNEmployees(e.department) as N_Employees from Employees e;

--Query 2
select e.department.department_name as Department_Name, e.job.job_title as Job_Title, count (*) as N_Employees from Employees e group by e.department, e.job;

        --OR

select distinct e.department.department_name as Department_Name, e.job.job_title as Job_Title, e.GetNEmployees(e.department, e.job) as N_Employees from Employees e;

---Query 3
select e.employee_id as Employee_ID, e.first_name as First_Name, e.last_name as Last_Name, e.department.department_name as Department, e.salary as Salary
From Employees e
where e.salary = (Select max(e2.salary) from Employees e2 where e2.department = e.department);

        --OR

select e.employee_id as Employee_ID, e.first_name as First_Name, e.last_name as Last_Name, e.department.department_name as Department, e.salary as Salary
From Employees e
where e.salary = e.GetMaxSalary(e.department);


--Query 4

Select e.employee_id, e.first_name, e.last_name, e.hire_date from Employees e, table(e.Job_History) jh where
   (Select min(jh2.start_date) from Job_History jh2 where jh2.start_date > value(jh).end_date and jh2.employee = value(jh).employee) - value(jh).end_date = 1 or
   e.hire_date - value(jh).end_date = 1
order by e.hire_date;

--Query 5

select c.Country_Name, c.GetAvgSalary(ref(c)) as Average_Salary From Countries c;

/* com null
select e.department.location.country.country_name as Country_Name, avg(salary) as Avg_Salary From Employees e Group By e.department.location.country;

select c.Country_Name, avg(value(e).salary) as AVG_SALARY From Countries c, table(value(c).Locations) l, table(value(l).departments) d, table(value(d).employees) e
Group By c.Country_Name;

SQL 
select c.Country_name, NVL(avg(e.salary), 0) from Countries c
    left join locations l on c.country_id = l.country.country_id
    left join departments d on l.location_id = d.location.location_id
    left join employees e on d.department_id = e.department.department_id
Group By c.country_name;
*/

--Query 6
/*
--Devolve todas as cidades de todos os países
select c.Country_Name, value(l).location_id as Location_ID,  value(l).city as City, value(l).state_province as State_Province
From Countries c, table(value(c).Locations) l;*/


--Average salary per Location
select c.country_name, value(l).location_id as Location_ID, value(l).city as City, value(l).state_province as State_Province, c.GetAvgSalary(value(l)) as Average_Salary_per_Location
from Countries c, table(c.locations) l;


