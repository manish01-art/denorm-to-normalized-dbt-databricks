select *
from {{ source('source', 'computer_sales_1st_batch') }}