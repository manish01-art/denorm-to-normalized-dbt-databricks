with cte as (

select

sum(
case
when customer_name is null
then 1
else 0
end
) as null_rows,

count(*) as total_rows

from {{ ref('stg_sales') }}

)

select *

from cte

where null_rows / total_rows > 0.10