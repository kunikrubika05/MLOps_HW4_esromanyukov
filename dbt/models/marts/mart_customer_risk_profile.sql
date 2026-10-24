select
    customer_key,
    count() as transaction_count,
    sum(target) as fraud_count,
    100.0 * fraud_count / transaction_count as fraud_rate,
    sum(amount) as total_amount,
    avg(amount) as average_amount,
    min(transaction_time) as first_transaction_time,
    max(transaction_time) as last_transaction_time,
    uniqExact(transaction_date) as active_days,
    case
        when fraud_rate >= {{ var('high_risk_rate') }} then 'HIGH'
        when fraud_rate > 0 then 'MEDIUM'
        else 'LOW'
    end as risk_level
from {{ ref('stg_transactions') }}
group by customer_key
