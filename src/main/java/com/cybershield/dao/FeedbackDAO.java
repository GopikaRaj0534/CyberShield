package com.cybershield.dao;

import com.cybershield.model.Feedback;
import com.cybershield.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    // Insert Feedback (userId may be null for guest submissions)
    public boolean insertFeedback(Feedback f) {
        String sql = "INSERT INTO FEEDBACK (USER_ID, NAME, EMAIL, CATEGORY, RATING, MESSAGE) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (f.getUserId() != null) {
                ps.setInt(1, f.getUserId());
            } else {
                ps.setNull(1, Types.NUMERIC);
            }
            ps.setString(2, f.getName());
            ps.setString(3, f.getEmail());
            ps.setString(4, f.getCategory());
            ps.setInt(5, f.getRating());
            ps.setString(6, f.getMessage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get All Feedback (Admin) - most recent first
    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM FEEDBACK ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapFeedback(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count All Feedback entries
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM FEEDBACK";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Average rating across all feedback (0 if none yet)
    public double getAverageRating() {
        String sql = "SELECT AVG(RATING) FROM FEEDBACK";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("FEEDBACK_ID"));
        int uid = rs.getInt("USER_ID");
        f.setUserId(rs.wasNull() ? null : uid);
        f.setName(rs.getString("NAME"));
        f.setEmail(rs.getString("EMAIL"));
        f.setCategory(rs.getString("CATEGORY"));
        f.setRating(rs.getInt("RATING"));
        f.setMessage(rs.getString("MESSAGE"));
        f.setCreatedAt(rs.getTimestamp("CREATED_AT"));
        return f;
    }
}
