{{
  config(
    table_type='iceberg',
    materialized='table',
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

-- get a list of all distinct userid values so we can join demographic data
with txn_users as (
    select distinct userid
    from {{ ref('transactions_unioned') }}
),

-- we only care about users who have declared to live in TN
-- grab hashed zip code and
txn_users_with_demographics as (
    select
        u.userid,
        d.user_zip_sha256,
        d.user_state_abbrev as user_state
    from txn_users u
    join {{ source('tiki_cr_default', 'stg_demographics__tn') }} d on u.userid = d.userid
    where user_state_abbrev = 'TN'
),

-- only transactions where merchant_state is TN
-- OR the user has a matching demographic record identifying home state as TN.
transactions_with_demographics as (
    select
        t.*,
        d.user_zip_sha256,
        d.user_state
    from {{ ref('transactions_unioned') }} t
    left join txn_users_with_demographics d on t.userid = d.userid
    where
        t.merchant_state = 'TN'
        or d.user_state = 'TN'
),

final as (
    select * from transactions_with_demographics
)

select * from final
