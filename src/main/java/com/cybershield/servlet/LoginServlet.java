package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();

        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);

        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmailAndPassword(email, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userName",   user.getName());
            session.setAttribute("userRole",   user.getRole());

            System.out.println("Login SUCCESS: " + user.getName());

            if ("ADMIN".equals(user.getRole())) {
                res.sendRedirect("admin/dashboard.jsp");
            } else {
                res.sendRedirect("user/dashboard.jsp");
            }
        } else {
            System.out.println("Login FAILED: invalid credentials");
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
    }
}
