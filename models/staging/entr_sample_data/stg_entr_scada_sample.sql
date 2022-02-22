{% set src_model = 'int_entr_scada_sample__cast' %}

with
    src as (select * from {{ref(src_model)}}),
    map as (select * from {{ref('map_entr_scada_sample')}}),
    tag_dim as (select * from {{ref('dim_entr_tag_list')}}),
    asset_dim as (select * from {{ref('dim_asset_wind_turbine')}}),

src_molten as (
    {{
        dbt_utils.unpivot(
            ref(src_model),
            cast_to=dbt_utils.type_numeric(),
            exclude=['wind_turbine_name','date_time'],
            field_name='scada_tag_name',
            value_name='tag_value'
        )
    }}
)

select
    asset_dim.wind_turbine_id,
    {# src_molten.wind_turbine_name, #}
    tag_dim.entr_tag_id,
    {# tag_dim.entr_tag_name, #}
    src_molten.date_time,
    {# src_molten.scada_tag_name, #}
    src_molten.tag_value,
    map.interval_n,
    map.interval_units,
    map.value_type,
    map.value_units
from src_molten
left join map on lower(src_molten.scada_tag_name) = lower(map.source_tag_name)
left join tag_dim using(entr_tag_name)
left join asset_dim using(wind_turbine_name)
