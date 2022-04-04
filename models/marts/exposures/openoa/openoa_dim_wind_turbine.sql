with
    src as (select * from {{ ref('dim_asset_wind_turbine') }})

select
    plant_id,
    wind_turbine_id,
    wind_turbine_name,
    latitude,
    longitude,
    elevation,
    hub_height,
    rotor_diameter,
    rated_power,
    manufacturer,
    model
from src
