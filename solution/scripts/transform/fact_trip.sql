-- Create trip fact table
IF OBJECT_ID('dbo.fact_trip') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[fact_trip];
END

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION    = 'star_schema/fact_trip',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
	tr.[trip_id],
	tr.[start_at],
	tr.[end_at],
	tr.[start_station_id],
	tr.[end_station_id],
	DATEPART(HOUR, tr.start_at) as [time_day],
    DATEDIFF(MINUTE, tr.start_at, tr.end_at) as [duration],
    DATEDIFF(YEAR, ri.birthday, tr.start_at) as [age_at_trip_time],
	tr.[rider_id],
	ca.[date_id]
FROM [dbo].[staging_trip] as tr
JOIN [dbo].[dim_rider] as ri ON tr.rider_id = ri.rider_id
JOIN [dbo].[dim_calendar] as ca ON DATEPART(WEEKDAY, tr.[start_at]) = ca.[day_of_week]
AND DAY(tr.[start_at]) = ca.[day]
AND DATEPART(MONTH, tr.[start_at]) = ca.[month]
AND DATEPART(YEAR, tr.[start_at]) = ca.[year]
AND DATEPART(QUARTER, tr.[start_at]) = ca.[quarter]

SELECT TOP 100 * FROM dbo.fact_trip
GO