package com.cybershield.util;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

/**
 * Minimal SMTP client over implicit SSL (port 465, the Gmail default) with
 * AUTH LOGIN and a single MIME multipart/mixed message (plain-text body +
 * one binary attachment). No external mail library required - this talks
 * raw SMTP directly over a socket, since this project has no reliable way
 * to fetch third-party binary jars (jakarta.mail / javax.mail) into
 * WEB-INF/lib.
 *
 * This is intentionally scoped to what CyberShield needs (one attachment,
 * one recipient) - it is not a general-purpose mail client.
 */
public class SimpleSmtpMailer {

    private final String host;
    private final int port;
    private final String username;
    private final String password;
    private final String fromName;

    public SimpleSmtpMailer(String host, int port, String username, String password, String fromName) {
        this.host = host;
        this.port = port;
        this.username = username;
        this.password = password;
        this.fromName = fromName;
    }

    public static class SmtpException extends Exception {
        public SmtpException(String message) { super(message); }
        public SmtpException(String message, Throwable cause) { super(message, cause); }
    }

    public void sendWithAttachment(String toEmail, String subject, String bodyText,
                                    byte[] attachmentBytes, String attachmentFilename, String attachmentMimeType)
            throws SmtpException {

        SSLSocketFactory factory = (SSLSocketFactory) SSLSocketFactory.getDefault();

        try (SSLSocket socket = (SSLSocket) factory.createSocket(host, port)) {
            socket.setSoTimeout(15000);

            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
            OutputStream rawOut = socket.getOutputStream();

            readResponse(in, "220"); // server greeting

            sendCommand(rawOut, "EHLO cybershield.local");
            readResponse(in, "250");

            sendCommand(rawOut, "AUTH LOGIN");
            readResponse(in, "334");

            sendCommand(rawOut, Base64.getEncoder().encodeToString(username.getBytes(StandardCharsets.UTF_8)));
            readResponse(in, "334");

            sendCommand(rawOut, Base64.getEncoder().encodeToString(password.getBytes(StandardCharsets.UTF_8)));
            readResponse(in, "235"); // authentication successful

            sendCommand(rawOut, "MAIL FROM:<" + username + ">");
            readResponse(in, "250");

            sendCommand(rawOut, "RCPT TO:<" + toEmail + ">");
            readResponse(in, "250");

            sendCommand(rawOut, "DATA");
            readResponse(in, "354");

            String boundary = "----CyberShieldBoundary" + System.currentTimeMillis();
            StringBuilder msg = new StringBuilder();
            msg.append("From: ").append(fromName).append(" <").append(username).append(">\r\n");
            msg.append("To: ").append(toEmail).append("\r\n");
            msg.append("Subject: ").append(subject).append("\r\n");
            msg.append("MIME-Version: 1.0\r\n");
            msg.append("Content-Type: multipart/mixed; boundary=\"").append(boundary).append("\"\r\n");
            msg.append("\r\n");
            msg.append("--").append(boundary).append("\r\n");
            msg.append("Content-Type: text/plain; charset=UTF-8\r\n");
            msg.append("Content-Transfer-Encoding: 7bit\r\n\r\n");
            // Dot-stuff any line that starts with a lone '.' per RFC 5321
            msg.append(dotStuff(bodyText)).append("\r\n\r\n");

            if (attachmentBytes != null && attachmentFilename != null) {
                msg.append("--").append(boundary).append("\r\n");
                msg.append("Content-Type: ").append(attachmentMimeType).append("; name=\"").append(attachmentFilename).append("\"\r\n");
                msg.append("Content-Transfer-Encoding: base64\r\n");
                msg.append("Content-Disposition: attachment; filename=\"").append(attachmentFilename).append("\"\r\n\r\n");
                msg.append(base64Wrapped(attachmentBytes)).append("\r\n\r\n");
            }

            msg.append("--").append(boundary).append("--\r\n");
            msg.append(".\r\n");

            rawOut.write(msg.toString().getBytes(StandardCharsets.UTF_8));
            rawOut.flush();
            readResponse(in, "250"); // message accepted

            sendCommand(rawOut, "QUIT");

        } catch (IOException e) {
            throw new SmtpException("SMTP connection failed: " + e.getMessage(), e);
        }
    }

    private String dotStuff(String text) {
        if (text == null) return "";
        StringBuilder sb = new StringBuilder();
        for (String line : text.split("\n", -1)) {
            if (line.startsWith(".")) sb.append(".");
            sb.append(line).append("\r\n");
        }
        return sb.toString();
    }

    private String base64Wrapped(byte[] data) {
        String encoded = Base64.getEncoder().encodeToString(data);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < encoded.length(); i += 76) {
            sb.append(encoded, i, Math.min(i + 76, encoded.length())).append("\r\n");
        }
        return sb.toString();
    }

    private void sendCommand(OutputStream out, String command) throws IOException {
        out.write((command + "\r\n").getBytes(StandardCharsets.UTF_8));
        out.flush();
    }

    private void readResponse(BufferedReader in, String expectedCode) throws IOException, SmtpException {
        String line;
        String lastLine = null;
        while ((line = in.readLine()) != null) {
            lastLine = line;
            // Multi-line SMTP responses use "code-text"; the final line uses "code text"
            if (line.length() >= 4 && line.charAt(3) == ' ') break;
        }
        if (lastLine == null || !lastLine.startsWith(expectedCode)) {
            throw new SmtpException("Unexpected SMTP response (expected " + expectedCode + "): " + lastLine);
        }
    }
}
