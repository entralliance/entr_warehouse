with
    src as (select * from {{ ref('int_openoa_reanalysis_data__filtered') }})

select
    distinct entr_tag_name, interval_n, interval_units, value_type, value_units
from src
