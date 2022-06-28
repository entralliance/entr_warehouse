{% set src_relation = ref('fct_entr_reanalysis_data') %}

with
    src as (select * from {{src_relation}}),
    reanalysis_dim as (select * from {{ ref('dim_asset_reanalysis_dataset') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

src_filt as (
    select * from src
    where entr_tag_id in (2556, 2557, 2558, 2559, 2560, 2561, 2562)
),

{% set src_colnames = get_list_of_columns(src_relation)|map('lower')|list %}
{% set coalesce_fields = ['tag_value', 'value_type', 'value_units'] %}
derived_tags_join as (
    select
        {% for col in src_colnames %}
            {% if col in coalesce_fields %}
                coalesce(src_filt.{{col}}, wd.{{col}}) as {{col}}
            {% else %}
                {{col}}
            {% endif %}{% if not loop.last %}, {% endif %}
        {% endfor %}
    from src_filt
    full outer join ({{entr_reanalysis_wind_direction_from_components('src')}}) wd
        using({{ jinja_list_to_sql( src_colnames|reject('in', coalesce_fields)|list ) }})
)

select
    plant_dim.plant_name,
    reanalysis_dim.reanalysis_dataset_name,
    tag_dim.entr_tag_name,
    derived_tags_join.*
from derived_tags_join
left join reanalysis_dim using(reanalysis_dataset_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
