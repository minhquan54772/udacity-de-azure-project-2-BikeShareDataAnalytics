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

IF OBJECT_ID('dbo.staging_rider') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[staging_rider];
END

CREATE EXTERNAL TABLE dbo.staging_rider (
	[rider_id] bigint,
	[first] nvarchar(100),
	[last] nvarchar(100),
	[address] nvarchar(1000),
	[birthday] nvarchar(100),
	[account_start_date] nvarchar(100),
	[account_end_date] nvarchar(100),
	[is_member] bit
	)
	WITH (
	LOCATION = 'public.rider.csv',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_rider
GO