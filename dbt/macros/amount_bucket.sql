{% macro amount_bucket(amount) -%}
case
    when {{ amount }} >= {{ var('large_amount') }} then 'LARGE'
    when {{ amount }} >= {{ var('medium_amount') }} then 'MEDIUM'
    else 'SMALL'
end
{%- endmacro %}
