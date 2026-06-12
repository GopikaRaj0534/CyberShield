package com.cybershield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.cybershield.model.User;
import com.cybershield.util.DBConnection;

public class UserDAO {

    public boolean insertUser(User user) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO users(name,email,password,role) VALUES(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());

            int rows = ps.executeUpdate();

            if(rows > 0) {
                status = true;
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}
