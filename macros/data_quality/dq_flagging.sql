{% macro min_max_condition(target_col, min, max, where, inclusive=false) %}
    {% if inclusive is false %}
    {% set min_comparison = '<' %}
    {% set max_comparison = '>' %}
    {% else %}
    {% set min_comparison = '<=' %}
    {% set max_comparison = '>=' %}
    {% endif %}
    ({{ target_col }} {{min_comparison}} {{min}} or {{ target_col }} {{max_comparison}} {{max}}) {% if where is defined %} and {{where}} {% endif %}
{% endmacro %}

{% macro flag_min_max(target_col, min, max, alias, where='1=1', inclusive=false) %}
    case
        when {{min_max_condition(target_col, min, max, where, inclusive)}} then 1
        else 0
    end as {% if alias is defined %} {{alias}} {% else %} {{ 'flag_min_max_' + target_col}} {% endif %}
{% endmacro %}

{% macro stale_condition(target_col, datetime_col, partition_by_cols, exclude_values=[], lag_length=1) %}
    {% if partition_by_cols is defined %} 
        {{ adapter.quote(target_col) }} = lag( {{ adapter.quote(target_col) }}, {{ lag_length }} ) over ( partition by {{ jinja_list_to_sql(partition_by_cols, quote_identifiers=true)}} order by {{adapter.quote(datetime_col)}})
    {%- else -%}
        {{ adapter.quote(target_col) }} = lag( {{ adapter.quote(target_col) }}, {{ lag_length }} ) over ( order by {{adapter.quote(datetime_col)}})
    {% endif %}
    {% if exclude_values|length > 0 %} 
        and {{ adapter.quote(target_col) }} not in ({{ jinja_list_to_sql(exclude_values) }})
    {% endif %}
{% endmacro %}

{% macro flag_stale(target_col, datetime_col, partition_by_cols, exclude_values=[], lag_length=1) %}
    case
        when {{stale_condition(target_col, datetime_col, partition_by_cols, exclude_values, lag_length)}} then 1
        else 0
    end as {% if alias is defined %} {{alias}} {% else %} {{ adapter.quote('flag_stale_' + target_col) }} {% endif %}
{% endmacro %}

