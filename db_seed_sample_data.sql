-- =====================================================================
-- CyberShield - Sample Seed Data (OPTIONAL, for demo/testing only)
-- Run this AFTER the base schema and all three db_migration_batch*.sql
-- scripts. Populates a handful of demo citizens, complaints spanning all
-- three categories/districts/risk levels, suspects, corroborations, and
-- feedback - so the Daily Digest, District Bulletin, and Money-Trail
-- Visualizer have something real to show instead of empty zeros.
--
-- All demo accounts use plain-text passwords (the login check accepts
-- either plain-text or the SHA-256 hash, so these work as-is). Delete
-- this data before a real deployment - it is clearly demo-only.
-- =====================================================================

-- Demo citizen accounts (password = 'Demo@1234' for all)
INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES ('Anjali Menon', 'anjali.demo@example.com', 'Demo@1234', 'USER');
INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES ('Arun Nair', 'arun.demo@example.com', 'Demo@1234', 'USER');
INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES ('Fathima Beevi', 'fathima.demo@example.com', 'Demo@1234', 'USER');
INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES ('Vishnu Prasad', 'vishnu.demo@example.com', 'Demo@1234', 'USER');
INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES ('Devika Suresh', 'devika.demo@example.com', 'Demo@1234', 'USER');

-- Grab the demo user IDs just inserted (adjust if your USERS table already has rows)
-- The subqueries below look up by email so this script is safe to run even if
-- USER_ID numbering differs from a fresh install.

-- Financial Fraud complaints (Ernakulam) - two share the same UPI ID, for the Money-Trail Visualizer
INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, SUSPECT_UPI_ID, SUSPECT_BANK_ACCOUNT, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='anjali.demo@example.com'), 'Financial Fraud', 'UPI / Payment Fraud',
'Received a fake collect request pretending to be a refund from an online store. I approved it thinking it would give me money, and 4500 rupees was deducted instead.',
'Ernakulam', NULL, NULL, 'quickrefund@upi', NULL, 'NO', 'HIGH', 'Pending', 'NLP analyzed crime description and categorized it as HIGH risk', SYSTIMESTAMP - INTERVAL '1' DAY);

INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, SUSPECT_UPI_ID, SUSPECT_BANK_ACCOUNT, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='arun.demo@example.com'), 'Financial Fraud', 'UPI / Payment Fraud',
'Same UPI collect request scam - someone messaged claiming to be a delivery agent asking me to accept a payment request to release my parcel. Lost 2200 rupees.',
'Ernakulam', NULL, NULL, 'quickrefund@upi', '622010012345', 'NO', 'HIGH', 'Under Investigation', 'NLP analyzed crime description and categorized it as HIGH risk', SYSTIMESTAMP - INTERVAL '2' DAY);

INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, SUSPECT_UPI_ID, SUSPECT_BANK_ACCOUNT, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='fathima.demo@example.com'), 'Financial Fraud', 'OTP Fraud',
'A caller claiming to be from my bank asked for the OTP sent to my phone to "verify" a suspicious transaction. I shared it and 15000 rupees was withdrawn.',
'Thiruvananthapuram', NULL, NULL, NULL, '622010012345', 'NO', 'HIGH', 'Pending', 'NLP analyzed crime description and categorized it as HIGH risk', SYSTIMESTAMP - INTERVAL '3' DAY);

-- Financial Fraud - loan app harassment (Kozhikode)
INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='vishnu.demo@example.com'), 'Financial Fraud', 'Loan App Harassment',
'Took a small loan from an app and now getting threatening calls and messages to my contacts even though I am paying on time.',
'Kozhikode', 'https://quick-loan-approve.com', NULL, 'NO', 'MEDIUM', 'Pending', 'NLP analyzed crime description and categorized it as MEDIUM risk', SYSTIMESTAMP - INTERVAL '4' DAY);

-- Women & Child Related Crime (Thrissur, Kollam)
INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='devika.demo@example.com'), 'Women & Child Related Crime', 'Cyberstalking / Harassment of Women',
'A stranger has been repeatedly messaging me on Instagram after I declined to respond, and created a second account to continue after I blocked the first.',
'Thrissur', NULL, NULL, 'YES', 'MEDIUM', 'Pending', 'NLP analyzed crime description and categorized it as MEDIUM risk', SYSTIMESTAMP - INTERVAL '2' DAY);

INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='anjali.demo@example.com'), 'Women & Child Related Crime', 'Online Sextortion',
'My younger cousin was contacted by a stranger online who obtained a photo and is now demanding money to not share it further. Reporting on their behalf.',
'Kollam', NULL, NULL, 'YES', 'HIGH', 'Under Investigation', 'NLP analyzed crime description and categorized it as HIGH risk', SYSTIMESTAMP - INTERVAL '5' DAY);

-- Other Cybercrime (Kannur, Malappuram, Ernakulam)
INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='arun.demo@example.com'), 'Other Cybercrime', 'Phishing',
'Received an SMS with a link claiming my bank account would be blocked unless I "re-verify" my details immediately by clicking the link.',
'Kannur', 'https://sbi-verify-account-now.com', NULL, 'NO', 'HIGH', 'Pending', 'NLP analyzed crime description and categorized it as HIGH risk', SYSTIMESTAMP - INTERVAL '1' DAY);

INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='fathima.demo@example.com'), 'Other Cybercrime', 'Job / Lottery Scam',
'Got a WhatsApp message saying I won a lottery from a company I never entered, asking for a processing fee to release the prize.',
'Malappuram', NULL, 'prizeteam@fake-lottery.com', 'NO', 'MEDIUM', 'Resolved', 'NLP analyzed crime description and categorized it as MEDIUM risk', SYSTIMESTAMP - INTERVAL '6' DAY);

INSERT INTO COMPLAINTS (USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, ANONYMOUS, RISK_LEVEL, STATUS, AI_EXPLANATION, CREATED_AT)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='vishnu.demo@example.com'), 'Other Cybercrime', 'Account Hacking',
'My email account was accessed without permission and used to reset passwords on my other linked accounts.',
'Ernakulam', NULL, NULL, 'NO', 'LOW', 'Resolved', 'NLP analyzed crime description and categorized it as LOW risk', SYSTIMESTAMP - INTERVAL '8' DAY);

-- Suspect Repository seed data
INSERT INTO SUSPECTS (IDENTIFIER_TYPE, IDENTIFIER_VALUE, PLATFORM, REPORT_COUNT, STATUS) VALUES ('URL', 'sbi-verify-account-now.com', 'SMS', 3, 'ACTIVE');
INSERT INTO SUSPECTS (IDENTIFIER_TYPE, IDENTIFIER_VALUE, PLATFORM, REPORT_COUNT, STATUS) VALUES ('EMAIL', 'prizeteam@fake-lottery.com', 'WhatsApp', 2, 'ACTIVE');
INSERT INTO SUSPECTS (IDENTIFIER_TYPE, IDENTIFIER_VALUE, PLATFORM, REPORT_COUNT, STATUS) VALUES ('MOBILE', '+919876500000', 'Phone call', 4, 'ACTIVE');

INSERT INTO SUSPECT_REPORTS (SUSPECT_ID, USER_ID, REPORT_CATEGORY, PLATFORM, DETAILS)
VALUES ((SELECT SUSPECT_ID FROM SUSPECTS WHERE IDENTIFIER_VALUE='sbi-verify-account-now.com'), (SELECT USER_ID FROM USERS WHERE EMAIL='arun.demo@example.com'), 'Phishing Attempt', 'SMS', 'Sent a fake bank verification link.');
INSERT INTO SUSPECT_REPORTS (SUSPECT_ID, USER_ID, REPORT_CATEGORY, PLATFORM, DETAILS)
VALUES ((SELECT SUSPECT_ID FROM SUSPECTS WHERE IDENTIFIER_VALUE='+919876500000'), (SELECT USER_ID FROM USERS WHERE EMAIL='devika.demo@example.com'), 'Scam Call / SMS', 'Phone call', 'Claimed to be a bank official asking for OTP.');

-- Community corroborations ("I got this too")
INSERT INTO SUSPECT_CORROBORATIONS (SUSPECT_ID, USER_ID) VALUES ((SELECT SUSPECT_ID FROM SUSPECTS WHERE IDENTIFIER_VALUE='sbi-verify-account-now.com'), (SELECT USER_ID FROM USERS WHERE EMAIL='fathima.demo@example.com'));
INSERT INTO SUSPECT_CORROBORATIONS (SUSPECT_ID, USER_ID) VALUES ((SELECT SUSPECT_ID FROM SUSPECTS WHERE IDENTIFIER_VALUE='sbi-verify-account-now.com'), (SELECT USER_ID FROM USERS WHERE EMAIL='vishnu.demo@example.com'));
INSERT INTO SUSPECT_CORROBORATIONS (SUSPECT_ID, USER_ID) VALUES ((SELECT SUSPECT_ID FROM SUSPECTS WHERE IDENTIFIER_VALUE='+919876500000'), (SELECT USER_ID FROM USERS WHERE EMAIL='anjali.demo@example.com'));

-- Sample feedback
INSERT INTO FEEDBACK (USER_ID, NAME, EMAIL, CATEGORY, RATING, MESSAGE)
VALUES ((SELECT USER_ID FROM USERS WHERE EMAIL='anjali.demo@example.com'), 'Anjali Menon', 'anjali.demo@example.com', 'General Experience', 5, 'Filing my complaint was quick and the guided assistant made it easy to explain what happened.');
INSERT INTO FEEDBACK (USER_ID, NAME, EMAIL, CATEGORY, RATING, MESSAGE)
VALUES (NULL, 'Guest Visitor', 'guest.demo@example.com', 'Suspect Repository', 4, 'Checked a suspicious link before paying and it was already flagged - very useful.');

COMMIT;
