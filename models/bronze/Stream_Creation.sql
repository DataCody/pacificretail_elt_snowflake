use pacificretail_db.bronze
create or replace stream customer_changes_stream on table raw_customer
    append_only = true

create or replace stream product_changes_stream on table raw_product
    append_only = true

create or replace stream order_changes_stream on table raw_order
    append_only = true

    show streams in pacificretail_db.bronze