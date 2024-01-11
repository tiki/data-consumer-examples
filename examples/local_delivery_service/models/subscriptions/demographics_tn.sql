select *
from {{ var("tiki_demographics_table") }}
where
    user_state_abbrev = 'TN'
