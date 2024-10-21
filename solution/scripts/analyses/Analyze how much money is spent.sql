-- Per month, quarter, year
SELECT
    AVG(pa.[amount]) as avg_amount,
    SUM(pa.[amount]) as sum_amount,
    ca.[year],
    ca.[quarter],
    ca.[month]
FROM [dbo].[fact_payment] pa
JOIN [dbo].[dim_calendar] ca ON pa.date_id = ca.date_id
JOIN [dbo].[dim_rider] ri ON pa.rider_id = ri.rider_id
GROUP BY ca.[year], ca.[quarter], ca.[month]
ORDER BY ca.[year], ca.[quarter], ca.[month];

-- Per member, based on the age of the rider at account start
SELECT
    AVG(pa.[amount]) as avg_amount,
    SUM(pa.[amount]) as sum_amount,
    COUNT(pa.[amount])as count,
    ri.[age_at_account_start]
FROM [dbo].[fact_payment] pa
JOIN [dbo].[dim_rider] ri ON pa.rider_id = ri.rider_id
GROUP BY ri.[age_at_account_start]
ORDER BY ri.[age_at_account_start];