package com.cybershield.util;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {

    public static void main(String[] args) {

        try {

            Connection con = DBConnection.getConnection();

            if(con != null) {
                System.out.println("Connected Successfully");
            } else {
                System.out.println("Connection Failed");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}