package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/InvestigatorLoginServlet")
public class InvestigatorLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Please enter your email and password.");
            req.getRequestDispatcher("investigator-login.jsp").forward(req, res);
            return;
        }
        User user = new UserDAO().getUserByEmailAndPassword(email.trim(), password, "INVESTIGATOR");
        if (user == null) {
            req.setAttribute("error", "Invalid Investigation Officer credentials.");
            req.getRequestDispatcher("investigator-login.jsp").forward(req, res);
            return;
        }
        LoginServlet.createSession(req, user);
        res.sendRedirect(req.getContextPath() + "/investigator/dashboard.jsp");
    }
}
