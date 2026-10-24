with hourly as (
    select
        weekday,
        hour,
        count() as transaction_count,
        sum(target) as fraud_count,
        100.0 * fraud_count / transaction_count as fraud_rate,
        sum(amount) as total_amount,
        sumIf(amount, target = 1) as fraud_amount
    from {{ ref('stg_transactions') }}
    group by weekday, hour
)

select
    weekday,
    hour,
    transaction_count,
    fraud_count,
    fraud_rate,
    total_amount,
    fraud_amount,
    100.0 * sum(fraud_count) over ()
    / sum(transaction_count) over () as overall_fraud_rate,
    fraud_rate > overall_fraud_rate as is_high_risk
from hourly
