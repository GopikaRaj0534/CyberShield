package com.cybershield.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(
                ConfigUtil.get("db.url"),
                ConfigUtil.get("db.user"),
                ConfigUtil.get("db.password")
        );
    }
}