with transactions as (
    select
        transaction_time,
        trimBoth(merch) as merchant,
        trimBoth(cat_id) as category,
        toDecimal64(toString(round(amount, 2)), 2) as amount,
        trimBoth(name_1) as first_name,
        trimBoth(name_2) as last_name,
        upperUTF8(trimBoth(us_state)) as state,
        lat,
        lon,
        merchant_lat,
        merchant_lon,
        target
    from {{ source('raw', 'transactions') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'transaction_time', 'hex(merchant)', 'hex(category)', 'amount',
        'hex(first_name)', 'hex(last_name)', 'lat', 'lon', 'merchant_lat', 'merchant_lon'
    ]) }} as transaction_key,
    {{ dbt_utils.generate_surrogate_key([
        'hex(first_name)', 'hex(last_name)', 'lat', 'lon'
    ]) }} as customer_key,
    transaction_time,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.day_of_week('transaction_time', isoweek=true) }} as weekday,
    toHour(transaction_time) as hour,
    merchant,
    category,
    amount,
    {{ amount_bucket('amount') }} as amount_bucket,
    state,
    target
from transactions
