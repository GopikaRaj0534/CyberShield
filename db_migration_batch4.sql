-- =====================================================================
-- CyberShield - Batch 4 Feature Migration
-- Run this AFTER db_migration_batch1/2/3.sql.
-- Adds: Investigation Officer role and case-assignment workflow.
-- No change is needed to USERS.ROLE itself (it's a free VARCHAR2) - the
-- new role value is simply 'INVESTIGATOR', alongside existing 'USER' and
-- 'ADMIN' values.
-- =====================================================================

ALTER TABLE COMPLAINTS ADD ASSIGNED_INVESTIGATOR_ID NUMBER;
ALTER TABLE COMPLAINTS ADD CONSTRAINT FK_COMPLAINTS_INVESTIGATOR
    FOREIGN KEY (ASSIGNED_INVESTIGATOR_ID) REFERENCES USERS(USER_ID);

-- The investigator's own findings, kept separate from the admin's REMARKS
-- field so it's clear who wrote what.
ALTER TABLE COMPLAINTS ADD INVESTIGATION_REPORT VARCHAR2(4000);
ALTER TABLE COMPLAINTS ADD INVESTIGATION_EVIDENCE_PATH VARCHAR2(1000);
ALTER TABLE COMPLAINTS ADD INVESTIGATION_SUBMITTED_AT TIMESTAMP(6);

CREATE INDEX IDX_COMPLAINTS_INVESTIGATOR ON COMPLAINTS(ASSIGNED_INVESTIGATOR_ID);
