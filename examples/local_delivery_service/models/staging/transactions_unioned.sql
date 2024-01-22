with unioned as (
    select 'premium_food_delivery' as merchant_id, *
    from {{ source("tiki_cr_default", "stg_delivery__pfd") }}
    union all
    select 'doordash' as merchant_id, *
    from {{ source("tiki_cr_default", "stg_delivery__doordash") }}
    union all
    select 'uber_eats' as merchant_id, *
    from {{ source("tiki_cr_default", "stg_delivery__ubereats") }}
),

cleaned as (
    select
        merchant_id,
        lower(userid) as userid,
        lower(transactionid) as transactionid,
        authorized_date,
        transaction_date,
        clean_merchant_name,
        merchant_name,
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
    from unioned
)

select * from cleaned
