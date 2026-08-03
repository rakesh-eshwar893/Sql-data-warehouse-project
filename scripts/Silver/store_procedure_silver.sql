/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
EXEC silver.load_silver
create or alter procedure silver.load_silver as
Begin
	Declare @start_time DATETIME, @end_time Datetime,@batch_start_time DATETIME, @batch_end_time DATETIME;
	Begin Try
		set @batch_start_time = getdate();
		print '=================================================';
		print 'loading silver Layer';
		print '=================================================';


		Print '---------------------------------------------';
		Print 'Loading CRM Tables';
		Print '---------------------------------------------';

		set @start_time = getdate();
	print '>> Truncating Table: silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	print '>> inserting data into: silver.crm_cust_info';
	insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gender,
		cst_create_date
		)
		select 
			cst_id,
			cst_key,
			trim(cst_firstname) as cst_firstname,
			trim(cst_lastname) as cst_lastname,
			case
				when upper(trim(cst_marital_status)) = 'M' then 'Married'
				when upper(trim(cst_marital_status)) = 'S' then 'Single'
				else 'Unknown'
			end cst_marital_status,
			case 
				when Upper(trim(cst_gender)) = 'M' then 'Male'
				when upper(trim(cst_gender)) = 'F' then  'Female'
				else 'Unknown'
			end cst_gender,
			cst_create_date
			from(
				select 
					*,
					row_number() over(partition by cst_id order by cst_create_date Desc) flaglast
					from bronze.crm_cust_info
					where cst_id is not null)t 
			where flaglast=1
		set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

	set @start_time = getdate();
	print '>> Truncating Table: silver.crm_prd_info';
	truncate table silver.crm_prd_info;
	print '>> inserting data into: silver.crm_prd_info';
	Insert into silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_name,
		prd_cost,
		prd_line,
		prd_start_date,
		prd_end_date
	)
	select 
			prd_id,
			Replace(substring(prd_key,1,5),'-','_') as cat_id,
			substring(prd_key,7,len(prd_key)) as prd_key,
			prd_name,
			isnull(prd_cost,0) as prd_cost,
			case Upper(Trim(prd_line))
				when 'M' then 'Mountain'
				when 'R' then 'Road'
				when 'S' then 'Other Sales'
				when 'T' then 'Touring'
				else 'Unknown'
			end prd_line,
			cast(prd_start_date as date) as prd_start_date,
			cast(
				dateadd(day, -1, lead(prd_start_date) over(partition by prd_key order by prd_start_date))
				as date
			) as prd_end_date
	from bronze.crm_prd_info
	set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

	set @start_time = getdate();
	print '>> Truncating Table: silver.crm_sales_info';
	truncate table silver.crm_sales_info;
	print '>> inserting data into: silver.crm_sales_info';
	 insert into silver.crm_sales_info (
		 sls_order_num,
		 sls_prd_key,
		 sls_cst_id,
		 sls_order_dt,
		 sls_ship_dt,
		 sls_due_dt,
		 sls_sales,
		 sls_quantity,
		 sls_price
	)
	 select 
		 sls_order_num,
		 sls_prd_key,
		 sls_cst_id,
		 case 
			when sls_order_dt = 0 or len(sls_order_dt)!=8 then null
			else cast(cast(sls_order_dt as varchar)as Date)
		 end as sls_order_dt,
		 case 
			when sls_ship_dt = 0 or len(sls_ship_dt)!=8 then null
			 else cast(cast(sls_ship_dt as varchar)as Date)
		 end as sls_ship_dt,
		 case 
			when sls_due_dt = 0 or len(sls_due_dt)!=8 then null
			else cast(cast(sls_due_dt as varchar)as Date)
		 end as sls_due_dt,
		 case 
			when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
			then sls_quantity * abs(sls_price)
			else sls_sales
		end as sls_sales,
		 sls_quantity,
		 case 
			when sls_price is null or sls_price <=0
			then sls_sales / nullif(sls_quantity,0)
			else sls_price
		 end as sls_price
	 from bronze.crm_sales_info
	 set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

		Print '---------------------------------------------';
		Print 'Loading ERP Tables';
		Print '---------------------------------------------';

	set @start_time = getdate();
	print '>> Truncating Table: silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	print '>> inserting data into: silver.erp_cust_az12';
	 Insert into silver.erp_cust_az12 (
		 cid,
		 bdate,
		 gender
	 )
	 select 
			case when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid
			end as cid,
			case when bdate > getdate() then null
			 else bdate
			 end as bdate,
			case when upper(trim(gender)) in('F','Female') then 'Female'
			 when upper(trim(gender)) in('M','Male') then 'Male'
			 else 'Unknown'
		end as gender
	from bronze.erp_cust_az12
	set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'
	
	set @start_time = getdate();
	print '>> Truncating Table: silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;
	print '>> inserting data into: silver.erp_loc_a101';
	insert into silver.erp_loc_a101(
		cid,
		country
	)
	select 
		replace(cid,'-','') cid,
		case 
			when trim(country) in ('US','USA') then 'United States'
			when trim(country) = 'DE' then 'Germany'
			when trim(country) = '' or country is null then 'unknown'
			else trim(country)
		end as country
	from bronze.erp_loc_a101
	set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'

	set @start_time = getdate();
	print '>> Truncating Table: silver.erp_px_cat';
	truncate table silver.erp_px_cat;
	print '>> inserting data into: silver.erp_px_cat';
	insert into silver.erp_px_cat(
		id,
		category,
		sub_category,
		maintenance
	)
	select 
		id,
		category,
		sub_category,
		maintenance
	from bronze.erp_px_cat
	set @end_time = getdate();
		print '>> Load Duration:' + cast(DATEDIFF(second, @start_time,@end_time) as nvarchar) + 'Seconds';
		print '>>--------------------------------------'
		set @batch_end_time = getdate();
		print '====================================================='
		print 'Loading Silver Layer is Completed'
		print ' -Total Load Duration:' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) as nvarchar) + 'Seconds';
	End Try
	Begin Catch
		print '============================================================'
		print ' error occured while loading Silver Layer';
		print '============================================================'
		print 'ErrorMessage'+ error_message();
		Print 'ErrorMessage' + cast(Error_number() as varchar(50));
		Print 'ErrorMessage' + cast(Error_state() as varchar(50));
	End Catch
End
