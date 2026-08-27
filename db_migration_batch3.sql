-- =====================================================================
-- CyberShield - Batch 3 Feature Migration
-- Run this AFTER db_migration_batch1.sql and db_migration_batch2.sql.
-- Adds: UPI ID / bank account capture on complaints (for the Money-Trail
--       Visualizer). AI-Guided Complaint Intake Assistant and the
--       Malayalam-English NLP layer need no schema changes - they work
--       entirely client-side (intake wizard) and inside the existing
--       Python AI layer (language normalization).
-- =====================================================================

ALTER TABLE COMPLAINTS ADD SUSPECT_UPI_ID VARCHAR2(100);
ALTER TABLE COMPLAINTS ADD SUSPECT_BANK_ACCOUNT VARCHAR2(50);
