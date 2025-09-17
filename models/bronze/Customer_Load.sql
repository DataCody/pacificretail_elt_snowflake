use pacificretail_db.bronze
create or replace file format csv_file_format
  type = csv
  field_delimiter = ','
  skip_header = 1
  null_if = ('NULL','null', '')
  empty_field_as_null = true
  compression = auto;

--verify
select
    $1, $2, $3, $4, $5, $6
from @azure_stage/Customer
    (file_format => csv_file_format)
limit 10;

-- create customer table
create table if not exists raw_customer (
    customer_id int,
    name string,
    email string,
    country string,
    customer_type string,
    registration_date date,
    age int,
    gender string,
    total_purchases int,
    source_file_name string,
    source_file_row_number int,
    ingestion_timestamp timestamp_ntz default current_timestamp()
);

--create task
create or replace task load_customer_data_task
    warehouse = compute_wh
    schedule = 'USING CRON 0 2 * * * Australia/Brisbane'
as

    copy into raw_customer (
        customer_id,
        name,
        email,
        country,
        customer_type,
        registration_date,
		age,
		gender,
		total_purchases,
        source_file_name,
        source_file_row_number
    )
    from (
        select 
            $1,
            $2,
            $3,
            $4,
            $5,
            $6::DATE,
			$7,
			$8,
			$9,
            metadata$filename,
            metadata$file_row_number
        from @azure_stage/Customer/
    )
    file_format = (format_name = 'csv_file_format')
    on_error = 'CONTINUE'
    pattern = '.*[.]csv';

--start the task
alter task load_customer_data_task resume;
