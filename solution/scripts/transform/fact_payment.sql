-- Create payment fact table
IF OBJECT_ID('dbo.fact_payment') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[fact_payment];
END

CREATE EXTERNAL TABLE dbo.fact_payment
WITH (
    LOCATION    = 'star_schema/fact_payment',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT
	pa.[payment_id],
	pa.[date],
	pa.[amount],
	pa.[rider_id],
	ca.[date_id]
FROM [dbo].[staging_payment] as pa
JOIN [dbo].[dim_calendar] as ca ON DATEPART(WEEKDAY, pa.[date]) = ca.[day_of_week]
AND DAY(pa.[date]) = ca.[day]
AND DATEPART(MONTH, pa.[date]) = ca.[month]
AND DATEPART(YEAR, pa.[date]) = ca.[year]
AND DATEPART(QUARTER, pa.[date]) = ca.[quarter]

SELECT TOP 100 * FROM dbo.fact_payment
GO