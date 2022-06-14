{{
    config(
        materialized='table',
        pre_hook="
            create temp view tmp_entr_era5_sample__read
            using csv
            options (
                path '" ~ '{{env_var("DBT_PROJECT_PATH", "warehouse")}}' ~ "/seeds/openoa_example_data/seed_la_haute_borne_era5_sample.csv',
                header 'true'
            )
        "
    )
}}

select
    1 as plant_id,
    2 as reanalysis_dataset_id,
    cast( datetime as {{dbt_utils.type_timestamp()}} ) as date_time,
    cast( u_ms as {{dbt_utils.type_numeric()}} ) as u_ms,
    cast( v_ms as {{dbt_utils.type_numeric()}} ) as v_ms,
    cast( temperature_K as {{dbt_utils.type_numeric()}} ) as temperature_K,
    cast( surf_pres_Pa as {{dbt_utils.type_numeric()}} ) as surf_pres_Pa,
    cast( windspeed_ms as {{dbt_utils.type_numeric()}} ) as windspeed_ms,
    cast( winddirection_deg as {{dbt_utils.type_numeric()}} ) as winddirection_deg,
    cast( rho_kgm3 as {{dbt_utils.type_numeric()}} ) as rho_kgm3
from tmp_entr_era5_sample__read