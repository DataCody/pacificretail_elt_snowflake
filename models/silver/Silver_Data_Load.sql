use database pacificretail_db
create schema silver
use pacificretail_db.silver

--Silver Customer Table
create table if not exists silver.customer (
    customer_id int,
    name string,
    email string,
    country string,
    customer_type string,
    registration_date date,
    age int,
    gender string,
    total_purchases int,
    last_updated_timestamp timestamp_ntz default current_timestamp()
);

--Silver Product Table
create table if not exists silver.product (
    product_id int,
    name string,
    category string,
    brand string,
    price float,
    stock_quantity int,
    rating float,
    is_active boolean,
    last_updated_timestamp timestamp_ntz default current_timestamp()
);

--Silver Order Table
create table if not exists silver.orders (
    transaction_id string,
    customer_id int,
    product_id int,
    quantity int,
    store_type string,
    total_amount double,
    transaction_date date,
    payment_method string,
    last_updated_timestamp timestamp_ntz default current_timestamp()
);