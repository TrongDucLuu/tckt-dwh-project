/*
Language PgSql 
===============================================================================
Stored Function: Load Bronze Layer (Source -> Bronze) 
===============================================================================
Script Purpose:
    This stored function loads data into the 'bronze' schema from external CSV files (you should change path to your files).
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from CSV files to bronze tables.

Parameters:
    None.
    This stored function does not accept any parameters or return any values.

Usage Example:
    SELECT bronze.load_bronze();
===============================================================================
*/
CREATE OR REPLACE FUNCTION bronze.load_bronze()
RETURNS VOID AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

    -- Truncate and load crm_cust_info
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    EXECUTE 'TRUNCATE TABLE bronze.crm_cust_info';
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
    EXECUTE 'COPY bronze.crm_cust_info FROM ''/tmp/source_crm/cust_info.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    -- Truncate and load crm_prd_info
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    EXECUTE 'TRUNCATE TABLE bronze.crm_prd_info';
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
    EXECUTE 'COPY bronze.crm_prd_info FROM ''/tmp/source_crm/prd_info.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    -- Truncate and load crm_sales_details
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    EXECUTE 'TRUNCATE TABLE bronze.crm_sales_details';
    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
    EXECUTE 'COPY bronze.crm_sales_details FROM ''/tmp/source_crm/sales_details.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    -- Truncate and load erp_loc_a101
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    EXECUTE 'TRUNCATE TABLE bronze.erp_loc_a101';
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
    EXECUTE 'COPY bronze.erp_loc_a101 FROM ''/tmp/source_erp/loc_a101.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    -- Truncate and load erp_cust_az12
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    EXECUTE 'TRUNCATE TABLE bronze.erp_cust_az12';
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
    EXECUTE 'COPY bronze.erp_cust_az12 FROM ''/tmp/source_erp/cust_az12.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    -- Truncate and load erp_px_cat_g1v2
    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    EXECUTE 'TRUNCATE TABLE bronze.erp_px_cat_g1v2';
    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    EXECUTE 'COPY bronze.erp_px_cat_g1v2 FROM ''/tmp/source_erp/px_cat_g1v2.csv'' DELIMITER '','' CSV HEADER';
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', EXTRACT(EPOCH FROM (end_time - start_time))::INTEGER;
    RAISE NOTICE '>> -------------';

    batch_end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE '   - Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::INTEGER;
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE '==========================================';
        RAISE EXCEPTION 'Loading failed due to an error';
END;
$$ LANGUAGE plpgsql;