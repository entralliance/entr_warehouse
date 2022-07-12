{% set property_keys = ['plant_id'] %}

{% set avail_model = {
    'model_name': ref('int_openoa_plant_curtail_avail_data__filtered'),
    'openoa_alias': 'curtail',
} %}

{% set meter_model = {
    'model_name': ref('int_openoa_plant_meter_data__filtered'),
    'openoa_alias': 'meter',
} %}

{% set scada_model = {
    'model_name': ref('int_openoa_wtg_scada__filtered'),
    'openoa_alias': 'scada',
} %}

{% set reanalysis_model = {
    'model_name': ref('int_openoa_reanalysis_data__filtered'),
    'openoa_alias': 'reanalysis',
} %}

{% set models = [avail_model, meter_model, scada_model, reanalysis_model] %}

{% for mdl in models %}

    select
        distinct
            '{{ mdl.openoa_alias }}' as table_name,
            {{jinja_list_to_sql(property_keys)}},
            'time_frequency' as property,
            interval_s as value
    from {{ mdl.model_name }}

    {% if not loop.last %}
    union all
    {% endif %}

{% endfor %}
