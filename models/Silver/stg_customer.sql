{{ config(materialized='view') }}

select distinct

    {{ dbt_utils.generate_surrogate_key(
    ['customer_name','country']
) }} as customer_key,

    customer_name,

    country

from {{ ref('stg_sales') }}
where customer_name is not null