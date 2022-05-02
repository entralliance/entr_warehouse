with
    era5_src as (select * from {{ ref('stg_entr_era5_sample') }}),
    merra2_src as (select * from {{ref('stg_entr_merra2_sample')}})

select * from era5_src
union all
select * from merra2_src
