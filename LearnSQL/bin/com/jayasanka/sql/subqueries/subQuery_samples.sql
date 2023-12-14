use learnSubquery;

--------------------------------------------------------------------------------
-- INTRO
--------------------------------------------------------------------------------
/* < WHAT IS SUBQUERIES? Sample subquery. How SQL processes this statement containing subquery? > */

/* QUESTION: Find the employees who's salary is more than the average salary earned by all employees. */
-- 1) find the avg salary
-- 2) filter employees based on the above avg salary
select *
from employee e
where salary > (select avg(salary) from employee)
order by e.salary;

--------------------------------------------------------------------------------
-- TYPES OF SUBQUERY
--------------------------------------------------------------------------------
/* < SCALAR SUBQUERY > */
/* QUESTION: Find the employees who earn more than the average salary earned by all employees. */
-- it return exactly 1 row and 1 column

select *
from employee e
where salary > (select avg(salary) from employee)
order by e.salary;

select e.*, round(avg_sal.sal,2) as avg_salary
from employee e
join (select avg(salary) sal from employee) avg_sal
	on e.salary > avg_sal.sal;
    
---- 
/* < MULTIPLE ROW SUBQUERY > */
-- Multiple column, multiple row subquery
/* 
QUESTION: Find the employees who earn the highest salary in each department. 
1) find the highest salary in each department.
2) filter the employees based on above result.
*/
select *
from employee e
where (dept_name,salary) in (select dept_name, max(salary) from employee group by dept_name)
order by dept_name, salary;

----
-- Single column, multiple row subquery
/* 
QUESTION: Find department who do not have any employees 
1) find the departments where employees are present.
2) from the department table filter out the above results.
*/
select *
from department
where dept_name not in (select distinct dept_name from employee);

----
/* < CORRELATED SUBQUERY >
-- A subquery which is related to the Outer query
/* 
QUESTION: Find the employees in each department who earn more than the average salary in that department. 
1) find the avg salary per department
2) filter data from employee tables based on avg salary from above result.
*/

select *
from employee e
where salary > (select avg(salary) from employee e2 where e2.dept_name=e.dept_name)
order by dept_name, salary;

/* QUESTION: Find department who do not have any employees */
-- Using correlated subquery
select *
from department d
where not exists (select 1 from employee e where e.dept_name = d.dept_name);


--------------------------------------------------------------------------------
/* < SUBQUERY inside SUBQUERY (NESTED Query/Subquery)> */

/* 
QUESTION: Find stores who's sales where better than the average sales accross all stores 
1) find the sales for each store
2) average sales for all stores
3) compare 2 with 1
*/
-- Using multiple subquery
select *
from (select store_name, sum(price) as total_sales
	 from sales
	 group by store_name) sales
join (select avg(total_sales) as avg_sales
	 from (select store_name, sum(price) as total_sales
		  from sales
		  group by store_name) x
	 ) avg_sales
on sales.total_sales > avg_sales.avg_sales;

-- Using WITH clause
with sales as
	(select store_name, sum(price) as total_sales
	 from sales
	 group by store_name)
select *
from sales
join (select avg(total_sales) as avg_sales from sales) avg_sales
	on sales.total_sales > avg_sales.avg_sales;

-- CLAUSES WHERE SUBQUERY CAN BE USED
--------------------------------------------------------------------------------
/* < Using Subquery in WHERE clause > */
/* QUESTION:  Find the employees who earn more than the average salary earned by all employees. */
select *
from employee e
where salary > (select avg(salary) from employee)
order by e.salary;


--------------------------------------------------------------------------------
/* < Using Subquery in FROM clause > */
/* QUESTION: Find stores who's sales where better than the average sales accross all stores */
-- Using WITH clause
with sales as
	(select store_name, sum(price) as total_sales
	 from sales
	 group by store_name)
select *
from sales
join (select avg(total_sales) as avg_sales from sales) avg_sales
	on sales.total_sales > avg_sales.avg_sales;
    
    
--------------------------------------------------------------------------------
/* < USING SUBQUERY IN SELECT CLAUSE > */
-- Only subqueries which return 1 row and 1 column is allowed (scalar or correlated)
/* QUESTION: Fetch all employee details and add remarks to those employees who earn more than the average pay. */
select e.*
, case when e.salary > (select avg(salary) from employee)
			then 'Above average Salary'
	   else null
  end remarks
from employee e;

-- Alternative approach
select e.*
, case when e.salary > avg_sal.sal
			then 'Above average Salary'
	   else null
  end remarks
from employee e
cross join (select avg(salary) sal from employee) avg_sal;



--------------------------------------------------------------------------------
/* < Using Subquery in HAVING clause > */
/* QUESTION: Find the stores who have sold more units than the average units sold by all stores. */
select store_name, sum(quantity) Items_sold
from sales
group by store_name
having sum(quantity) > (select avg(quantity) from sales);




-- SQL COMMANDS WHICH ALLOW A SUBQUERY
--------------------------------------------------------------------------------
/* < Using Subquery with INSERT statement > */
/* QUESTION: Insert data to employee history table. Make sure not insert duplicate records. */
insert into employee_history
select e.emp_id, e.emp_name, d.dept_name, e.salary, d.location
from employee e
join department d on d.dept_name = e.dept_name
where not exists (select 1
				  from employee_history eh
				  where eh.emp_id = e.emp_id);


--------------------------------------------------------------------------------
/* < Using Subquery with UPDATE statement > */
/* QUESTION: Give 10% increment to all employees in Bangalore location based on the maximum
salary earned by an emp in each dept. Only consider employees in employee_history table. */
update employee e
set salary = (select max(salary) + (max(salary) * 0.1)
			  from employee_history eh
			  where eh.dept_name = e.dept_name)
where dept_name in (select dept_name
				   from department
				   where location = 'Bangalore')
and e.emp_id in (select emp_id from employee_history);


--------------------------------------------------------------------------------
/* < Using Subquery with DELETE statement > */
/* QUESTION: Delete all departments who do not have any employees. */
delete from department d1
where dept_name in (select dept_name from department d2
				    where not exists (select 1 from employee e
									  where e.dept_name = d2.dept_name));