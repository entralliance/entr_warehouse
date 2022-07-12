with
    src as (select * from {{ ref('int_openoa_wtg_scada__filtered') }})

select
    distinct entr_tag_name, interval_s, value_type, value_units
from src
