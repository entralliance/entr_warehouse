{{
    config(materialized='table')
}}

select
    cast(reanalysis_dataset_id as {{dbt_utils.type_int()}}) as reanalysis_dataset_id,
    cast(reanalysis_dataset_name as {{dbt_utils.type_string()}}) as reanalysis_dataset_name
from {{ref('seed_asset_reanalysis_dataset')}}
