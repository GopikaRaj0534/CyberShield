package com.cybershield.dao;

import com.cybershield.model.Suspect;
import com.cybershield.model.SuspectReport;
import com.cybershield.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SuspectDAO {

    // ---- Suspect Repository: Check Suspect ----------------------------

    // Look up a suspect by exact identifier value (email, mobile, url, handle)
    public Suspect findByIdentifier(String identifierValue) {
        String sql = "SELECT * FROM SUSPECTS WHERE LOWER(IDENTIFIER_VALUE) = LOWER(?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, identifierValue.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapSuspect(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Suspect> getAllSuspects() {
        List<Suspect> list = new ArrayList<>();
        String sql = "SELECT * FROM SUSPECTS ORDER BY REPORT_COUNT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapSuspect(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countSuspects() {
        String sql = "SELECT COUNT(*) FROM SUSPECTS";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ---- Suspect Repository: Report Suspect ----------------------------

    // Creates the SUSPECTS master row if it doesn't exist yet, else bumps
    // its report count - then logs the individual report in SUSPECT_REPORTS.
    // Returns true on success.
    public boolean reportSuspect(String identifierType, String identifierValue, String platform,
                                  int userId, String reportCategory, String details, String evidencePath) {

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            int suspectId;
            Suspect existing = findByIdentifierWithConnection(con, identifierValue);

            if (existing != null) {
                suspectId = existing.getSuspectId();
                String updateSql = "UPDATE SUSPECTS SET REPORT_COUNT = REPORT_COUNT + 1 WHERE SUSPECT_ID = ?";
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setInt(1, suspectId);
                    ps.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO SUSPECTS (IDENTIFIER_TYPE, IDENTIFIER_VALUE, PLATFORM, REPORT_COUNT, STATUS) "
                                  + "VALUES (?, ?, ?, 1, 'ACTIVE')";
                try (PreparedStatement ps = con.prepareStatement(insertSql, new String[]{"SUSPECT_ID"})) {
                    ps.setString(1, identifierType);
                    ps.setString(2, identifierValue.trim());
                    ps.setString(3, platform);
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            suspectId = keys.getInt(1);
                        } else {
                            con.rollback();
                            return false;
                        }
                    }
                }
            }

            String reportSql = "INSERT INTO SUSPECT_REPORTS (SUSPECT_ID, USER_ID, REPORT_CATEGORY, PLATFORM, DETAILS, EVIDENCE_PATH) "
                              + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(reportSql)) {
                ps.setInt(1, suspectId);
                ps.setInt(2, userId);
                ps.setString(3, reportCategory);
                ps.setString(4, platform);
                ps.setString(5, details);
                ps.setString(6, evidencePath);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Suspect findByIdentifierWithConnection(Connection con, String identifierValue) throws SQLException {
        String sql = "SELECT * FROM SUSPECTS WHERE LOWER(IDENTIFIER_VALUE) = LOWER(?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, identifierValue.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapSuspect(rs);
            }
        }
        return null;
    }

    // ---- My Reported Suspects (personal history) ------------------------

    public List<SuspectReport> getReportsByUser(int userId) {
        List<SuspectReport> list = new ArrayList<>();
        String sql = "SELECT r.*, s.IDENTIFIER_TYPE, s.IDENTIFIER_VALUE FROM SUSPECT_REPORTS r "
                   + "JOIN SUSPECTS s ON r.SUSPECT_ID = s.SUSPECT_ID "
                   + "WHERE r.USER_ID = ? ORDER BY r.CREATED_AT DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SuspectReport r = new SuspectReport();
                r.setSuspectReportId(rs.getInt("SUSPECT_REPORT_ID"));
                r.setSuspectId(rs.getInt("SUSPECT_ID"));
                r.setUserId(rs.getInt("USER_ID"));
                r.setReportCategory(rs.getString("REPORT_CATEGORY"));
                r.setPlatform(rs.getString("PLATFORM"));
                r.setDetails(rs.getString("DETAILS"));
                r.setEvidencePath(rs.getString("EVIDENCE_PATH"));
                r.setCreatedAt(rs.getTimestamp("CREATED_AT"));
                r.setIdentifierType(rs.getString("IDENTIFIER_TYPE"));
                r.setIdentifierValue(rs.getString("IDENTIFIER_VALUE"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ---- Community Verification / Trust Scoring ------------------------

    // Records "I got this too" from a citizen. Returns false if they've
    // already corroborated this suspect (one corroboration per citizen).
    public boolean corroborate(int suspectId, int userId) {
        if (hasCorroborated(suspectId, userId)) {
            return false;
        }
        String sql = "INSERT INTO SUSPECT_CORROBORATIONS (SUSPECT_ID, USER_ID) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, suspectId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasCorroborated(int suspectId, int userId) {
        String sql = "SELECT COUNT(*) FROM SUSPECT_CORROBORATIONS WHERE SUSPECT_ID = ? AND USER_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, suspectId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCorroborationCount(int suspectId) {
        String sql = "SELECT COUNT(*) FROM SUSPECT_CORROBORATIONS WHERE SUSPECT_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, suspectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Suspects with the highest combined community trust score
    // (formal reports + lightweight corroborations), for the public digest.
    public List<Suspect> getTopTrustScored(int limit) {
        List<Suspect> list = new ArrayList<>();
        String sql = "SELECT s.*, "
                   + "(s.REPORT_COUNT + NVL((SELECT COUNT(*) FROM SUSPECT_CORROBORATIONS c WHERE c.SUSPECT_ID = s.SUSPECT_ID), 0)) AS TRUST_SCORE "
                   + "FROM SUSPECTS s ORDER BY TRUST_SCORE DESC FETCH FIRST ? ROWS ONLY";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Suspect s = mapSuspect(rs);
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Suspect mapSuspect(ResultSet rs) throws SQLException {
        Suspect s = new Suspect();
        s.setSuspectId(rs.getInt("SUSPECT_ID"));
        s.setIdentifierType(rs.getString("IDENTIFIER_TYPE"));
        s.setIdentifierValue(rs.getString("IDENTIFIER_VALUE"));
        s.setPlatform(rs.getString("PLATFORM"));
        s.setReportCount(rs.getInt("REPORT_COUNT"));
        s.setStatus(rs.getString("STATUS"));
        s.setCreatedAt(rs.getTimestamp("CREATED_AT"));
        return s;
    }
}
