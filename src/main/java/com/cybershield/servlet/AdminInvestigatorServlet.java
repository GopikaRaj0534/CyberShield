package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AdminInvestigatorServlet")
public class AdminInvestigatorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("loggedUser");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("../login.jsp");
            return;
        }

        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        String action = req.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("delete".equals(action)) {
            String idStr = req.getParameter("userId");
            try {
                int userId = Integer.parseInt(idStr);
                dao.deleteUser(userId);
            } catch (NumberFormatException ignored) { }
            res.sendRedirect("admin/investigators.jsp");
            return;
        }

        // Default action: create a new investigation officer account
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all fields.");
            req.getRequestDispatcher("admin/investigators.jsp").forward(req, res);
            return;
        }

        if (dao.emailExists(email.trim())) {
            req.setAttribute("error", "That email is already registered.");
            req.getRequestDispatcher("admin/investigators.jsp").forward(req, res);
            return;
        }

        User investigator = new User(name.trim(), email.trim(), password.trim(), "INVESTIGATOR");
        boolean success = dao.insertUser(investigator);

        if (success) {
            res.sendRedirect("admin/investigators.jsp?created=true");
        } else {
            req.setAttribute("error", "Failed to create investigation officer account.");
            req.getRequestDispatcher("admin/investigators.jsp").forward(req, res);
        }
    }
}
