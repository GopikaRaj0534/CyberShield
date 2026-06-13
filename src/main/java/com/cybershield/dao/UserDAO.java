package com.cybershield.dao;

import com.cybershield.model.User;
import com.cybershield.util.DBConnection;

import java.sql.*;

public class UserDAO {

	public boolean insertUser(User user) {
	    String sql = "INSERT INTO USERS (NAME, EMAIL, PASSWORD, ROLE) VALUES (?, ?, ?, ?)";

	    Connection con = null;
	    PreparedStatement ps = null;

	    try {
	        con = DBConnection.getConnection();
	        ps = con.prepareStatement(sql);
	        ps.setString(1, user.getName());
	        ps.setString(2, user.getEmail());
	        ps.setString(3, user.getPassword());
	        ps.setString(4, user.getRole());

	        int rows = ps.executeUpdate();
	        System.out.println("Rows inserted: " + rows);
	        return rows > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        try { if (ps  != null) ps.close(); } catch (Exception e) {}
	        try { if (con != null) con.close(); } catch (Exception e) {}
	    }
	}

    public User getUserByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM USERS WHERE EMAIL = ? AND PASSWORD = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("USER_ID"));
                u.setName(rs.getString("NAME"));
                u.setEmail(rs.getString("EMAIL"));
                u.setRole(rs.getString("ROLE"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM USERS WHERE EMAIL = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}