package com.cybershield.servlet;

import com.cybershield.ai.AIService;
import com.cybershield.dao.SuspectDAO;
import com.cybershield.dao.ThreatDAO;
import com.cybershield.model.Suspect;
import com.cybershield.model.Threat;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Pre-emptive URL/QR/UPI risk check - public, no login required.
 * Reuses the same AI risk engine that screens filed complaints, so
 * citizens can screen a link, QR payload, or UPI ID *before* they act
 * on it, not only after they've already been victimized.
 */
@WebServlet("/PreemptiveCheckServlet")
public class PreemptiveCheckServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        String input = req.getParameter("checkValue");

        if (input == null || input.trim().isEmpty()) {
            req.setAttribute("error", "Please enter or scan a URL, UPI ID, or phone number to check.");
            req.getRequestDispatcher("preemptive-check.jsp").forward(req, res);
            return;
        }

        input = input.trim();

        // Reuse the existing AI risk engine (same one that screens filed complaints)
        String[] aiResult = AIService.analyzeThreat(input, "", "");

        // Cross-check against known reported suspects and threats
        SuspectDAO suspectDAO = new SuspectDAO();
        Suspect suspect = suspectDAO.findByIdentifier(input);

        ThreatDAO threatDAO = new ThreatDAO();
        Threat threat = null;
        for (Threat t : threatDAO.getAllThreats()) {
            if (input.equalsIgnoreCase(t.getUrl()) || input.equalsIgnoreCase(t.getEmail())) {
                threat = t;
                break;
            }
        }

        req.setAttribute("checked", input);
        req.setAttribute("riskLevel", aiResult[0]);
        req.setAttribute("explanation", aiResult[1]);
        req.setAttribute("suspect", suspect);
        req.setAttribute("threat", threat);
        req.getRequestDispatcher("preemptive-check.jsp").forward(req, res);
    }
}
