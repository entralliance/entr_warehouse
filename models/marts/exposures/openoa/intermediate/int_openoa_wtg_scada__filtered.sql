{% set src_model = 'fct_entr_wtg_scada' %}

with
    src as (select * from {{ ref(src_model) }}),
    wtg_dim as (select * from {{ ref('dim_asset_wind_turbine') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }})

select
    wtg_dim.wind_turbine_name,
    tag_dim.entr_tag_name,
    src.*
from src
left join wtg_dim using(wind_turbine_id)
left join tag_dim using(entr_tag_id)
where entr_tag_id in (
    1349,
    2456,
    1104,
    1089,
    1058,
    1162,
    1074
)
