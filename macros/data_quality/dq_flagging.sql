{% macro min_max_condition(column_name, min, max, where, inclusive=false) %}
    {% if inclusive is false %}
    {% set min_comparison = '<' %}
    {% set max_comparison = '>' %}
    {% else %}
    {% set min_comparison = '<=' %}
    {% set max_comparison = '>=' %}
    {% endif %}
    ({{ column_name }} {{min_comparison}} {{min}} or {{ column_name }} {{max_comparison}} {{max}}) {% if where is defined %} and {{where}} {% endif %}
{% endmacro %}

{% macro flag_min_max(column_name, min, max, alias, where='1=1', inclusive=false) %}
    case
        when {{min_max_condition(column_name, min, max, where, inclusive)}} then true
        else false
    end as {% if alias is defined %} {{alias}} {% else %} {{ 'flag_min_max_' + column_name}} {% endif %}
{% endmacro %}

{% macro scrub_min_max(column_name, min, max, alias, where='1=1', inclusive=false) %}
    case
        when {{min_max_condition(column_name, min, max, where, inclusive)}} then null
        else {{column_name}}
    end as {% if alias is defined %} {{alias}} {% else %} {{ column_name + '_min_max_scrubbed'}} {% endif %}
{% endmacro %}

{% macro stale_condition(column_name, datetime_column, partition_by_cols, exclude_values=[], lag_length=1) %}
    {% if partition_by_columns is defined %} 
        {{ adapter.quote(column_name) }} = lag( {{ adapter.quote(column_name) }}, {{ lag_length }} ) over ( partition by {{ partition_by_columns}} order by {{adapter.quote(datetime_column)}})
    {%- else -%}
        {{ adapter.quote(column_name) }} = lag( {{ adapter.quote(column_name) }}, {{ lag_length }} ) over ( order by {{adapter.quote(datetime_column)}})
    {% endif %}
    {% if exclude_values|length > 0 %} 
        and {{ adapter.quote(column_name) }} not in ({{ jinja_list_to_sql(exclude_values) }})
    {% endif %}
{% endmacro %}

{% macro flag_stale(column_name, datetime_column, partition_by_cols, exclude_values=[], lag_length=1) %}
    case
        when {{stale_condition(column_name, datetime_column, partition_by_cols, exclude_values, lag_length)}} then true
        else false
    end as {% if alias is defined %} {{alias}} {% else %} {{ adapter.quote('flag_stale_' + column_name) }} {% endif %}
{% endmacro %}

{% macro scrub_stale(column_name, datetime_column, partition_by_cols, alias, exclude_values=[], lag_length=1) %}
    case
        when {{stale_condition(column_name, datetime_column, partition_by_cols, exclude_values, lag_length)}} then null
        else {{column_name}}
    end as {% if alias is defined %} {{alias}} {% else %} {{ column_name + '_stale_scrubbed'}} {% endif %}
{% endmacro %}

{% macro scrub_min_max_stale(column_name, datetime_column, min, max, partition_by_cols, alias, exclude_values=[], lag_length=1, where='1=1', inclusive=false) %}
    case
        when ({{stale_condition(column_name, datetime_column, partition_by_cols, exclude_values, lag_length)}}) or ({{min_max_condition(column_name, min, max, where, inclusive)}}) then null
        else {{column_name}}
    end as {% if alias is defined %} {{alias}} {% else %} {{ column_name + '_stale_scrubbed'}} {% endif %}
{% endmacro %}
