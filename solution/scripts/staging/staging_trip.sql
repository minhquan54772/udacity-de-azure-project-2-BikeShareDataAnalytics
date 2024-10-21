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

IF OBJECT_ID('dbo.staging_trip') IS NOT NULL
BEGIN
	DROP EXTERNAL TABLE [dbo].[staging_trip];
END

CREATE EXTERNAL TABLE dbo.staging_trip (
	[trip_id] nvarchar(100),
	[rideable_type] nvarchar(100),
	[start_at] nvarchar(100),
	[end_at] nvarchar(100),
	[start_station_id] nvarchar(100),
	[end_station_id] nvarchar(100),
	[rider_id] bigint
	)
	WITH (
	LOCATION = 'public.trip.csv',
	DATA_SOURCE = [quannm70-filesystem_quannm70_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_trip
GO