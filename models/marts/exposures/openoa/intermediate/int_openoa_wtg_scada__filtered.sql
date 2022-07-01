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

unit_conversions as (
    {{entr_multiple_tag_unit_conversions(
        relation_for_table_structure=ref('fct_entr_wtg_scada'),
        entr_tag_ids=[
            1349,
            2456,
            2378
        ],
        operations=[
            'case when ((tag_value % 360) + 360) % 360 > 180 then ((tag_value % 360) + 360) % 360 - 360 else ((tag_value % 360) + 360) % 360 end',
            'tag_value * 1000',
            'tag_value * 1000'
        ],
        new_units=[
            'deg',
            'W',
            'Wh'
        ],
        cte='energy_union'
    )}}
)

select
    plant_id,
    plant_dim.plant_name,
    wtg_dim.wind_turbine_name,
    tag_dim.entr_tag_name,
    cte.*
from unit_conversions cte
left join wtg_dim using(wind_turbine_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
