package com.cybershield.servlet;

import com.cybershield.dao.UserDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("loggedUser");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        // CSRF verification
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        String action = req.getParameter("action");
        int userId = Integer.parseInt(req.getParameter("userId"));
        UserDAO dao = new UserDAO();

        if ("delete".equals(action)) {
            boolean success = dao.deleteUser(userId);
            if (success) {
                System.out.println("User ID #" + userId + " removed by Administrator.");
            }
        }
        res.sendRedirect("admin/users.jsp");
    }
}
