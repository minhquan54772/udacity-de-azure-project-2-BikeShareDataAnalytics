-- Create calendar dimension table
IF OBJECT_ID('dbo.dim_calendar') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[dim_calendar];
END

CREATE EXTERNAL TABLE dbo.dim_calendar
WITH (
    LOCATION    = 'star_schema/dim_calendar',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
WITH date_data AS (SELECT DISTINCT
	DATEPART(WEEKDAY,  [date]) as [day_of_week],
	DAY([date]) as [day],
	DATEPART(MONTH, [date]) as [month],
	DATEPART(YEAR, [date]) as [year],
	DATEPART(QUARTER, [date]) as [quarter]
FROM [dbo].[staging_payment])
SELECT
	CONCAT([day_of_week], [month], [year], [quarter]) as date_id,
	[day_of_week],
	[day],
	[month],
	[year],
	[quarter]
FROM date_data

SELECT TOP 100 * FROM dbo.dim_calendar
GO