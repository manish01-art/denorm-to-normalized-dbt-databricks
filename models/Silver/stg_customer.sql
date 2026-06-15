{{ config(materialized='view') }}

select distinct

    md5(customer_name) as customer_key,

    customer_name,

    country

from {{ ref('stg_sales') }}
where customer_name is not null