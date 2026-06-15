
select *

from {{ ref('stg_sales') }}

where order_date > current_date()

and is_column_valid = 'valid'