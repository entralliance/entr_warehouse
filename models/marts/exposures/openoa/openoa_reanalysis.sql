with
    era5 as (select * from {{ref('stg_era5_sample')}}),
    merra2 as (select * from {{ref('stg_merra2_sample')}}),
    plant_dim as (select * from {{ref('dim_asset_wind_plant')}}),

source_union as (
    select
        'ERA5' as reanalysis_data_set,
        *
    from era5

    union all

    select
        'MERRA-2' as reanalysis_data_set,
        *
    from merra2
)

select
    plant_dim.plant_name,
    source_union.*
from source_union
left join plant_dim using (plant_id)
