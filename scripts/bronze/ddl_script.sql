/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
if object_id ('bronze.crm_cust_info','u') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info (
	cst_id int,
	cst_key varchar(100),
	cst_firstname varchar (100),
	cst_lastname varchar (100),
	cst_marital_status varchar(50),
	cst_gender varchar(50),
	cst_create_date date
);

if object_id ('bronze.crm_prd_info','u') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info (
	prd_id int,
	prd_key varchar(100),
	prd_name varchar(100),
	prd_cost int,
	prd_line varchar (50),
	prd_start_date date,
	prd_end_date date
);

if object_id ('bronze.crm_sales_info','u') is not null
	drop table bronze.crm_sales_info;
create table bronze.crm_sales_info (
	sls_order_num varchar (100),
	sls_prd_key varchar (100),
	sls_cst_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

if object_id ('bronze.erp_cust_az12','u') is not null
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12 (
	cid varchar (100),
	bdate date,
	gender varchar (50)
);

if object_id ('bronze.erp_loc_a101','u') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101 (
	cid varchar (100),
	country varchar (50)
);

if object_id ('bronze.erp_px_cat','u') is not null
	drop table bronze.erp_px_cat;
create table bronze.erp_px_cat (
	id varchar (50),
	category varchar (100),
	sub_category varchar (100),
	maintenance varchar (50)
);
