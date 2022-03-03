with
    src as (select * from {{ ref('dim_asset_plant') }})

select
    plant_id,
    plant_name,
    latitude,
    longitude,
    plant_capacity,
    number_of_turbines,
    turbine_capacity
from src
