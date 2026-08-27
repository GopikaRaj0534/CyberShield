package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/InvestigatorRegisterServlet")
public class InvestigatorRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = value(req, "name");
        String email = value(req, "email");
        String password = value(req, "password");
        String confirm = value(req, "confirmPassword");

        // Investigation Officer does NOT require security question/answer
        if (name.isEmpty() ||
            email.isEmpty() ||
            password.isEmpty() ||
            confirm.isEmpty()) {

            fail(req, res, "Please fill in all required fields.");
            return;
        }

        if (!password.equals(confirm)) {
            fail(req, res, "Passwords do not match.");
            return;
        }

        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            fail(req, res,
                 "Email already registered. Please use the Investigation Officer login.");
            return;
        }

        // No security question or security answer for investigators
        User officer = new User(
                name,
                email,
                password,
                "INVESTIGATOR",
                null,
                null
        );

        if (dao.insertUser(officer)) {
            res.sendRedirect(
                req.getContextPath() +
                "/investigator-login.jsp?registered=true"
            );
        } else {
            fail(req, res,
                 "Registration failed. Please check the database connection and try again.");
        }
    }

    private String value(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }

    private void fail(HttpServletRequest req,
                      HttpServletResponse res,
                      String message)
            throws ServletException, IOException {

        req.setAttribute("error", message);
        req.getRequestDispatcher("investigator-register.jsp")
           .forward(req, res);
    }
}