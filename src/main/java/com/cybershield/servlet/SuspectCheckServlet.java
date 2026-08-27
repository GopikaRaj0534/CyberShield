package com.cybershield.servlet;

import com.cybershield.dao.SuspectDAO;
import com.cybershield.dao.ThreatDAO;
import com.cybershield.model.Suspect;
import com.cybershield.model.Threat;
import com.cybershield.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/SuspectCheckServlet")
public class SuspectCheckServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        handleCheck(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        handleCheck(req, res);
    }

    private void handleCheck(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            res.sendRedirect("../login.jsp");
            return;
        }

        String identifierValue = req.getParameter("identifierValue");

        if (identifierValue == null || identifierValue.trim().isEmpty()) {
            req.setAttribute("error", "Please enter an email, mobile number, or URL to check.");
            req.getRequestDispatcher("user/suspect-check.jsp").forward(req, res);
            return;
        }

        identifierValue = identifierValue.trim();

        SuspectDAO suspectDAO = new SuspectDAO();
        Suspect suspect = suspectDAO.findByIdentifier(identifierValue);

        // Also cross-check against the existing Threat Intelligence table
        // (URLs/emails reported through the complaint flow) so results are unified.
        ThreatDAO threatDAO = new ThreatDAO();
        Threat threat = null;
        for (Threat t : threatDAO.getAllThreats()) {
            if (identifierValue.equalsIgnoreCase(t.getUrl()) || identifierValue.equalsIgnoreCase(t.getEmail())) {
                threat = t;
                break;
            }
        }

        boolean alreadyCorroborated = false;
        int corroborationCount = 0;
        if (suspect != null) {
            corroborationCount = suspectDAO.getCorroborationCount(suspect.getSuspectId());
            alreadyCorroborated = suspectDAO.hasCorroborated(suspect.getSuspectId(), user.getUserId());
        }

        req.setAttribute("queried", identifierValue);
        req.setAttribute("suspect", suspect);
        req.setAttribute("threat", threat);
        req.setAttribute("corroborationCount", corroborationCount);
        req.setAttribute("alreadyCorroborated", alreadyCorroborated);
        req.getRequestDispatcher("user/suspect-check.jsp").forward(req, res);
    }
}
