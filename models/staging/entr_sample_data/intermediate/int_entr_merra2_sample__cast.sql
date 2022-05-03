select
    1 as plant_id,
    1 as reanalysis_dataset_id,
    cast( datetime as {{dbt_utils.type_timestamp()}} ) as date_time,
    cast( u_ms as {{dbt_utils.type_numeric()}} ) as u_ms,
    cast( v_ms as {{dbt_utils.type_numeric()}} ) as v_ms,
    cast( temperature_K as {{dbt_utils.type_numeric()}} ) as temperature_K,
    cast( surf_pres_Pa as {{dbt_utils.type_numeric()}} ) as surf_pres_Pa,
    cast( windspeed_ms as {{dbt_utils.type_numeric()}} ) as windspeed_ms,
    cast( winddirection_deg as {{dbt_utils.type_numeric()}} ) as winddirection_deg,
    cast( rho_kgm3 as {{dbt_utils.type_numeric()}} ) as rho_kgm3
from {{ref('seed_la_haute_borne_merra2_sample')}}
