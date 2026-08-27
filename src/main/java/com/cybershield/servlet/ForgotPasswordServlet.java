package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("checkEmail".equals(action)) {
            String email = req.getParameter("email").trim();
            User u = dao.getUserByEmail(email);

            if (u != null) {
                if (u.getSecQuestion() != null && !u.getSecQuestion().isEmpty()) {
                    req.setAttribute("step", "verifyAnswer");
                    req.setAttribute("email", email);
                    req.setAttribute("secQuestion", u.getSecQuestion());
                    req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
                } else {
                    req.setAttribute("error", "No security recovery question set for this account.");
                    req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
                }
            } else {
                req.setAttribute("error", "Email address is not registered in CyberShield.");
                req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
            }

        } else if ("resetPassword".equals(action)) {
            String email = req.getParameter("email").trim();
            String secAnswer = req.getParameter("secAnswer").trim();
            String newPassword = req.getParameter("newPassword").trim();
            String confirm = req.getParameter("confirmPassword").trim();

            User u = dao.getUserByEmail(email);
            
            if (u == null) {
                req.setAttribute("error", "User session expired. Start again.");
                req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
                return;
            }

            // Verify passwords match
            if (!newPassword.equals(confirm)) {
                req.setAttribute("step", "verifyAnswer");
                req.setAttribute("email", email);
                req.setAttribute("secQuestion", u.getSecQuestion());
                req.setAttribute("error", "Passwords do not match.");
                req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
                return;
            }

            // Verify security answer (case-insensitive)
            if (u.getSecAnswer() != null && u.getSecAnswer().trim().equalsIgnoreCase(secAnswer)) {
                boolean success = dao.updatePassword(u.getUserId(), newPassword);
                if (success) {
                    res.sendRedirect("login.jsp?reset=true");
                } else {
                    req.setAttribute("step", "verifyAnswer");
                    req.setAttribute("email", email);
                    req.setAttribute("secQuestion", u.getSecQuestion());
                    req.setAttribute("error", "Failed to reset password. Try again.");
                    req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
                }
            } else {
                req.setAttribute("step", "verifyAnswer");
                req.setAttribute("email", email);
                req.setAttribute("secQuestion", u.getSecQuestion());
                req.setAttribute("error", "Incorrect security recovery answer.");
                req.getRequestDispatcher("forgot_password.jsp").forward(req, res);
            }
        }
    }
}
