with

    tag_dim as (select * from {{ref('dim_entr_tag_list')}}),

    map as (
        select 
            cast(entr_tag_name as {{ dbt.type_string()}}) as entr_tag_name,
            cast(tag_subtype_id as {{ dbt.type_int()}}) as tag_subtype_id,
            cast(source_tag_name as {{ dbt.type_string()}}) as source_tag_name,
            cast(interval_s as {{ dbt.type_numeric()}}) as interval_s,
            cast(value_type as {{ dbt.type_string()}}) as value_type,
            cast(value_units as {{ dbt.type_string()}}) as value_units
        from {{ref('seed_la_haute_borne_merra2_tag_map')}}
    ),

    src_molten as (
        {{
            dbt_utils.unpivot(
                source('entr_warehouse', 'la_haute_borne_merra2_sample'),
                cast_to=dbt.type_numeric(),
                exclude=['datetime'],
                field_name='source_tag_name',
                value_name='tag_value'
            )
        }}
    )

select
    1 as asset_id,
    tag_dim.entr_tag_id,
    map.tag_subtype_id,
    cast( src_molten.datetime as {{ dbt.type_timestamp()}} ) as date_time,
    src_molten.tag_value,
    map.interval_s,
    map.value_type,
    map.value_units
from src_molten
left join map on upper(map.source_tag_name) = upper(src_molten.source_tag_name)
left join tag_dim using (entr_tag_name, tag_subtype_id)
