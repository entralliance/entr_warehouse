with
    src as (select * from {{ ref('fct_entr_reanalysis_data') }}),
    reanalysis_dim as (select * from {{ ref('dim_asset_reanalysis_dataset') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

derived_tags_union as (
    select * from src
    where entr_tag_id in (2556, 2557, 2558, 2559, 2560, 2561, 2562)

    union all

    select {{ dbt_utils.star(from=ref('fct_entr_reanalysis_data')) }}
    from ({{entr_reanalysis_wind_direction_from_components('src')}}) wd
)

select
    plant_dim.plant_name,
    reanalysis_dim.reanalysis_dataset_name,
    tag_dim.entr_tag_name,
    derived_tags_union.*
from derived_tags_union
left join reanalysis_dim using(reanalysis_dataset_id)
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
