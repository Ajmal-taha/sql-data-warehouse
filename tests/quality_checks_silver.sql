/*
==================================================
QUALITY CHECKS FOR crm_cust_info
==================================================
*/

-- Check For Nulls or Duplicates in Primary Key
-- Expectations: No Result
SELECT
cst_id,
COUNT(*) AS COUNTS
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;
;

-- Check for unwanted spaces
-- Expectations: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info


/*
==================================================
QUALITY CHECKS FOR crm_prod_info
==================================================
*/

-- Check For Nulls or Duplicates in Primary Key
-- Expectations: No Result
SELECT
prd_id,
COUNT(*) AS COUNTS
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
;

-- Check for unwanted spaces
-- Expectations: No Result
SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT prd_start_dt, prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

/*
==================================================
QUALITY CHECKS FOR crm_sales_details
==================================================
*/

-- Check for Invalid Dates

SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101
;

SELECT 
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101
;

SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101
;

-- Check for Invalid Date Orders

SELECT
sls_order_dt,
sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
;

SELECT
sls_order_dt,
sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt
;

-- Check Data Consistency: Between Sales, Quantity and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero or negative

SELECT
sls_sales,
sls_price,
sls_quantity
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS  NULL
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
;

/*
==================================================
QUALITY CHECKS FOR erp_cust_az12
==================================================
*/

-- Verify if all the cid exists in crm_cust_info
SELECT 
cid,
CASE WHEN cid LIKE 'NAS%' 
		THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid_new
FROM silver.erp_cust_az12
;

SELECT 
cid
FROM silver.erp_cust_az12
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)
;


SELECT 
*
FROM 
(
	SELECT 
	cid,
	CASE WHEN cid LIKE 'NAS%' 
			THEN SUBSTRING(cid, 4, LEN(cid))
		ELSE cid
	END AS cid_new
	FROM silver.erp_cust_az12
) t
WHERE cid_new NOT IN (SELECT cst_key FROM silver.crm_cust_info)
;

-- Identify Out-Of_range Dates

SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > GETDATE()
;

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

/*
==================================================
QUALITY CHECKS FOR erp_loc_a101
==================================================
*/

SELECT
REPLACE(cid, '-', '') AS cid,
cntry
FROM silver.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info)
;

-- Data Standardization & Consistency

SELECT
DISTINCT(cntry)
FROM silver.erp_loc_a101
ORDER BY cntry
;

/*
==================================================
QUALITY CHECKS FOR erp_px_cat_g1v2
==================================================
*/

-- Check for unwanted spaces
SELECT 
*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)
;

-- Data standardization & Consistency
SELECT DISTINCT
cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT
subcat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT
maintenance
FROM silver.erp_px_cat_g1v2
