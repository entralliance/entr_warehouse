{% macro wind_direction_from_components(u, v) %}
    180 + atan2({{u}}, {{v}}) * 180 / pi()
{% endmacro %}

{# TODO: refactor how columns get called - make dynamic based on relation #}
{% macro entr_reanalysis_wind_direction_from_components(source_table=ref('fct_entr_reanalysis_data')) %}
    select
        2559 as entr_tag_id, -- WMETR.HORWdDir
        plant_id,
        reanalysis_dataset_id,
        date_time,
        {{wind_direction_from_components('u_component.tag_value', 'v_component.tag_value')}} as tag_value,
        interval_s,
        'derived' as value_type,
        'deg' value_units
    from (select * from {{source_table}} where entr_tag_id = 2557) u_component
    left join (select * from {{source_table}} where entr_tag_id = 2558) v_component using(plant_id, reanalysis_dataset_id, date_time, interval_s, value_type, value_units)
{% endmacro %}
