with
    src as (select * from {{ ref('fct_entr_plant_data') }}),
    plant_dim as (select * from {{ ref('dim_asset_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }})

select
    plant_dim.plant_name,
    tag_dim.entr_tag_name,
    src.*
from src
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
where entr_tag_id in (2553, 2555)
