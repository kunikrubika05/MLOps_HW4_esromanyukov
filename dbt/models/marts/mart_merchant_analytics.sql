select
    merchant,
    count() as transaction_count,
    sum(target) as fraud_count,
    100.0 * fraud_count / transaction_count as fraud_rate,
    sum(amount) as total_amount,
    sumIf(amount, target = 1) as fraud_amount,
    fraud_rate >= {{ var('suspicious_rate') }} as is_suspicious
from {{ ref('stg_transactions') }}
group by merchant
