select
    category,
    count() as transaction_count,
    sum(target) as fraud_count,
    100.0 * fraud_count / transaction_count as fraud_rate,
    sum(amount) as total_amount,
    sumIf(amount, target = 1) as fraud_amount
from {{ ref('stg_transactions') }}
group by category
