with raw as (
    select count() as transaction_count, sum(target) as fraud_count
    from {{ source('raw', 'transactions') }}
),

staging as (
    select count() as transaction_count, sum(target) as fraud_count
    from {{ ref('stg_transactions') }}
)

select
    raw.transaction_count as raw_count,
    staging.transaction_count as staging_count,
    raw.fraud_count as raw_fraud_count,
    staging.fraud_count as staging_fraud_count
from raw
cross join staging
where
    raw.transaction_count = 0
    or raw.transaction_count != staging.transaction_count
    or raw.fraud_count != staging.fraud_count
