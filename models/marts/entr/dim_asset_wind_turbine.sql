{{
    config(materialized='table')
}}

select
    cast(wind_turbine_id as {{dbt_utils.type_int()}}) as wind_turbine_id,
    cast(wind_turbine_name as {{dbt_utils.type_string()}}) as wind_turbine_name,
    cast(latitude as {{dbt_utils.type_numeric()}}) as latitude,
    cast(longitude as {{dbt_utils.type_numeric()}}) as longitude,
    cast(elevation as {{dbt_utils.type_numeric()}}) as elevation,
    cast(hub_height as {{dbt_utils.type_numeric()}}) as hub_height,
    cast(rotor_diameter as {{dbt_utils.type_numeric()}}) as rotor_diameter,
    cast(rated_power as {{dbt_utils.type_numeric()}}) as rated_power,
    cast(manufacturer as {{dbt_utils.type_string()}}) as manufacturer,
    cast(model as {{dbt_utils.type_string()}}) as model
from
    {{ref('seed_asset_wind_turbine')}}
