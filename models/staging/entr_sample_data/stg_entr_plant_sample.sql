{# 
    TODO:
        - tie in plant dimension
#}

{% set src_model = 'int_entr_plant_sample__cast' %}

with
    src as (select * from {{ref(src_model)}}),
    map as (select * from {{ref('map_entr_plant_sample')}}),
    std_tags as (select * from {{ref('dim_entr_tag_list')}}),

src_molten as (
    {{
        dbt_utils.unpivot(
            ref(src_model),
            cast_to='numeric',
            exclude=['plant_name','date_time'],
            field_name='plant_tag_name',
            value_name='tag_value'
        )
    }}
)

select
    src_molten.plant_name,
    std_tags.entr_tag_id,
    {# map.tag_name as entr_tag_name, #}
    src_molten.date_time,
    src_molten.plant_tag_name,
    src_molten.tag_value
from src_molten
left join map on lower(src_molten.plant_tag_name) = lower(map.variable_name)
left join std_tags on lower(map.tag_name) = lower (std_tags.entr_tag_name)
