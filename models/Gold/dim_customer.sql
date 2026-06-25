{{ config(materialized='table') }}

select distinct

customer_key,
customer_name,
country

from {{ ref('stg_customer') }}