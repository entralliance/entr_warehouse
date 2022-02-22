with
    src as (select * from {{ ref('seed_la_haute_borne_data_sample') }})

select
    cast(wind_turbine_name as {{dbt_utils.type_string()}}) as wind_turbine_name,
    -- {# Date_time,
    -- to_utc_timestamp(
    --     to_timestamp(Date_time, "yyyy-MM-dd'T'HH:mm:ssXXX"),
    --     current_timezone()
    --     ) as conv_date_time,
    -- CAST(Date_time as {{dbt_utils.type_timestamp()}}) as raw_datetime_cast, #}
    {{dbt_date.convert_timezone('CAST(Date_time as ' ~ dbt_utils.type_timestamp() ~ ')', 'UTC')}} as date_time,
    cast(ba_avg as {{dbt_utils.type_numeric()}}) as ba_avg,
    cast(p_avg  as {{dbt_utils.type_numeric()}}) as p_avg,
    cast(ws_avg as {{dbt_utils.type_numeric()}}) as ws_avg,
    cast(va_avg as {{dbt_utils.type_numeric()}}) as va_avg,
    cast(ot_avg as {{dbt_utils.type_numeric()}}) as ot_avg,
    cast(ya_avg as {{dbt_utils.type_numeric()}}) as ya_avg,
    cast(wa_avg as {{dbt_utils.type_numeric()}}) as wa_avg
from src
