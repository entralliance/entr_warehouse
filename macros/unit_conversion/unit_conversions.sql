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

{% macro entr_multiple_tag_unit_conversions(relation_for_table_structure, entr_tag_ids, operations, new_units, cte=relation_for_table_structure, where='1=1') %}
    {# TODO: add argument validation #}
    {% set columns = get_list_of_columns(from=relation_for_table_structure) %}
    {% set trans_list = [] %}
    {% for i in range(0,entr_tag_ids|length) %}
        {% do trans_list.append({'entr_tag_id': entr_tag_ids[i], 'operation': operations[i], 'new_units': new_units[i]}) %}
    {% endfor %}
    select
        {% for col in columns|map('lower') %}
            {% if col == 'tag_value' %}
            case
                {% for item in trans_list %}
                when entr_tag_id = {{item['entr_tag_id']}} then {{item['operation']}}
                {% endfor %}
                else tag_value
            end as tag_value
            {% elif col == 'value_units' %}
            case
                {% for item in trans_list %}
                when entr_tag_id = {{item['entr_tag_id']}} then '{{item["new_units"]}}'
                {% endfor %}
                else value_units
            end as value_units
            {% else %}
            {{col}}
            {% endif %}{% if not loop.last %}, {% endif %}
        {% endfor %}
    from {{cte}}
    where {{where}}

{% endmacro %}
