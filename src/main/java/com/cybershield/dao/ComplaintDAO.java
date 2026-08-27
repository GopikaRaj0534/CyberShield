package com.cybershield.dao;

import com.cybershield.model.Complaint;
import com.cybershield.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    // Insert Complaint
    public boolean insertComplaint(Complaint c) {
        String sql = "INSERT INTO COMPLAINTS "
                   + "(USER_ID, COMPLAINT_TYPE, SUB_TYPE, DESCRIPTION, DISTRICT, SUSPECT_URL, SUSPECT_EMAIL, SUSPECT_UPI_ID, SUSPECT_BANK_ACCOUNT, ANONYMOUS, RISK_LEVEL, STATUS, EVIDENCE_PATH, AI_EXPLANATION) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, new String[]{"COMPLAINT_ID"})) {

            ps.setInt(1, c.getUserId());
            ps.setString(2, c.getComplaintType());
            ps.setString(3, c.getSubType());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getDistrict());
            ps.setString(6, c.getSuspectUrl());
            ps.setString(7, c.getSuspectEmail());
            ps.setString(8, c.getSuspectUpiId());
            ps.setString(9, c.getSuspectBankAccount());
            ps.setString(10, c.getAnonymous());
            ps.setString(11, c.getRiskLevel());
            ps.setString(12, "Pending"); // Default status
            ps.setString(13, c.getEvidencePath());
            ps.setString(14, c.getAiExplanation());

            int rows = ps.executeUpdate();
            System.out.println("Complaint inserted rows: " + rows);

            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        c.setComplaintId(keys.getInt(1));
                    }
                }
            }
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get Complaints By User
    public List<Complaint> getComplaintsByUserId(int userId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPLAINTS WHERE USER_ID=? ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get All Complaints (Admin)
    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPLAINTS ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Update Status, Risk, Assignment, and Remarks (Admin Command)
    public boolean updateComplaint(int complaintId, String status, String riskLevel, String assignedTo, String remarks) {
        String sql = "UPDATE COMPLAINTS SET STATUS=?, RISK_LEVEL=?, ASSIGNED_TO=?, REMARKS=? WHERE COMPLAINT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, riskLevel);
            ps.setString(3, assignedTo);
            ps.setString(4, remarks);
            ps.setInt(5, complaintId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Admin hands a case over to an Investigation Officer. Keeps the existing
    // free-text ASSIGNED_TO column in sync (so the existing status-change
    // email in AdminComplaintServlet keeps working unchanged) while also
    // storing a real FK link for the investigator's own dashboard queries.
    public boolean assignInvestigator(int complaintId, int investigatorId, String investigatorName) {
        String sql = "UPDATE COMPLAINTS SET ASSIGNED_INVESTIGATOR_ID=?, ASSIGNED_TO=?, ASSIGNED_AT=CURRENT_TIMESTAMP, "
                   + "STATUS = CASE WHEN STATUS = 'Pending' THEN 'Under Investigation' ELSE STATUS END "
                   + "WHERE COMPLAINT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, investigatorId);
            ps.setString(2, investigatorName);
            ps.setInt(3, complaintId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Investigator submits their findings back - visible to both the admin and the citizen.
    public boolean submitInvestigationReport(int complaintId, String report, String evidencePath) {
        String sql = "UPDATE COMPLAINTS SET INVESTIGATION_REPORT=?, INVESTIGATION_EVIDENCE_PATH=?, "
                   + "INVESTIGATION_SUBMITTED_AT=CURRENT_TIMESTAMP WHERE COMPLAINT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, report);
            ps.setString(2, evidencePath);
            ps.setInt(3, complaintId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cases handed to a given Investigation Officer
    public List<Complaint> getComplaintsAssignedToInvestigator(int investigatorId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPLAINTS WHERE ASSIGNED_INVESTIGATOR_ID = ? ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, investigatorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAssignedToInvestigator(int investigatorId, String status) {
        String sql = "SELECT COUNT(*) FROM COMPLAINTS WHERE ASSIGNED_INVESTIGATOR_ID = ? AND STATUS = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, investigatorId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Deprecated but kept for backwards compatibility of basic updates
    public boolean updateStatus(int complaintId, String status, String riskLevel) {
        String sql = "UPDATE COMPLAINTS SET STATUS=?, RISK_LEVEL=? WHERE COMPLAINT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, riskLevel);
            ps.setInt(3, complaintId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Count User Complaints By Status
    public int countByUserAndStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM COMPLAINTS WHERE USER_ID=? AND STATUS=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Count All Complaints
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM COMPLAINTS";

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

    // Count Complaints By Status
    public int countAllByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM COMPLAINTS WHERE STATUS=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAllByRiskLevel(String riskLevel) {
        String sql = "SELECT COUNT(*) FROM COMPLAINTS WHERE RISK_LEVEL=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, riskLevel);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get complaints filed in a district within the last N days (District Safety Bulletin)
    public List<Complaint> getRecentComplaintsByDistrict(String district, int days) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPLAINTS WHERE DISTRICT = ? AND CREATED_AT >= (SYSTIMESTAMP - NUMTODSINTERVAL(?, 'DAY')) ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, district);
            ps.setInt(2, days);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Complaints that carry a UPI ID or bank account - the raw material for the Money-Trail Visualizer
    public List<Complaint> getComplaintsWithMoneyIdentifiers() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM COMPLAINTS WHERE SUSPECT_UPI_ID IS NOT NULL OR SUSPECT_BANK_ACCOUNT IS NOT NULL ORDER BY CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Distinct list of districts that have at least one complaint on file
    public List<String> getDistinctDistricts() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT DISTRICT FROM COMPLAINTS WHERE DISTRICT IS NOT NULL ORDER BY DISTRICT";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString(1));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get Complaint By ID
    public Complaint getComplaintById(int id) {
        String sql = "SELECT * FROM COMPLAINTS WHERE COMPLAINT_ID=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapComplaint(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Search and Filter for Citizens
    public List<Complaint> searchAndFilterUserComplaints(int userId, String keyword, String status, String riskLevel) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM COMPLAINTS WHERE USER_ID = ?");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        buildSearchQuery(sql, params, keyword, status, riskLevel);
        sql.append(" ORDER BY CREATED_AT DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search and Filter for Administrators
    public List<Complaint> searchAndFilterComplaints(String keyword, String status, String riskLevel) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM COMPLAINTS WHERE 1=1");
        List<Object> params = new ArrayList<>();

        buildSearchQuery(sql, params, keyword, status, riskLevel);
        sql.append(" ORDER BY CREATED_AT DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapComplaint(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private void buildSearchQuery(StringBuilder sql, List<Object> params, String keyword, String status, String riskLevel) {
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append(" AND STATUS = ?");
            params.add(status.trim());
        }
        if (riskLevel != null && !riskLevel.trim().isEmpty() && !"ALL".equalsIgnoreCase(riskLevel)) {
            sql.append(" AND RISK_LEVEL = ?");
            params.add(riskLevel.trim());
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(COMPLAINT_TYPE) LIKE ? OR LOWER(DESCRIPTION) LIKE ? OR LOWER(SUSPECT_URL) LIKE ? OR LOWER(SUSPECT_EMAIL) LIKE ?)");
            String term = "%" + keyword.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("COMPLAINT_ID"));
        c.setUserId(rs.getInt("USER_ID"));
        c.setComplaintType(rs.getString("COMPLAINT_TYPE"));
        c.setSubType(rs.getString("SUB_TYPE"));
        c.setDescription(rs.getString("DESCRIPTION"));
        c.setDistrict(rs.getString("DISTRICT"));
        c.setSuspectUpiId(rs.getString("SUSPECT_UPI_ID"));
        c.setSuspectBankAccount(rs.getString("SUSPECT_BANK_ACCOUNT"));
        c.setSuspectUrl(rs.getString("SUSPECT_URL"));
        c.setSuspectEmail(rs.getString("SUSPECT_EMAIL"));
        c.setRiskLevel(rs.getString("RISK_LEVEL"));
        c.setStatus(rs.getString("STATUS"));
        c.setCreatedAt(rs.getTimestamp("CREATED_AT"));
        c.setAnonymous(rs.getString("ANONYMOUS"));
        c.setEvidencePath(rs.getString("EVIDENCE_PATH"));
        c.setAssignedTo(rs.getString("ASSIGNED_TO"));
        c.setRemarks(rs.getString("REMARKS"));
        c.setAiExplanation(rs.getString("AI_EXPLANATION"));
        int investigatorId = rs.getInt("ASSIGNED_INVESTIGATOR_ID");
        c.setAssignedInvestigatorId(rs.wasNull() ? null : investigatorId);
        c.setAssignedAt(rs.getTimestamp("ASSIGNED_AT"));
        c.setInvestigationReport(rs.getString("INVESTIGATION_REPORT"));
        c.setInvestigationEvidencePath(rs.getString("INVESTIGATION_EVIDENCE_PATH"));
        c.setInvestigationSubmittedAt(rs.getTimestamp("INVESTIGATION_SUBMITTED_AT"));
        return c;
    }
}
