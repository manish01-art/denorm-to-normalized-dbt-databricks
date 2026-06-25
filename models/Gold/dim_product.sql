{{ config(materialized='table') }}

select distinct

product_key,
product_name

from {{ ref('stg_product') }}