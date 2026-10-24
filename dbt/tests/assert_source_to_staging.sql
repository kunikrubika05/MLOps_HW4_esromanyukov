with raw as (
    select
        count() as transaction_count,
        sum(target) as fraud_count,
        uniqExact(trimBoth(name_1), trimBoth(name_2), lat, lon) as customer_count,
        countIf(amount < 0) as negative_amount_count
    from {{ source('raw', 'transactions') }}
),

staging as (
    select
        count() as transaction_count,
        sum(target) as fraud_count,
        uniqExact(customer_key) as customer_count
    from {{ ref('stg_transactions') }}
)

select
    raw.transaction_count as raw_count,
    staging.transaction_count as staging_count,
    raw.fraud_count as raw_fraud_count,
    staging.fraud_count as staging_fraud_count,
    raw.customer_count as raw_customer_count,
    staging.customer_count as staging_customer_count,
    raw.negative_amount_count
from raw
cross join staging
where
    raw.transaction_count = 0
    or raw.transaction_count != staging.transaction_count
    or raw.fraud_count != staging.fraud_count
    or raw.customer_count != staging.customer_count
    or raw.negative_amount_count > 0
