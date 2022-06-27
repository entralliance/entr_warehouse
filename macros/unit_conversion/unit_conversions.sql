{% macro entr_single_tag_unit_conversion(relation_for_table_structure, entr_tag_id, operation, new_units, cte=relation_for_table_structure, where='1=1') %}

    {% set columns = get_list_of_columns(from=relation_for_table_structure) %}
    select
        {% for col in columns|map('lower') %}
            {% if col == 'tag_value' %}
            case
                when entr_tag_id = {{entr_tag_id}} then {{operation}}
                else tag_value
            end as tag_value
            {% elif col == 'value_units' %}
            case
                when entr_tag_id = {{entr_tag_id}} then '{{new_units}}'
                else value_units
            end as value_units
            {% else %}
            {{col}}
            {% endif %}{% if not loop.last %}, {% endif %}
        {% endfor %}
    from {{cte}}
    where {{where}}

{% endmacro %}
