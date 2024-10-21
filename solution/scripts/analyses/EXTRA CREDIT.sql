WITH rider_data AS (SELECT
    p.rider_id,
    AVG(p.trip_count) as avg_tripcount,
    AVG(p.avg_duration) as avg_duration
FROM (
    SELECT
        COUNT(tr.duration) as trip_count,
        AVG(tr.duration) as avg_duration,
        tr.[rider_id],
        ca.[month],
        ca.[year]
    FROM [dbo].[fact_trip] tr
    JOIN [dbo].[dim_calendar] ca ON tr.date_id = ca.date_id
    GROUP BY tr.rider_id, ca.[month], ca.[year]
) AS p
GROUP BY p.rider_id)
SELECT
    ri.rider_id,
    ri.avg_tripcount,
    ri.avg_duration,
    pa.total_payment
FROM rider_data ri
JOIN (SELECT 
        rider_id,
        sum(amount) as total_payment
    FROM [dbo].[fact_payment]
    GROUP BY rider_id) pa 
ON ri.rider_id = pa.rider_id