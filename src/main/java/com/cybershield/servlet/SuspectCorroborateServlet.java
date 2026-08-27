package com.cybershield.servlet;

import com.cybershield.dao.SuspectDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/SuspectCorroborateServlet")
public class SuspectCorroborateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            res.sendRedirect("../login.jsp");
            return;
        }

        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        String suspectIdStr = req.getParameter("suspectId");
        String identifierValue = req.getParameter("identifierValue");

        try {
            int suspectId = Integer.parseInt(suspectIdStr);
            SuspectDAO dao = new SuspectDAO();
            dao.corroborate(suspectId, user.getUserId());
        } catch (NumberFormatException ignored) {
            // Fall through and redirect back to the check page regardless
        }

        String redirectUrl = "SuspectCheckServlet";
        if (identifierValue != null && !identifierValue.trim().isEmpty()) {
            redirectUrl += "?identifierValue=" + java.net.URLEncoder.encode(identifierValue.trim(), "UTF-8") + "&corroborated=true";
        } else {
            redirectUrl = "user/suspect-check.jsp";
        }
        res.sendRedirect(redirectUrl);
    }
}
