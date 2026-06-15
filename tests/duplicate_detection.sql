select
source_batch,
count(*) as row_count

from {{ ref('stg_sales') }}

group by source_batch

having count(*) < 400