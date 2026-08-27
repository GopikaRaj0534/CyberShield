package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.UserDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.User;
import com.cybershield.util.EmailService;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AdminAssignInvestigatorServlet")
public class AdminAssignInvestigatorServlet extends HttpServlet {

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

        int complaintId;
        int investigatorId;
        try {
            complaintId = Integer.parseInt(req.getParameter("complaintId"));
            investigatorId = Integer.parseInt(req.getParameter("investigatorId"));
        } catch (NumberFormatException e) {
            res.sendRedirect("admin/complaints.jsp?err=invalid");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User investigator = userDAO.getUserById(investigatorId);
        if (investigator == null || !"INVESTIGATOR".equals(investigator.getRole())) {
            res.sendRedirect("admin/complaints.jsp?err=invalid_investigator");
            return;
        }

        ComplaintDAO complaintDAO = new ComplaintDAO();
        boolean assigned = complaintDAO.assignInvestigator(complaintId, investigatorId, investigator.getName());

        if (assigned) {
            // Hand over the victim's case details to the investigator, and let the citizen know
            Complaint c = complaintDAO.getComplaintById(complaintId);
            User citizen = c != null ? userDAO.getUserById(c.getUserId()) : null;

            String investigatorEmailBody = "Dear " + investigator.getName() + ",\n\n"
                    + "You have been assigned a new case on CyberShield (Complaint ID: #" + complaintId + ").\n\n"
                    + "--- Case Summary ---\n"
                    + "Category: " + (c != null ? c.getComplaintType() : "-") + (c != null && c.getSubType() != null ? " - " + c.getSubType() : "") + "\n"
                    + "District: " + (c != null ? c.getDistrict() : "-") + "\n"
                    + "AI Risk Level: " + (c != null ? c.getRiskLevel() : "-") + "\n\n"
                    + "Please log in to your Investigation Officer dashboard to review the full victim details and evidence, and submit your findings once your investigation is complete.\n\n"
                    + "Sincerely,\n"
                    + "CyberShield Administration Office";
            EmailService.sendEmail(investigator.getEmail(), "CyberShield - New Case Assigned (#" + complaintId + ")", investigatorEmailBody);

            if (citizen != null) {
                String citizenEmailBody = "Dear " + citizen.getName() + ",\n\n"
                        + "Your CyberShield complaint (Complaint ID: #" + complaintId + ") has been assigned to an Investigation Officer for further review.\n\n"
                        + "You will be notified again once the investigation findings are available.\n\n"
                        + "Sincerely,\n"
                        + "CyberShield Administration Office";
                EmailService.sendEmail(citizen.getEmail(), "CyberShield - Case Assigned to Investigator (#" + complaintId + ")", citizenEmailBody);
            }

            res.sendRedirect("admin/complaints.jsp?msg=assigned");
        } else {
            res.sendRedirect("admin/complaints.jsp?err=assign_failed");
        }
    }
}
