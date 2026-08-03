/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze; 
    ==========================================================================
    */

create or alter procedure bronze.load_bronze as
Begin
	Declare @start_time DATETIME, @end_time Datetime,@batch_start_time DATETIME, @batch_end_time DATETIME;
	Begin Try
		set @batch_start_time = getdate();
		print '=================================================';
		print 'loading Bronze Layer';
		print '=================================================';


		Print '---------------------------------------------';
		Print 'Loading CRM Tables';
		Print '---------------------------------------------';

		set @start_time = getdate();
		Print '>> Truncating Table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info

		Print '>> Inserting Data Into: bronze.crm_cust_info';
		bulk insert bronze.crm_cust_info
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

		set @start_time = getdate();
		Print '>> Truncating Table: bronze.crm_prd_info'
		Truncate table bronze.crm_prd_info
		Print '>> Inserting Data Into: bronze.crm_prd_info'
		Bulk insert bronze.crm_prd_info
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'


		set @start_time = getdate();
		Print '>> Truncating Table: bronze.crm_sales_info';
		truncate table bronze.crm_sales_info
	
		Print '>> Inserting Data Into: bronze.crm_sales_info';
		bulk insert bronze.crm_sales_info
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'


		Print '---------------------------------------------';
		Print 'Loading ERP Tables';
		Print '---------------------------------------------';

		set @start_time = getdate();
		Print '>> Truncating Table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12

		Print '>> Inserting Data Into: bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

		set @start_time = getdate();
		Print '>> Truncating Table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101
	
		Print '>> Inserting Data Into: bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

		set @start_time = getdate();
		Print '>> Truncating Table: bronze.erp_px_cat';
		truncate table bronze.erp_px_cat

		Print '>> Inserting Data Into: bronze.erp_px_cat';
		bulk insert bronze.erp_px_cat
		from 'C:\Users\Rakesh\Desktop\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		with (
			Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'
		set @batch_end_time = getdate();
		print '====================================================='
		print 'Loading Bronze Layer is Completed'
		print ' -Total Load Duration:' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) as nvarchar) + 'Seconds';
	End Try
	Begin Catch
		print '============================================================'
		print ' error occured while loading Bronze Layer';
		print '============================================================'
		print 'ErrorMessage'+ error_message();
		Print 'ErrorMessage' + cast(Error_number() as varchar(50));
		Print 'ErrorMessage' + cast(Error_state() as varchar(50));
	End Catch
END
  
