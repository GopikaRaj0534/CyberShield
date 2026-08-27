-- CyberShield authentication setup
-- Run this once in SQL*Plus after the USERS table already exists.
-- This script keeps existing USERS rows and assigns them the USER role.

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'USERS' AND COLUMN_NAME = 'ROLE';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE USERS ADD ROLE VARCHAR2(20)';
    END IF;
END;
/

UPDATE USERS SET ROLE = 'USER' WHERE ROLE IS NULL;
COMMIT;

-- Make the role mandatory with USER as the default for normal registrations.
ALTER TABLE USERS MODIFY ROLE VARCHAR2(20) DEFAULT 'USER' NOT NULL;

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'USERS' AND CONSTRAINT_NAME = 'CHK_USERS_ROLE';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE q'[ALTER TABLE USERS ADD CONSTRAINT CHK_USERS_ROLE CHECK (ROLE IN ('USER','ADMIN','INVESTIGATOR'))]';
    END IF;
END;
/

-- Admin accounts have NO public registration page.
-- Create an administrator directly in SQL*Plus when needed.
-- Change the email/password before real deployment.
MERGE INTO USERS u
USING (
    SELECT 'System Admin' NAME,
           'admin@cybershield.local' EMAIL,
           'Admin@1234' PASSWORD,
           'ADMIN' ROLE
    FROM dual
) a
ON (LOWER(u.EMAIL) = LOWER(a.EMAIL))
WHEN MATCHED THEN
    UPDATE SET u.NAME = a.NAME, u.PASSWORD = a.PASSWORD, u.ROLE = a.ROLE
WHEN NOT MATCHED THEN
    INSERT (NAME, EMAIL, PASSWORD, ROLE)
    VALUES (a.NAME, a.EMAIL, a.PASSWORD, a.ROLE);

COMMIT;

SELECT USER_ID, NAME, EMAIL, ROLE FROM USERS ORDER BY USER_ID;
