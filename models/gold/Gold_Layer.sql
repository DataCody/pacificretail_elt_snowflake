create schema if not exists gold;
use pacificretail_db.gold;

truncate table raw_customer;
truncate table raw_product;
truncate table raw_order;

show tasks
execute task LOAD_CUSTOMER_DATA_TASK;
execute task LOAD_ORDER_DATA_TASK;
execute task LOAD_PRODUCT_DATA_TASK;

select * from raw_customer;
select * from raw_product;
select * from raw_order;

show streams
select * from CUSTOMER_CHANGES_STREAM;
select * from ORDER_CHANGES_STREAM;
select * from PRODUCT_CHANGES_STREAM;

show tasks;

execute task SILVER_ORDER_MERGE_TASK;
execute task SILVER_PRODUCT_MERGE_TASK;
execute task SILVER_CUSTOMER_MERGE_TASK;

select * from customer;
select * from product;
select * from orders;



