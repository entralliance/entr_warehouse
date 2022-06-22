with
    src as (select * from {{ ref('fct_entr_wtg_scada') }}),
    wtg_dim as (select * from {{ ref('dim_asset_wind_turbine') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

energy_union as (
    select * from src
    where entr_tag_id in (
        1349,
        2456,
        1104,
        1089,
        1058,
        1162,
        1074
    )

    union all

    select
        wind_turbine_id,
        2378 as entr_tag_id, -- WTUR.SupWh
        date_time,
        {{w_to_wh('tag_value')}} as tag_value,
        interval_s,
        'derived' as value_type,
        {{dbt_utils.concat(['value_units', "'h'"])}} value_units,
        {{dbt_utils.concat(['standard_units', "'h'"])}} standard_units
    from (select * from src where entr_tag_id = 2456)
)

select
    plant_id,
    plant_dim.plant_name,
    wtg_dim.wind_turbine_name,
    tag_dim.entr_tag_name,
    energy_union.*
from energy_union
left join wtg_dim using(wind_turbine_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
