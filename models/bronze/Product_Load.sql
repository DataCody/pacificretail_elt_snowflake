use pacificretail_db.bronze
create or replace file format json_file_format
    type = json
    strip_outer_array = true
    ignore_utf8_errors = true;

--verify
select
    $1
from @azure_stage/Product/
    (file_format => json_file_format)
limit 10;

--create product table
create table if not exists raw_product (
    product_id int,
    name string,
    category string,
    brand string,
    price float,
    stock_quantity int,
    rating float,
    is_active boolean,
    source_file_name string,
    source_file_row_number int,
    ingestion_timestamp timestamp_ntz default current_timestamp()
);

--task
create or replace task load_product_data_task
    warehouse = compute_wh
    schedule = 'USING CRON 0 3 * * * Australia/Brisbane'
as
    copy into raw_product (
        product_id,
        name,
        category,
		brand,
        price,
		stock_quantity ,
		rating ,
		is_active ,
        source_file_name,
        source_file_row_number
    )
    from (
        select
            $1:product_id::INT,
            $1:name::STRING,
            $1:category::STRING,
			$1:brand::STRING,
            $1:price::FLOAT,
            $1:stock_quantity::INT,
			$1:rating::FLOAT,
			$1:is_active::BOOLEAN,
            metadata$filename,
            metadata$file_row_number
        FROM @azure_stage/Product/
    )
    file_format = (format_name = 'json_file_format')
    on_error = 'CONTINUE'
    pattern = '.*[.]json';

--start the task
alter task load_product_data_task resume;