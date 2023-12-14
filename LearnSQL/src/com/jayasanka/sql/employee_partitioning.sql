use learnDataPartition;

select * from employee limit 10;

show create table employee;
-- SHOW TABLE STATUS LIKE 'employee'\G;

desc employee;

select substring(emp_id, 1, 4), count(1) from employee group by substring(emp_id, 1, 4);

-- 2021040812133300681
-- 2021000000000000000
alter table employee 
partition by RANGE(emp_id) (
    PARTITION p0 VALUES LESS THAN (2020000000000000000),
    PARTITION p1 VALUES LESS THAN (2021000000000000000),
    PARTITION p2 VALUES LESS THAN (2022000000000000000),
    PARTITION p3 VALUES LESS THAN (2023000000000000000),
    PARTITION p4 VALUES LESS THAN (MAXVALUE)
);

alter table employee 
partition by RANGE(salary) (
    PARTITION p0 VALUES LESS THAN (1000000),
    PARTITION p1 VALUES LESS THAN (2500000),
    PARTITION p2 VALUES LESS THAN (5000000),
    PARTITION p3 VALUES LESS THAN (7500000),
    PARTITION p4 VALUES LESS THAN (MAXVALUE)
);

alter table employee
PARTITION BY KEY()
PARTITIONS 4;

/**
alter table employee
partition by RANGE(emp_id)
SUBPARTITION BY Key(emp_id)
SUBPARTITION 4
(
    PARTITION p0 VALUES LESS THAN (2500000),
    PARTITION p1 VALUES LESS THAN (5000000),
    PARTITION p2 VALUES LESS THAN (7500000),
    PARTITION p3 VALUES LESS THAN (MAXVALUE)
);
*/

SELECT CONCAT('ALTER TABLE ', TABLE_NAME,' ENGINE=MyISAM;') 
FROM INFORMATION_SCHEMA.TABLES
WHERE ENGINE='InnoDB'
AND table_schema = 'learnDataPartition';

ALTER TABLE department ENGINE=MyISAM;
ALTER TABLE employee ENGINE=MyISAM;
ALTER TABLE employee_history ENGINE=MyISAM;
ALTER TABLE sales ENGINE=MyISAM;

show create table sales;

alter table sales partition by range(store_id)( partition p0 values less than (10), partition p1 values less than (50), partition p2 values less than (100),
partition p3 values less than MAXVALUE );
