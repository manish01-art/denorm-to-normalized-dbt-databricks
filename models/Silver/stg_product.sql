{{ config(materialized='view') }}

select distinct

    md5(product_name) as product_key,

    product_name

from {{ ref('stg_sales') }}
where product_name is not null 