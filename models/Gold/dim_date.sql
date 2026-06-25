{{ config(materialized='table') }}

select distinct

cast(date_format(order_date,'yyyyMMdd') as bigint) as date_key,

order_date,

year(order_date) as year,

month(order_date) as month,

quarter(order_date) as quarter,

dayofweek(order_date) as day_of_week

from {{ ref('stg_sales') }}

where order_date is not null