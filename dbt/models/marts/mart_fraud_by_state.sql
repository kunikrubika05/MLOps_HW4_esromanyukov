select
    state,
    count() as transaction_count,
    sum(target) as fraud_count,
    100.0 * fraud_count / transaction_count as fraud_rate,
    uniqExact(customer_key) as customer_count,
    uniqExact(merchant) as merchant_count,
    sum(amount) as total_amount,
    sumIf(amount, target = 1) as fraud_amount
from {{ ref('stg_transactions') }}
group by state
