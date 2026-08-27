package com.cybershield.dao;

import com.cybershield.model.User;
import com.cybershield.util.DBConnection;
import com.cybershield.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // =========================================================
    // INSERT NEW USER
    // =========================================================
    public boolean insertUser(User user) {

        String sql = "INSERT INTO USERS " +
                "(NAME, EMAIL, PASSWORD, ROLE, SEC_QUESTION, SEC_ANSWER, PHONE) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());

            // PasswordUtil now returns the password directly
            ps.setString(3, PasswordUtil.hashPassword(user.getPassword()));

            ps.setString(4, user.getRole());
            ps.setString(5, user.getSecQuestion());
            ps.setString(6, user.getSecAnswer());
            ps.setString(7, user.getPhone());

            int rows = ps.executeUpdate();

            System.out.println("Rows inserted: " + rows);

            return rows > 0;

        } catch (SQLException e) {

            System.out.println("========== REGISTRATION DATABASE ERROR ==========");
            System.out.println("Error Code : " + e.getErrorCode());
            System.out.println("SQL State  : " + e.getSQLState());
            System.out.println("Message    : " + e.getMessage());
            e.printStackTrace();
            System.out.println("==================================================");

            return false;
        }
    }


    // =========================================================
    // LOGIN - EMAIL + PASSWORD
    // =========================================================
    public User getUserByEmailAndPassword(String email, String password) {
        return getUserByEmailAndPassword(email, password, null);
    }


    // =========================================================
    // LOGIN - EMAIL + PASSWORD + ROLE
    // =========================================================
    public User getUserByEmailAndPassword(
            String email,
            String password,
            String expectedRole) {

        String sql = "SELECT * FROM USERS WHERE EMAIL = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String storedPassword = rs.getString("PASSWORD");

                    if (storedPassword == null) {
                        return null;
                    }

                    /*
                     * PasswordUtil currently returns the entered password
                     * directly, so this compares plain passwords.
                     *
                     * The second comparison also keeps compatibility
                     * with accounts that may still contain old SHA-256
                     * values.
                     */
                    boolean passwordMatch =
                            storedPassword.equals(password)
                            || storedPassword.equals(
                                    PasswordUtil.hashPassword(password)
                            );

                    String role = rs.getString("ROLE");

                    boolean roleMatch =
                            expectedRole == null
                            || expectedRole.equalsIgnoreCase(role);

                    if (passwordMatch && roleMatch) {

                        User user = new User();

                        user.setUserId(rs.getInt("USER_ID"));
                        user.setName(rs.getString("NAME"));
                        user.setEmail(rs.getString("EMAIL"));
                        user.setRole(rs.getString("ROLE"));
                        user.setSecQuestion(rs.getString("SEC_QUESTION"));
                        user.setSecAnswer(rs.getString("SEC_ANSWER"));
                        user.setPhone(rs.getString("PHONE"));

                        return user;
                    }
                }
            }

        } catch (SQLException e) {

            System.out.println("========== LOGIN DATABASE ERROR ==========");
            System.out.println("Error Code : " + e.getErrorCode());
            System.out.println("SQL State  : " + e.getSQLState());
            System.out.println("Message    : " + e.getMessage());
            e.printStackTrace();
            System.out.println("==========================================");

        }

        return null;
    }


    // =========================================================
    // GET USER BY EMAIL
    // =========================================================
    public User getUserByEmail(String email) {

        String sql = "SELECT * FROM USERS WHERE EMAIL = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setUserId(rs.getInt("USER_ID"));
                    user.setName(rs.getString("NAME"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setRole(rs.getString("ROLE"));
                    user.setSecQuestion(rs.getString("SEC_QUESTION"));
                    user.setSecAnswer(rs.getString("SEC_ANSWER"));
                    user.setPhone(rs.getString("PHONE"));

                    return user;
                }
            }

        } catch (SQLException e) {

            System.out.println("Error getting user by email:");
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // CHECK WHETHER EMAIL EXISTS
    // =========================================================
    public boolean emailExists(String email) {

        String sql = "SELECT 1 FROM USERS WHERE EMAIL = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {

            System.out.println("Error checking email:");
            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // UPDATE USER DETAILS
    // =========================================================
    public boolean updateUser(User user) {

        String sql =
                "UPDATE USERS SET " +
                "NAME = ?, " +
                "EMAIL = ?, " +
                "SEC_QUESTION = ?, " +
                "SEC_ANSWER = ?, " +
                "PHONE = ? " +
                "WHERE USER_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getSecQuestion());
            ps.setString(4, user.getSecAnswer());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.out.println("Error updating user:");
            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // UPDATE PASSWORD
    // =========================================================
    public boolean updatePassword(int userId, String newPassword) {

        String sql =
                "UPDATE USERS SET PASSWORD = ? WHERE USER_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            /*
             * PasswordUtil currently returns the password directly.
             */
            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.out.println("Error updating password:");
            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // DELETE USER
    // =========================================================
    public boolean deleteUser(int userId) {

        String sql =
                "DELETE FROM USERS " +
                "WHERE USER_ID = ? AND ROLE != 'ADMIN'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.out.println("Error deleting user:");
            e.printStackTrace();

            return false;
        }
    }


    // =========================================================
    // GET USER BY ID
    // =========================================================
    public User getUserById(int id) {

        String sql = "SELECT * FROM USERS WHERE USER_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setUserId(rs.getInt("USER_ID"));
                    user.setName(rs.getString("NAME"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setRole(rs.getString("ROLE"));
                    user.setSecQuestion(rs.getString("SEC_QUESTION"));
                    user.setSecAnswer(rs.getString("SEC_ANSWER"));
                    user.setPhone(rs.getString("PHONE"));

                    return user;
                }
            }

        } catch (SQLException e) {

            System.out.println("Error getting user by ID:");
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // GET ALL USERS
    // =========================================================
    public List<User> getAllUsers() {

        List<User> list = new ArrayList<>();

        String sql =
                "SELECT * FROM USERS ORDER BY USER_ID";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("USER_ID"));
                user.setName(rs.getString("NAME"));
                user.setEmail(rs.getString("EMAIL"));
                user.setRole(rs.getString("ROLE"));
                user.setSecQuestion(rs.getString("SEC_QUESTION"));
                user.setSecAnswer(rs.getString("SEC_ANSWER"));
                user.setPhone(rs.getString("PHONE"));

                list.add(user);
            }

        } catch (SQLException e) {

            System.out.println("Error getting all users:");
            e.printStackTrace();
        }

        return list;
    }


    // =========================================================
    // GET USERS BY ROLE
    // =========================================================
    public List<User> getUsersByRole(String role) {

        List<User> list = new ArrayList<>();

        String sql =
                "SELECT * FROM USERS " +
                "WHERE ROLE = ? " +
                "ORDER BY USER_ID";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, role);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    User user = new User();

                    user.setUserId(rs.getInt("USER_ID"));
                    user.setName(rs.getString("NAME"));
                    user.setEmail(rs.getString("EMAIL"));
                    user.setRole(rs.getString("ROLE"));
                    user.setSecQuestion(rs.getString("SEC_QUESTION"));
                    user.setSecAnswer(rs.getString("SEC_ANSWER"));
                    user.setPhone(rs.getString("PHONE"));

                    list.add(user);
                }
            }

        } catch (SQLException e) {

            System.out.println("Error getting users by role:");
            e.printStackTrace();
        }

        return list;
    }
}