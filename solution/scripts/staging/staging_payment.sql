IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'quannm70-filesystem_quannm70_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [quannm70-filesystem_quannm70_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://quannm70-filesystem@quannm70.dfs.core.windows.net' 
	)
GO

IF OBJECT_ID('dbo.staging_payment') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[staging_payment];
END

CREATE EXTERNAL TABLE dbo.staging_payment (
	[payment_id] bigint,
	[date] nvarchar(100),
	[amount] float,
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.payment.csv',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_payment
GO