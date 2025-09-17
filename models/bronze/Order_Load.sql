use pacificretail_db.bronze

create or replace file format parquet_file_format
    type = parquet
    compression = auto
    binary_as_text = false
    trim_space = false;

--verify
select 
    *
from @azure_stage/Order/
    (file_format => parquet_file_format)
limit 10;

--create order table
create or replace table raw_order (
    customer_id int,
    payment_method string,
    product_id int,
    quantity int,
    store_type string,
    total_amount double,
    transaction_date date,
    transaction_id string,
      source_file_name string,
      source_file_row_number int,
      ingestion_timestamp timestamp_ntz default current_timestamp()
);

--Task
create or replace task load_order_data_task
    warehouse = compute_wh
    schedule = 'USING CRON 0 4 * * * Australia/Brisbane'
as
    copy into raw_order (
        customer_id,
        payment_method,
        product_id,
        quantity,
        store_type,
        total_amount,
        transaction_date,
        transaction_id,
        source_file_name,
        source_file_row_number
    )
    from (
        select
            $1:customer_id::int,
            $1:payment_method::string,
            $1:product_id::int,
            $1:quantity::int,
            $1:store_type::string,
            $1:total_amount::double,
            $1:transaction_date::date,
            $1:transaction_id::string,
            metadata$filename,
            metadata$file_row_number
        from @azure_stage/Order/
    )
    file_format = (format_name = 'parquet_file_format')
    on_error = 'continue'
    pattern = '.*[.]parquet';

--start the task
alter task load_order_data_task resume