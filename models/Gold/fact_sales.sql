{{ config(materialized='table') }}

select

c.customer_key,

p.product_key,

cast(date_format(s.order_date,'yyyyMMdd') as bigint) as date_key,

s.quantity,

s.salesamount,

s.salesorderline,

s.source_batch,

s.silver_loaded_at

from {{ ref('stg_sales') }} s

left join {{ ref('stg_customer') }} c
on s.customer_name = c.customer_name

left join {{ ref('stg_product') }} p
on s.product_name = p.product_name

where s.is_column_valid = 'Valid'