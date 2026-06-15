select *

from {{ ref('stg_sales') }}

where salesamount <= 0