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

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Please enter your email and password.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        email = email.trim();
        User user = new UserDAO().getUserByEmailAndPassword(email, password, "USER");

        if (user != null) {
            createSession(req, user);
            res.sendRedirect(req.getContextPath() + "/user/complaint.jsp");
        } else {
            req.setAttribute("error", "Invalid user credentials. Investigation officers and administrators must use their dedicated login pages.");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
    }

    static void createSession(HttpServletRequest req, User user) {
        HttpSession session = req.getSession();
        session.setMaxInactiveInterval(15 * 60);
        session.setAttribute("loggedUser", user);
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }
}
