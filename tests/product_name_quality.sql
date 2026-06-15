select *

from {{ ref('stg_sales') }}

where length(product_name) < 3