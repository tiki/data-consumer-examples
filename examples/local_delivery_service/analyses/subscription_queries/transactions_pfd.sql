select *
from {{ var("tiki_transactions_table") }}
where
    merchant_state = 'TN'
    and (
        lower(merchant_name) like 'premium food%'
        or lower(transaction_name) like '%premium food'
        or lower(transaction_name) like 'premium food%'
    )
