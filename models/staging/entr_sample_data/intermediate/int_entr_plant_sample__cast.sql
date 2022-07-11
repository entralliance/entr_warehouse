{{ config(materialized='table') }}

select
    'La Haute Borne' as plant_name,
    {{dbt_date.convert_timezone('cast(time_utc as ' ~ dbt_utils.type_timestamp() ~ ')', 'UTC')}} as date_time,
    cast(net_energy_kwh as {{dbt_utils.type_numeric()}}) as net_energy_kwh,
    cast(availability_kwh as {{dbt_utils.type_numeric()}}) as availability_kwh,
    cast(curtailment_kwh as {{dbt_utils.type_numeric()}}) as curtailment_kwh
from {{ source('entr_warehouse', 'la_haute_borne_plant_data_sample') }} 
