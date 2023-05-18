-- Advanced SQLServer Lab2
-- Use ITI DB
--1.Create a view that displays student full name, course name if the student has a grade more than 50.
--2.Create an Encrypted view that displays manager names and the topics they teach.
--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
--4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query Update V1 set st_address=’tanta’ Where st_address=’alex’.
--5.Create temporary table [Session based
--6.Create temporary table [Session based] on Company DB to save employee name.


use ITI
------------
create view Vgrades 
as
select s.St_Fname+' '+s.St_Lname as [full name],
       c.Crs_Name
from Student as s ,Stud_Course as sc,Course as c
where s.St_Id=sc.St_Id and c.Crs_Id=sc.Crs_Id
and sc.Grade > 50

----------------------------------------------------
create view V_Instructor_Topic
with encryption
as
select i.Ins_Name,
       t.Top_Name  
from Instructor as i ,Department as d ,Ins_Course as ic,Course as c,Topic as t
where  d.Dept_Id=i.Dept_Id 
and  i.Ins_Id=ic.Ins_Id 
and c.Crs_Id=ic.Crs_Id  
and t.Top_Id=c.Top_Id

------------------------------------------------------
create view Vinstructor_Dept
with schemabinding
as
select i.Ins_Name,
       d.Dept_Name  
from dbo.Instructor as i ,dbo.Department as d 
where  d.Dept_Id=i.Dept_Id 
and d.Dept_Name='SD' or d.Dept_Name = 'Java'

-------------------------------------------------------------
create view V1
as
select * from Student s
where s.St_Address in ('Cairo' ,'Alex')
----------------------------------------
update V1 set St_Address='Tanta' 
where St_Address='Alex'

------------------------------------------
create table #temp_tabel( id int not null ,name varchar(50) not null)
select * from #temp_tabel
------------------------------------------
use Company_SD
select e.Fname+' '+e.Lname as [full name] into ##Temp_tabel_employee 
from Employee as e 
-------------------------------------------------------------------
--Use Company DB
--1.Fill the Create a view that will display the project name and the number of employees work on it
--2.Create a view named  “v_count “ that will display the project name and the number of hours for each one
--3.Create a view named   “v_D30” that will display employee number, project number, hours of the projects in department 30. updated
--4.Create a view named ” v_project_500” that will display the emp no. for the project 500, use the previously created view  “v_D30”
--5.Delete the views  “v_D30” and “v_count”
--6.Display the project name that contains the letter “c” Use the previous view created in Q#1
--7.create view name “v_2021_check” that will display employee no., which must be from the first of January and the last of December 2021.
--this view will be used to insert data so make sure that the coming new data matchs the condition

--8.Create Rule for Salary that is less than 2000 using rule.
--9.Create a new user defined data type named loc with the following Criteria:
--nchar(2) 
--default: NY 
--create a rule for this Data type :values in (NY,DS,KW)) and associate it to the location column
 --------------------------------------------------------------------------------------------------------


create view Vproject
as
select p.Pname,
       count(e.SSN) as [# of employee]
from Employee as e,  Works_for as w ,  Project as p 
where e.SSN=w.ESSn 
and p.Pnumber=w.Pno
group by p.Pname

---------------------------------------------------------------------
create view V_count
as
select p.Pname,
	   count(w.Hours) as [# of hours] 
from Works_for as w ,  Project as p
where p.Pnumber=w.Pno
group by p.Pname

-----------------------------------------------------------------------
create view V_D30
as
select e.SSN,
	   p.Pnumber,
	   Hours
from  Employee as e,  Works_for as w ,  Project as p 
where e.SSN=w.ESSn 
and p.Pnumber=w.Pno
and e.Dno=30

---------------------------------------------------------------------------
create view V_project_500
as
select SSN 
from V_D30 as v ,Project as p
where p.Pnumber=v.Pnumber 
and p.Pnumber=500

-----------------------------------------------------------------------
drop view V_D30 ,V_count

---------------------------------------------------------------------
select v.Pname 
from Vproject as v
where v.Pname like '%c%'

--------------------------------------------------------------------
create view V_2021_check
as
select e.SSN 
from Employee as e ,Works_for as w
where e.SSN=w.ESSn
and w.Enter_date  between '2021-1-1' and '2021-12-30'

-----------------------------------------------------------------------------
create rule R_salary  as @x<2000

sp_bindrule R_salary,'Employee.Salary'

--------------------------------------------------------------
sp_addtype loc,'nchar(2)'
create rule Rvalues as @x in ('NY','DS','KW')
create default D_value as 'NY'
sp_bindrule Rvalues ,loc
sp_bindefault D_value ,loc

-------------------------------------------------------------------