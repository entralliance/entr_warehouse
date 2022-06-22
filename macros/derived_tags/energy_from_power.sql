{% macro w_to_wh(power, interval_s='interval_s') %}
    {{power}} * {{interval_s}} / 3600
{% endmacro %}

