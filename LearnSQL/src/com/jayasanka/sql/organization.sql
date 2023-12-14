use learnDataPartition;

/** 
	drop table employee_history;
	drop table employee;
	drop table sales;
	drop table department;
*/

CREATE TABLE department (
    dept_id BIGINT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(100)
);

CREATE TABLE employee (
    emp_id BIGINT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id BIGINT NOT NULL,
    salary INT,
    CONSTRAINT fk_emp FOREIGN KEY (dept_id)
        REFERENCES department (dept_id)
);

CREATE TABLE employee_history (
    emp_id BIGINT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    dept_id BIGINT,
    salary INT,
    location VARCHAR(100),
    CONSTRAINT fk_emp_hist_01 FOREIGN KEY (dept_id)
        REFERENCES department (dept_id),
    CONSTRAINT fk_emp_hist_02 FOREIGN KEY (emp_id)
        REFERENCES employee (emp_id)
);

CREATE TABLE sales (
    store_id BIGINT PRIMARY KEY,
    store_name VARCHAR(50),
    product_name VARCHAR(50),
    quantity INT,
    price BIGINT
);

/** 
	delete from employee_history where emp_id > 0;
	delete from employee where emp_id > 0;
	delete from sales where store_id > 0;
	delete from department where dept_id > 0;
    
    commit;
*/

/** 
	select * from employee_history;
	select * from employee;
	select * from sales;
	select * from department;
    
	select count(1) from employee_history;
	select count(1) from employee;
	select count(1) from sales;
	select count(1) from department;
*/