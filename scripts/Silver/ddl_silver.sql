/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
if object_id ('silver.crm_cust_info','u') is not null
	drop table silver.crm_cust_info;
create table silver.crm_cust_info (
	cst_id int,
	cst_key varchar(100),
	cst_firstname varchar (100),
	cst_lastname varchar (100),
	cst_marital_status varchar(50),
	cst_gender varchar(50),
	cst_create_date date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.crm_prd_info','u') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id int,
	cat_id varchar(100),
	prd_key varchar(100),
	prd_name varchar(100),
	prd_cost int,
	prd_line varchar (50),
	prd_start_date date,
	prd_end_date date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.crm_sales_info','u') is not null
	drop table silver.crm_sales_info;
create table silver.crm_sales_info (
	sls_order_num varchar (100),
	sls_prd_key varchar (100),
	sls_cst_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.erp_cust_az12','u') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12 (
	cid varchar (100),
	bdate date,
	gender varchar (50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.erp_loc_a101','u') is not null
	drop table silver.erp_loc_a101;
create table silver.erp_loc_a101 (
	cid varchar (100),
	country varchar (50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if object_id ('silver.erp_px_cat','u') is not null
	drop table silver.erp_px_cat;
create table silver.erp_px_cat (
	id varchar (50),
	category varchar (100),
	sub_category varchar (100),
	maintenance varchar (50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
