{% macro w_to_wh(power, interval_s='interval_s') %}
    {{power}} * {{interval_s}} / 3600
{% endmacro %}

{% macro entr_wtg_power_to_energy(source_table=ref('fct_entr_wtg_scada')) %}
    select
        wind_turbine_id,
        2378 as entr_tag_id, -- WTUR.SupWh
        date_time,
        {{w_to_wh('tag_value')}} as tag_value,
        interval_s,
        'derived' as value_type,
        {{dbt_utils.concat(['value_units', "'h'"])}} value_units,
        {{dbt_utils.concat(['standard_units', "'h'"])}} standard_units
    from (select * from {{source_table}} where entr_tag_id = 2456)
{% endmacro %}
