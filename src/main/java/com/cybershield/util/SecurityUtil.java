package com.cybershield.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SecurityUtil {

    /**
     * Checks if the CSRF token in the request matches the session CSRF token.
     * @param req HttpServletRequest
     * @return true if valid, false otherwise
     */
    public static boolean verifyCsrfToken(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = req.getParameter("csrfToken");
        return sessionToken != null && sessionToken.equals(requestToken);
    }

    /**
     * Escapes HTML tags and characters to prevent XSS attacks.
     * @param input Raw text string
     * @return Escaped HTML string
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }

    /**
     * Escapes fields for CSV output, replacing quotes and commas.
     * @param input Raw string
     * @return CSV formatted field
     */
    public static String escapeCsv(String input) {
        if (input == null) return "";
        String clean = input.replace("\"", "\"\"");
        if (clean.contains(",") || clean.contains("\n") || clean.contains("\r") || clean.contains("\"")) {
            return "\"" + clean + "\"";
        }
        return clean;
    }
}
