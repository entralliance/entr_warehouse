select
    CAST(Wind_turbine_name as {{dbt_utils.type_string()}}) as wind_turbine_name,
    -- {# Date_time,
    -- to_utc_timestamp(
    --     to_timestamp(Date_time, "yyyy-MM-dd'T'HH:mm:ssXXX"),
    --     current_timezone()
    --     ) as conv_date_time,
    -- CAST(Date_time as {{dbt_utils.type_timestamp()}}) as raw_datetime_cast, #}
    {{dbt_date.convert_timezone('CAST(Date_time as ' ~ dbt_utils.type_timestamp() ~ ')', 'UTC')}} as date_time,
    CAST(Ba_avg as {{dbt_utils.type_numeric()}}) as ba_avg,
    CAST(P_avg  as {{dbt_utils.type_numeric()}}) as p_avg,
    CAST(Ws_avg as {{dbt_utils.type_numeric()}}) as ws_avg,
    CAST(Va_avg as {{dbt_utils.type_numeric()}}) as va_avg,
    CAST(Ot_avg as {{dbt_utils.type_numeric()}}) as ot_avg,
    CAST(Ya_avg as {{dbt_utils.type_numeric()}}) as ya_avg,
    CAST(Wa_avg as {{dbt_utils.type_numeric()}}) as wa_avg

from
    {{ref('la_haute_borne_data_sample')}}
