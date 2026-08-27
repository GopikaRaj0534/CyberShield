package com.cybershield.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.io.InputStream;

/**
 * Loads WEB-INF/config.properties at application startup so ConfigUtil
 * picks up deployment-specific settings.
 */
@WebListener
public class ConfigContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (InputStream in = sce.getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (in != null) {
                ConfigUtil.loadFromServletContext(in);
            }
        } catch (Exception e) {
            System.err.println("[ConfigContextListener] " + e.getMessage());
        }
    }
}
