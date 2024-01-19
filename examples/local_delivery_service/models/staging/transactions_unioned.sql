{{
  config(
    table_type='iceberg',
    format='parquet',
    partitioned_by=['day(transaction_date)'],
    table_properties={
      'optimize_rewrite_data_file_threshold': '5',
      'optimize_rewrite_delete_file_threshold': '2',
      'vacuum_min_snapshots_to_keep': '10',
      'vacuum_max_snapshot_age_seconds': '2592000'
    }
  )
}}

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
    from unioned
)

select * from cleaned
