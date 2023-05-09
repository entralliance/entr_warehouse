with
    
    tag_dim as (select * from {{ref('dim_entr_tag_list')}}),
    
    asset_dim as (select * from {{ref('dim_entr_asset')}} where asset_type = 'wtg' and plant_id = 1),
    
    map as (
        select
            cast(entr_tag_name as {{ dbt.type_string()}}) as entr_tag_name,
            cast(tag_subtype_id as {{ dbt.type_int()}}) as tag_subtype_id,
            cast(source_tag_name as {{ dbt.type_string()}}) as source_tag_name,
            cast(tag_is_new as {{ dbt.type_string()}}) as tag_is_new,
            cast(interval_s as {{ dbt.type_numeric()}}) as interval_s,
            cast(value_type as {{ dbt.type_string()}}) as value_type,
            cast(value_units as {{ dbt.type_string()}}) as value_units,
            cast(source_tag_long_name as {{ dbt.type_string()}}) as source_tag_long_name,
            cast(comment as {{ dbt.type_string()}}) as comment
        from {{ref('seed_la_haute_borne_scada_tag_map')}}
    ),

    src_molten as (
        {{
            dbt_utils.unpivot(
                source('entr_warehouse', 'la_haute_borne_scada_sample'),
                cast_to=dbt.type_numeric(),
                exclude=['wind_turbine_name','date_time'],
                field_name='scada_tag_name',
                value_name='tag_value'
            )
        }}
    ),

    dedupe as (
        select
            wind_turbine_name as asset_name,
            date_time,
            scada_tag_name,
            avg(tag_value) as tag_value
        from src_molten
        {{dbt_utils.group_by(3)}}
    )

select
    asset_dim.asset_id,
    tag_dim.entr_tag_id,
    map.tag_subtype_id,
    cast(dedupe.date_time as {{dbt.type_timestamp()}}) as date_time,
    dedupe.tag_value,
    map.interval_s,
    map.value_type,
    map.value_units,
    tag_dim.standard_units
from dedupe
left join map on lower(dedupe.scada_tag_name) = lower(map.source_tag_name)
left join tag_dim using(entr_tag_name)
left join asset_dim using(asset_name)
