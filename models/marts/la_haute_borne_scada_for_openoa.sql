-- OpenOA currently accepts data in the format generated by this projection
-- of the underlying entr data store.
{{ config(materialized='table', sort='time') }}

WITH keyedSource as (
    SELECT concat(wind_turbine_name, "_", date_time) as key, *
    FROM {{ref('entr_data_standardized')}}
--     FROM `entrhub.entr_warehouse.entr_data_standardized`
)
SELECT
    MAX (wind_turbine_name) as Wind_turbine_name,
    CAST(MAX(date_time) as Timestamp) as Date_time,
    CAST(MAX(IF(entr_tag_name = "WTUR.W", tag_value, NULL)) as Numeric) AS P_avg, -- wtur_W_avg
    CAST(MAX(IF(entr_tag_name = "WMET.HorWdSpd", tag_value, NULL)) as Numeric) AS Ws_avg, -- wmet_wdspd_avg
    CAST(MAX(IF(entr_tag_name = "WMET.HorWdDir", tag_value, NULL)) as Numeric) AS Wa_avg, -- wmet_HorWdDir_avg
    CAST(MAX(IF(entr_tag_name = "WMET.HorWdDirRel", tag_value, NULL)) as Numeric) AS Va_avg, -- wmet_VaneDir_avg
    CAST(MAX(IF(entr_tag_name = "WNAC.Dir", tag_value, NULL)) as Numeric) AS Ya_avg, -- wyaw_YwAng_avg
    CAST(MAX(IF(entr_tag_name = "WTOW.GndCtlTmp", tag_value, NULL)) as Numeric) AS Ot_avg, -- wmet_EnvTmp_avg
    CAST(MAX(IF(entr_tag_name = "WROT.BlPthAngVal", tag_value, NULL)) as Numeric) AS Ba_avg -- wrot_BlPthAngVal1_avg
FROM keyedSource
GROUP BY key
ORDER BY key