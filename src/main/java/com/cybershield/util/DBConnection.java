package com.cybershield.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        Connection con = null;

        try {

            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "system",
                    "root");

            System.out.println("Database Connected Successfully");

        } catch (Exception e) {

            e.printStackTrace();

        }

        return con;
    }
}
