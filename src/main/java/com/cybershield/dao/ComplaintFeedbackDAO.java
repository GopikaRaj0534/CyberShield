package com.cybershield.dao;

import com.cybershield.model.ComplaintFeedback;
import com.cybershield.util.DBConnection;

import java.sql.*;

public class ComplaintFeedbackDAO {

    public boolean insert(ComplaintFeedback f) {
        String sql = "INSERT INTO COMPLAINT_FEEDBACK (COMPLAINT_ID, USER_ID, RATING, COMMENTS) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, f.getComplaintId());
            ps.setInt(2, f.getUserId());
            ps.setInt(3, f.getRating());
            ps.setString(4, f.getComments());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ComplaintFeedback getByComplaintId(int complaintId) {
        String sql = "SELECT * FROM COMPLAINT_FEEDBACK WHERE COMPLAINT_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapFeedback(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Average citizen rating for cases handled by a given investigator
    public double getAverageRatingForInvestigator(int investigatorId) {
        String sql = "SELECT AVG(cf.RATING) FROM COMPLAINT_FEEDBACK cf "
                   + "JOIN COMPLAINTS c ON cf.COMPLAINT_ID = c.COMPLAINT_ID "
                   + "WHERE c.ASSIGNED_INVESTIGATOR_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, investigatorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // How many rated cases a given investigator has (so admin can tell a 5.0 average
    // from one rating apart from a 5.0 average from twenty)
    public int getRatedCaseCountForInvestigator(int investigatorId) {
        String sql = "SELECT COUNT(*) FROM COMPLAINT_FEEDBACK cf "
                   + "JOIN COMPLAINTS c ON cf.COMPLAINT_ID = c.COMPLAINT_ID "
                   + "WHERE c.ASSIGNED_INVESTIGATOR_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, investigatorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ComplaintFeedback mapFeedback(ResultSet rs) throws SQLException {
        ComplaintFeedback f = new ComplaintFeedback();
        f.setComplaintFeedbackId(rs.getInt("COMPLAINT_FEEDBACK_ID"));
        f.setComplaintId(rs.getInt("COMPLAINT_ID"));
        f.setUserId(rs.getInt("USER_ID"));
        f.setRating(rs.getInt("RATING"));
        f.setComments(rs.getString("COMMENTS"));
        f.setCreatedAt(rs.getTimestamp("CREATED_AT"));
        return f;
    }
}
