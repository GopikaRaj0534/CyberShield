package com.cybershield.servlet;

import com.cybershield.dao.ThreatDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ThreatRemoveServlet")
public class ThreatRemoveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("loggedUser");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        // CSRF Verification
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        ThreatDAO dao = new ThreatDAO();
        boolean removed = dao.removeThreat(id);

        if (removed) {
            System.out.println("Threat ID #" + id + " purged successfully by admin.");
        } else {
            System.out.println("Purging threat ID #" + id + " failed.");
        }

        res.sendRedirect("admin/threats.jsp");
    }
}