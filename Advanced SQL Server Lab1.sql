--Advanced SQL Server Lab1 

--Use ITI DB
--1.Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not
--2.Display student full name and the name of the course he is taking
--For only courses which have a grade  
--3.Display number of courses for each topic name
--4.Display max and min salary for instructors
--5.Display instructors who have salaries less than the average salary of all instructors.
--6.Display the Department name that contains the instructor who receives the minimum salary.
use ITI

select I.Ins_Name,d.Dept_Name  
from Instructor as I left outer join Department as D
on D.Dept_Id=I.Dept_Id
-------------------------------------------------
select s.St_Fname+' '+s.St_Lname as [full name ] ,c.Crs_Name 
from Student as s ,Course as c , Stud_Course as sc 
where s.St_Id=sc.St_Id 
and c.Crs_Id=sc.Crs_Id 
and Grade is not null
----------------------------------------------------------
select T.Top_Name,count(c.Crs_Id) as [# ofcourses] from Course as c ,Topic as T
where t.Top_Id=c.Top_Id
group by t.Top_Name
-------------------------------------------------------
select max(salary) as max_salary , min(salary) as min_salary from Instructor
--------------------------------------------------------------------------
select I.Ins_Name 
from Instructor I
where salary < (select avg(Salary) from Instructor)
-------------------------------------------------------------------------------
select D.Dept_Name from Department as D, Instructor as I
where D.Dept_Id=I.Dept_Id 
and I.Salary=(select min(Salary) from Instructor)

--another solution
select D.Dept_Name from Department as D, Instructor as I
where D.Dept_Id=I.Dept_Id 
and I.Salary=(select top(1)Ins_Name from Instructor order by Salary asc)
-------------------------------------------------------------------------------

--Use AdventureWorks DB

--1.Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2008’ and ‘7/29/2014’
--2.Display only Products with a StandardCost below $110.00 (show ProductID, Name only)
--3.Display ProductID, Name if its weight is unknown

--4. Display all Products with a Silver, Black, or Red Color

--5. Display any Product with a Name starting with the letter B


--6. Transfer the rowguid ,FirstName, SalesPerson from Customer table in a newly created table named [customer_Archive] updated
--Note: Check your database to see the new table and how many rows in it?
---Try the previous query but without transferring the data

use AdventureWorks2012

select sales.SalesOrderHeader.SalesOrderID,sales.SalesOrderHeader.ShipDate 
from sales.SalesOrderHeader
where OrderDate 
between '2005-07-28 00:00:00.000' and '2005-07-29 00:00:00.000'
--------------------------------------------------------------------
select product.ProductID,product.Name 
from production.Product
where product.StandardCost <110000
-------------------------------------------
select product.ProductID,
       product.Name
from production.Product
where product.Weight is null 
-------------------------------------------------
select product.name,
       product.Color 
from Production.Product 
where Product.Color in ('Silver','Black','Red')
------------------------------------------------------
select product.ProductID,
       product.Name 
from production.Product
where Product.Name like 'B%'
-------------------------------------------------------------
select c.rowguid,c.CustomerID,c.PersonID into customer_Archive 
from Sales.Customer as c
------------------------------------------------------------
select c.rowguid,c.CustomerID,c.PersonID into customer_Archive_2
from Sales.Customer as c
where 1=2
--------------------------------------------------------------------
select * from customer_Archive -- with data
select * from customer_Archive_2 -- no data just structure 
--------------------------------------------------------------------
--Use Company_SD DB

--1.Display the Department id, name and SSN and the name of its manager.
--2.Display the name of the departments and the name of the projects under its control.
--3.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.
--4.Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
--5.Find the names of the employees who directly supervised with Kamel Mohamed.
--6.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
--7.For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate
--8.Display All Data of the mangers
--9.Display All Employees data and the data of their dependents even if they have no dependents

use Company_SD

select Dname ,Dnum, Fname+' '+Lname as [full name],SSN 
from Departments , Employee
where Departments.Dnum = Employee.Dno

------------------------------------------------
select Dname,
       Pname
from Departments , Project
where Departments.Dnum = Project.Dnum

--------------------------------------------------
select Fname+' '+Lname as [full name] from Employee 
where Dno=30 and Salary between 1000 and 2000

---------------------------------------------------
select Fname +' ' +Lname as [full name] 
from Employee as E,project as P ,Works_for as W,Departments as D
where  D.Dnum=E.Dno and D.Dnum=P.Dnum and p.Pnumber=W.Pno
and Dno=10
and Pname='AL Rabwah' 
and Hours >=10

-----------------------------------------------------------------
select x.Fname+' '+x.Lname as [full name] from Employee X , Employee Y 
where Y.SSN = X.Superssn and Y.Fname +' '+Y.Lname= 'Kamel Mohamed'

---------------------------------------------------------------------------

select Fname+' ' +Lname as [full name] ,
       Pname 
from Employee , Project ,Departments 
where Departments.Dnum= Employee.Dno and  Departments.Dnum= Project.Dnum 
order by Pname
---------------------------------------------------------------------------
select Pnumber,Dname ,
       Lname,
	   Address,
	   Bdate 
from Employee E , Departments D , Project P
where E.SSN=D.MGRSSN 
and D.Dnum=P.Dnum 
and City='cairo'
-------------------------------------------------------------------------------
select E.* 
from Employee E inner join Departments D
on E.SSN=D.MGRSSN
------------------------------------------------------------------------------
select E.*,
       D.* 
from Employee E left outer join Dependent D
on  E.SSN=D.ESSN
----------------------------------------------------------------------------------
--Bouns
--Display results of the following two statements and explain what is the meaning of @@AnyExpression
select @@VERSION
--Display Version of microsoft sql server

----------------------------------
--Display name of my server
select @@SERVERNAME
-----------------------------------------