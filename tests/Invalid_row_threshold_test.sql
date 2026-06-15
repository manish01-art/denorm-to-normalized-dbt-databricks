with quality as (

select

avg(
case
when is_column_valid='Valid'
then 1
else 0
end
) as valid_pct

from {{ ref('stg_sales') }}

)

select *

from quality

where valid_pct < 0.90