package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.UserDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.User;
import com.cybershield.util.EmailService;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/InvestigatorReportServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class InvestigatorReportServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User investigator = (User) session.getAttribute("loggedUser");

        if (investigator == null || !"INVESTIGATOR".equals(investigator.getRole())) {
            res.sendRedirect("../login.jsp");
            return;
        }

        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(req.getParameter("complaintId"));
        } catch (NumberFormatException e) {
            res.sendRedirect("investigator/dashboard.jsp?err=invalid");
            return;
        }

        ComplaintDAO complaintDAO = new ComplaintDAO();
        Complaint c = complaintDAO.getComplaintById(complaintId);

        // Make sure this investigator actually owns this case
        if (c == null || c.getAssignedInvestigatorId() == null || c.getAssignedInvestigatorId() != investigator.getUserId()) {
            res.sendRedirect("investigator/dashboard.jsp?err=not_yours");
            return;
        }

        String findings = req.getParameter("findings");
        String recommendedStatus = req.getParameter("recommendedStatus");

        String evidencePath = c.getInvestigationEvidencePath();
        Part filePart = req.getPart("evidenceFile");
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (!originalFileName.isEmpty()) {
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                evidencePath = "uploads/" + uniqueFileName;
            }
        }

        boolean saved = complaintDAO.submitInvestigationReport(complaintId, findings, evidencePath);

        if (saved && recommendedStatus != null && !recommendedStatus.trim().isEmpty()) {
            complaintDAO.updateComplaint(complaintId, recommendedStatus, c.getRiskLevel(), c.getAssignedTo(), c.getRemarks());
        }

        if (saved) {
            UserDAO userDAO = new UserDAO();
            User citizen = userDAO.getUserById(c.getUserId());
            // Notify the citizen the investigation findings are ready
            if (citizen != null) {
                String body = "Dear " + citizen.getName() + ",\n\n"
                        + "An update is available on your CyberShield complaint (Complaint ID: #" + complaintId + ") "
                        + "following investigation by our Investigation Officer.\n\n"
                        + "--- Investigation Findings ---\n" + findings + "\n\n"
                        + (recommendedStatus != null && !recommendedStatus.isEmpty() ? "Updated Status: " + recommendedStatus + "\n\n" : "")
                        + "You can view full details anytime under My Complaints.\n\n"
                        + "Sincerely,\n"
                        + "CyberShield Administration Office";
                EmailService.sendEmail(citizen.getEmail(), "CyberShield - Investigation Update (#" + complaintId + ")", body);
            }
            res.sendRedirect("investigator/dashboard.jsp?submitted=true");
        } else {
            res.sendRedirect("investigator/case-detail.jsp?id=" + complaintId + "&err=save_failed");
        }
    }
}
