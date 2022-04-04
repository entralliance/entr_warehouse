{{
    config(materialized='table')
}}

select
    cast(plant_id as {{dbt_utils.type_int()}}) as plant_id,
    cast(plant_name as {{dbt_utils.type_string()}}) as plant_name,
    cast(latitude as {{dbt_utils.type_numeric()}}) as latitude,
    cast(longitude as {{dbt_utils.type_numeric()}}) as longitude,
    cast(plant_capacity as {{dbt_utils.type_numeric()}}) as plant_capacity,
    cast(number_of_turbines as {{dbt_utils.type_int()}}) as number_of_turbines,
    cast(turbine_capacity as {{dbt_utils.type_numeric()}}) as turbine_capacity
from
    {{ref('seed_asset_plant')}}
