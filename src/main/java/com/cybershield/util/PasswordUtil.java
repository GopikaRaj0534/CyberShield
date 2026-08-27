package com.cybershield.util;

public class PasswordUtil {

    /**
     * Returns the password as plain text.
     *
     * NOTE:
     * This is suitable only for a local/college demo project.
     * Do NOT use plain-text passwords in a real production application.
     *
     * @param password Plain password entered by the user
     * @return Same password without hashing
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }

        return password;
    }
}