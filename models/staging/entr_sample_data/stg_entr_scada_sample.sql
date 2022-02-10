{# 
    TODO:
        - tie in turbine dimension
#}

{% set src_model = 'int_entr_scada_sample' %}

with
    src as (select * from {{ref(src_model)}}),
    map as (select * from {{ref('map_entr_scada_sample')}}),
    std_tags as (select * from {{ref('dim_entr_tag_list')}}),

src_molten as (
    {{
        dbt_utils.unpivot(
            ref(src_model),
            cast_to='numeric',
            exclude=['wind_turbine_name','date_time'],
            field_name='scada_tag_name',
            value_name='tag_value'
        )
    }}
)

select
    map.tag_name as entr_tag_name,
    src_molten.*
from src_molten
left join map on split(lower(src_molten.scada_tag_name),"_")[0] = lower(map.variable_name)
