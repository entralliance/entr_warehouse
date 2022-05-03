{% set src_model = 'int_entr_era5_sample__cast' %}

with
    src as (select * from {{ref(src_model)}}),
    map as (select * from {{ref('map_entr_era5_sample')}}),
    tag_dim as (select * from {{ref('dim_entr_tag_list')}}),

src_molten as (
    {{
        dbt_utils.unpivot(
            ref(src_model),
            cast_to=dbt_utils.type_numeric(),
            exclude=['plant_id','reanalysis_dataset_id', 'date_time'],
            field_name='source_tag_name',
            value_name='tag_value'
        )
    }}
)

select
    src_molten.plant_id,
    src_molten.reanalysis_dataset_id,
    tag_dim.entr_tag_id,
    src_molten.date_time,
    src_molten.tag_value,
    map.interval_n,
    map.interval_units,
    map.value_type,
    map.value_units
from src_molten
left join map using (source_tag_name)
left join tag_dim using (entr_tag_name)
