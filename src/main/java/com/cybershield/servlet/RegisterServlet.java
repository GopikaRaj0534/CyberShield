package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name     = req.getParameter("name") == null ? "" : req.getParameter("name").trim();
        String email    = req.getParameter("email") == null ? "" : req.getParameter("email").trim();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password").trim();
        String confirm  = req.getParameter("confirmPassword") == null ? "" : req.getParameter("confirmPassword").trim();

        String secQuestion = req.getParameter("secQuestion") == null ? "" : req.getParameter("secQuestion").trim();
        String secAnswer   = req.getParameter("secAnswer") == null ? "" : req.getParameter("secAnswer").trim();
        String phone       = req.getParameter("phone") == null ? "" : req.getParameter("phone").trim();

        // Basic server-side validation
        if (name.isEmpty() || email.isEmpty() || password.isEmpty() || confirm.isEmpty() || secQuestion.isEmpty() || secAnswer.isEmpty() || phone.isEmpty()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            req.setAttribute("error", "Email already registered. Please login.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        User user = new User(name, email, password, "USER", secQuestion, secAnswer, phone);
        boolean success = dao.insertUser(user);

        if (success) {
            res.sendRedirect("login.jsp?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
    }
}