{{ config(materialized = 'view' ) }}

with source_data as(
select * from {{ ref('bronze_computer_Sales') }}
),

cleaned as(
    select 

        trim(customer) as customer_name,

        case 
            when upper(trim(country)) in ('USA','US') then 'United States'
            when upper(trim(country)) = 'AU'  then 'Australia'
            when upper(trim(country)) = 'UK'  then 'United Kingdom'
            when upper(trim(country)) = 'ENGLAND' then 'United Kingdom'
            when upper(trim(country)) = 'FR' then 'France'
            when upper(trim(country)) = 'CA' then 'Canada'
            when upper(trim(country)) in ('DE','DEUTSCHLAND') then 'Germany'
            when upper(trim(country)) = 'DELHI INDIA' then 'India'
            when upper(trim(country)) = 'IND' then 'India'
            when upper(trim(country)) = 'ERROR' then null 
            when country like '$%' then null
            when country rlike '^[0-9]+$' then null
            when country rlike '^[0-9]{2,4}-[0-9]{2}-[0-9]{2,4}$' then null
            when trim(country) = '' then null
            else initcap(trim(country))

        end as country,

        to_date(date) as order_date,

        initcap(trim(product)) as product_name,

        case
            when qty rlike '^[0-9]+$' then cast (qty as integer) 
            else null
        end as quantity,

        cast(regexp_replace(salesamount,'[^0-9.]','') as decimal(18,2)) as  salesamount,

        case
            when upper(trim(salesorderline)) in ('TBD','N/A') then null
            when upper(trim(salesorderline)) rlike '^[0-9]+$' then cast(salesorderline as integer)
            else null
        end as salesorderline,

        case
            when country like '$%' then false
            when country rlike '^[0-9]+$' then false
            when country rlike '^[0-9]{2,4}-[0-9]{2}-[0-9]{2,4}$' then false
            when upper(trim(country))='ERROR' then false
            when country is null then false
            else true
        end as is_country_valid,

        case
            when (customer is null and country is null) or
            (customer is null and product is null) or
            (country is null and product is null)
            then 'Invalid'
            else 'Valid'
        end as is_column_valid,

        
        current_timestamp() as silver_loaded_at,

        'computer_sales_1st_batch' as source_batch

        from source_data

)

select * from cleaned 
where quantity > 0

qualify row_number()

over(

partition by customer_name,
            product_name,
            order_date

order by silver_loaded_at desc

)=1