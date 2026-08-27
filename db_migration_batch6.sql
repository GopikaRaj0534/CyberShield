-- =====================================================================
-- CyberShield - Batch 6 Feature Migration
-- Run this AFTER db_migration_batch1/2/3/4/5.sql.
-- Adds: PHONE column on USERS so investigation officers can see a
-- contact number for the citizen who filed the complaint they're
-- working on.
-- =====================================================================

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'USERS' AND COLUMN_NAME = 'PHONE';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE USERS ADD PHONE VARCHAR2(20)';
    END IF;
END;
/
