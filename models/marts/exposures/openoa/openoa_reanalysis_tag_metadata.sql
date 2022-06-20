with
    src as (select * from {{ ref('int_openoa_reanalysis_data__filtered') }})

select
    distinct reanalysis_dataset_name, entr_tag_name, interval_s, value_type, value_units
from src
