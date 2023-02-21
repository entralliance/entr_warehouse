{% macro get_period(interval_s, output_col='interval_period') %}
    case
        when {{interval_s}} < 60 then 'second'
        when {{interval_s}} > 60 and {{interval_s}} < 3600 and mod({{interval_s}},60) = 0 then 'minute'
        when {{interval_s}} > 3600 and {{interval_s}} < 82800 and mod({{interval_s}},3600) = 0 then 'hour'
        when {{interval_s}} in (82800, 86400, 90000) then 'day' -- day
        when {{interval_s}} in (
            2419200, -- 28 days
            2505600, -- 29 days
            2592000, -- 30 days
            2678400, -- 31 days
            2674800, -- 31 days - 1 hour (March "spring forward")
            2595600 -- 30 days + 1 hour (November "fall back")
            ) then 'month' -- month
        else null -- let's just support the freqs above for now
    end as {{output_col}}
{% endmacro %}
