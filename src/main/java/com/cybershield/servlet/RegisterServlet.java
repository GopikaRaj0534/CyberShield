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

        String name     = req.getParameter("name").trim();
        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();
        String confirm  = req.getParameter("confirmPassword").trim();

        // Basic server-side validation
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

        User user = new User(name, email, password, "USER");
        boolean success = dao.insertUser(user);

        if (success) {
            res.sendRedirect("login.jsp?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
    }
}