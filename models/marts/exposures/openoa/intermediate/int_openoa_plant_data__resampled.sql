{{config(materialized='table')}}
{% set src_model = 'fct_entr_plant_data' %}

with
    src as (select * from {{ ref('fct_entr_plant_data') }}),
    plant_dim as (select * from {{ ref('dim_asset_wind_plant') }}),
    tag_dim as (select * from {{ ref('dim_entr_tag_list') }}),

    src_filt as (
        select * from src
        where entr_tag_id in (2554,2553,2555)
    ),

    period_maxs as (
        select
            plant_id,
            {{get_period('max(interval_s)', output_col='max_period')}}
        from src_filt
        group by plant_id
    ),

    downsample as (
        select
            plant_id,
            entr_tag_id,
            value_type,
            value_units,
            date_trunc(period_maxs.max_period, date_time) as date_time,
            sum(tag_value) as tag_value
        from src_filt
        left join period_maxs using(plant_id)
        group by 1,2,3,4,5
    )

select
    plant_dim.plant_name,
    tag_dim.entr_tag_name,
    downsample.*
from downsample
left join plant_dim using(plant_id)
left join tag_dim using(entr_tag_id)
