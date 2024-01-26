select *
from {{ var("tiki_transactions_table") }}
where
    replace(lower(merchant_name), ' ') = 'ubereats'
