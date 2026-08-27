package com.cybershield.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Loads application configuration from WEB-INF/config.properties with safe defaults.
 */
public final class ConfigUtil {

    private static final Properties PROPS = new Properties();

    static {
        loadConfiguration();
    }

    private ConfigUtil() {}

    private static void loadConfiguration() {
        /* Defaults preserve existing behaviour if config file is missing */
        PROPS.setProperty("db.url", "jdbc:oracle:thin:@localhost:1521:XE");
        PROPS.setProperty("db.user", "SYSTEM");
        PROPS.setProperty("db.password", "root");
        PROPS.setProperty("ai.python.command", "python");
        PROPS.setProperty("ai.script.dir", System.getProperty("user.dir") + "/AI");
        PROPS.setProperty("email.log.file", System.getProperty("user.dir") + "/mock_emails.log");
        PROPS.setProperty("mail.smtp.host", "smtp.gmail.com");
        PROPS.setProperty("mail.smtp.port", "465");
        PROPS.setProperty("mail.smtp.username", "");
        PROPS.setProperty("mail.smtp.password", "");
        PROPS.setProperty("mail.smtp.fromName", "CyberShield");

        /* 1. External file via JVM property (production override) */
        String externalPath = System.getProperty("cybershield.config");
        if (externalPath != null && !externalPath.isBlank()) {
            try (InputStream in = new java.io.FileInputStream(externalPath)) {
                PROPS.load(in);
                System.out.println("[ConfigUtil] Loaded config from: " + externalPath);
                return;
            } catch (IOException e) {
                System.err.println("[ConfigUtil] Failed to load external config: " + e.getMessage());
            }
        }

        /* 2. Classpath resource (when packaged in WEB-INF/classes) */
        try (InputStream in = ConfigUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in != null) {
                PROPS.load(in);
                System.out.println("[ConfigUtil] Loaded config from classpath");
                return;
            }
        } catch (IOException e) {
            System.err.println("[ConfigUtil] Classpath config error: " + e.getMessage());
        }

        /* 3. WEB-INF/config.properties via class loader */
        try (InputStream in = ConfigUtil.class.getResourceAsStream("/../../WEB-INF/config.properties")) {
            if (in != null) {
                PROPS.load(in);
                System.out.println("[ConfigUtil] Loaded config from WEB-INF");
            }
        } catch (IOException e) {
            System.err.println("[ConfigUtil] WEB-INF config error: " + e.getMessage());
        }
    }

    /**
     * Reload config from WEB-INF using ServletContext (call from a listener if needed).
     */
    public static void loadFromServletContext(InputStream in) throws IOException {
        if (in != null) {
            PROPS.load(in);
            System.out.println("[ConfigUtil] Reloaded config from ServletContext");
        }
    }

    public static String get(String key) {
        return PROPS.getProperty(key);
    }

    public static String get(String key, String defaultValue) {
        return PROPS.getProperty(key, defaultValue);
    }
}
