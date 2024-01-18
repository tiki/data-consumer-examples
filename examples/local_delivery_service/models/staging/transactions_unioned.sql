with unioned as (
    select * from {{ source("tiki_cr_default", "stg_delivery__pfd") }}
    union all
    select * from {{ source("tiki_cr_default", "stg_delivery__doordash") }}
    union all
    select * from {{ source("tiki_cr_default", "stg_delivery__ubereats") }}
),

cleaned as (
    select
        lower(userid) as userid,
        lower(transactionid) as transactionid,
        authorized_date,
        transaction_date,
        clean_merchant_name,
        lower(merchant_name) as merchant_name,
        transaction_name,
        amount,
        payment_channel,
        category_level1,
        category_level2,
        category_level3,
        num_levels,
        primary_personal_finance_category,
        detailed_personal_finance_category,
        merchant_address,
        merchant_city,
        merchant_state,
        merchant_zip
)

select * from cleaned
