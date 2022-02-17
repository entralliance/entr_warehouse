with
    src as (select * from {{ ref('seed_plant_data_sample') }})

select
    'La Haute Borne' as plant_name,
    -- {# Date_time,
    -- to_utc_timestamp(
    --     to_timestamp(Date_time, "yyyy-MM-dd'T'HH:mm:ssXXX"),
    --     current_timezone()
    --     ) as conv_date_time,
    -- CAST(Date_time as {{dbt_utils.type_timestamp()}}) as raw_datetime_cast, #}
    {{dbt_date.convert_timezone('CAST(time_utc as ' ~ dbt_utils.type_timestamp() ~ ')', 'UTC')}} as date_time,
    cast(net_energy_kwh as {{dbt_utils.type_numeric()}}) as net_energy_kwh,
    cast(availability_kwh as {{dbt_utils.type_numeric()}}) as availability_kwh,
    cast(curtailment_kwh as {{dbt_utils.type_numeric()}}) as curtailment_kwh
from src
