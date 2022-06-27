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

    {{entr_wtg_power_to_energy('src')}}
),

pitch_angle_unit_conversion as (
    {{entr_single_tag_unit_conversion(
        relation_for_table_structure=ref('fct_entr_wtg_scada'),
        entr_tag_id=1349,
        operation='case when ((tag_value % 360) + 360) % 360 > 180 then ((tag_value % 360) + 360) % 360 - 360 else ((tag_value % 360) + 360) % 360 end',
        new_units='deg',
        cte='energy_union'
    )}}
)

select
    plant_id,
    plant_dim.plant_name,
    wtg_dim.wind_turbine_name,
    tag_dim.entr_tag_name,
    cte.*
from pitch_angle_unit_conversion cte
left join wtg_dim using(wind_turbine_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
