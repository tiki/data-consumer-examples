select *
from {{ var("tiki_transactions_table") }}
where lower(merchant_name) = 'doordash'
