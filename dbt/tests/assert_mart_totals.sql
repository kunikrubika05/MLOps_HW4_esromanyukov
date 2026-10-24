with source_totals as (
    select count() as transaction_count, sum(amount) as total_amount
    from {{ ref('stg_transactions') }}
)

{% for model in [
    'mart_daily_state_metrics', 'mart_fraud_by_category', 'mart_fraud_by_state',
    'mart_customer_risk_profile', 'mart_hourly_fraud_pattern',
    'mart_merchant_analytics'
] %}
    select '{{ model }}' as model_name
    from {{ ref(model) }}
    having
        sum(transaction_count) != (select transaction_count from source_totals)
        or sum(total_amount) != (select total_amount from source_totals)
    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}
