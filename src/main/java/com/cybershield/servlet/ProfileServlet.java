package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // 1. CSRF Verification
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendRedirect("user/profile.jsp?err=csrf");
            return;
        }

        String action = req.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("updateProfile".equals(action)) {
            String name = req.getParameter("name").trim();
            String email = req.getParameter("email").trim();
            String secQuestion = req.getParameter("secQuestion").trim();
            String secAnswer = req.getParameter("secAnswer").trim();
            String phone = req.getParameter("phone") == null ? "" : req.getParameter("phone").trim();

            loggedUser.setName(name);
            loggedUser.setEmail(email);
            loggedUser.setSecQuestion(secQuestion);
            loggedUser.setSecAnswer(secAnswer);
            loggedUser.setPhone(phone);

            boolean success = dao.updateUser(loggedUser);
            if (success) {
                session.setAttribute("userName", name); // Update name in session header
                res.sendRedirect("user/profile.jsp?msg=updated");
            } else {
                res.sendRedirect("user/profile.jsp?err=failed");
            }

        } else if ("changePassword".equals(action)) {
            String oldPassword = req.getParameter("oldPassword").trim();
            String newPassword = req.getParameter("newPassword").trim();
            String confirmNewPassword = req.getParameter("confirmNewPassword").trim();

            if (!newPassword.equals(confirmNewPassword)) {
                res.sendRedirect("user/profile.jsp?err=mismatch");
                return;
            }

            // Verify old password
            User verified = dao.getUserByEmailAndPassword(loggedUser.getEmail(), oldPassword);
            if (verified == null) {
                res.sendRedirect("user/profile.jsp?err=wrong_pass");
                return;
            }

            // Update in DB (Password is hashed inside updatePassword method)
            boolean success = dao.updatePassword(loggedUser.getUserId(), newPassword);
            if (success) {
                res.sendRedirect("user/profile.jsp?msg=pass_updated");
            } else {
                res.sendRedirect("user/profile.jsp?err=failed");
            }
        }
    }
}
