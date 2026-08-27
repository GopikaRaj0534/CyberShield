package com.cybershield.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class EmailService {

    private static String logFilePath() {
        return ConfigUtil.get("email.log.file",
                System.getProperty("user.dir") + "/mock_emails.log");
    }
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * Simulates sending an email notification and logs it.
     * @param to Recipient email
     * @param subject Email subject
     * @param body Email content
     */
    public static void sendEmail(String to, String subject, String body) {
        sendEmailWithAttachment(to, subject, body, null, null);
    }

    /**
     * Sends an email, optionally with a PDF (or other binary) attachment.
     *
     * If mail.smtp.host / mail.smtp.username / mail.smtp.password are
     * configured in config.properties, this attempts real delivery via
     * {@link SimpleSmtpMailer}. If those are blank, OR the real send fails
     * for any reason (bad credentials, no network, etc.), it falls back to
     * the existing mock-log behaviour so complaint submission is never
     * blocked by email problems - and, when there's an attachment, also
     * saves it to disk so the generated PDF can still be inspected.
     */
    public static void sendEmailWithAttachment(String to, String subject, String body,
                                                byte[] attachmentBytes, String attachmentFilename) {
        String timestamp = sdf.format(new Timestamp(System.currentTimeMillis()));

        String smtpHost = ConfigUtil.get("mail.smtp.host", "");
        String smtpUser = ConfigUtil.get("mail.smtp.username", "");
        String smtpPass = ConfigUtil.get("mail.smtp.password", "");
        String smtpFromName = ConfigUtil.get("mail.smtp.fromName", "CyberShield");
        int smtpPort = 465;
        try {
            smtpPort = Integer.parseInt(ConfigUtil.get("mail.smtp.port", "465"));
        } catch (NumberFormatException ignored) { /* keep default */ }

        boolean smtpConfigured = smtpHost != null && !smtpHost.isEmpty()
                && smtpUser != null && !smtpUser.isEmpty()
                && smtpPass != null && !smtpPass.isEmpty();

        boolean realSendSucceeded = false;

        if (smtpConfigured) {
            try {
                SimpleSmtpMailer mailer = new SimpleSmtpMailer(smtpHost, smtpPort, smtpUser, smtpPass, smtpFromName);
                mailer.sendWithAttachment(to, subject, body, attachmentBytes, attachmentFilename, "application/pdf");
                realSendSucceeded = true;
                System.out.println("[EmailService] Real email sent to " + to + " via " + smtpHost);
            } catch (Exception e) {
                System.err.println("[EmailService] Real SMTP send failed, falling back to mock log: " + e.getMessage());
            }
        }

        System.out.println("====== " + (realSendSucceeded ? "EMAIL SENT" : "SIMULATING EMAIL") + " ======");
        System.out.println("TIME   : " + timestamp);
        System.out.println("TO     : " + to);
        System.out.println("SUBJECT: " + subject);
        System.out.println("BODY   : \n" + body);
        System.out.println("===================================");

        String savedAttachmentPath = null;
        if (!realSendSucceeded && attachmentBytes != null && attachmentFilename != null) {
            savedAttachmentPath = saveAttachmentToDisk(attachmentBytes, attachmentFilename);
        }

        try (FileWriter fw = new FileWriter(logFilePath(), true);
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {

            out.println("========================================================================");
            out.println("NOTIFICATION DISPATCH LOG");
            out.println("========================================================================");
            out.println("Timestamp: " + timestamp);
            out.println("Mode     : " + (realSendSucceeded ? "REAL SMTP DELIVERY (" + smtpHost + ")" : "MOCK (SMTP not configured or send failed)"));
            out.println("Recipient: " + to);
            out.println("Subject  : " + subject);
            if (savedAttachmentPath != null) {
                out.println("Attachment saved to: " + savedAttachmentPath);
            }
            out.println("Message  :");
            out.println(body);
            out.println("========================================================================");
            out.println();

        } catch (IOException e) {
            System.err.println("Error writing to mock_emails.log: " + e.getMessage());
        }
    }

    private static String saveAttachmentToDisk(byte[] bytes, String filename) {
        try {
            String dir = System.getProperty("user.dir") + File.separator + "mock_email_attachments";
            File dirFile = new File(dir);
            if (!dirFile.exists()) dirFile.mkdirs();

            String path = dir + File.separator + filename;
            try (FileOutputStream fos = new FileOutputStream(path)) {
                fos.write(bytes);
            }
            return path;
        } catch (IOException e) {
            System.err.println("[EmailService] Failed to save attachment to disk: " + e.getMessage());
            return null;
        }
    }
}
