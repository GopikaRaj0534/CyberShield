package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.ThreatDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.User;
import com.cybershield.ai.AIService;
import com.cybershield.util.SecurityUtil;
import com.cybershield.util.EmailService;
import com.cybershield.util.SimplePdfWriter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/ComplaintServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        // 1. CSRF Token Verification for Security
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        String complaintType = req.getParameter("complaintType");
        String subType        = req.getParameter("subType");
        String description   = req.getParameter("description");
        String district       = req.getParameter("district");
        String suspectUrl    = req.getParameter("suspectUrl");
        String suspectEmail  = req.getParameter("suspectEmail");
        String suspectUpiId  = req.getParameter("suspectUpiId");
        String suspectBankAccount = req.getParameter("suspectBankAccount");
        String anonymous     = req.getParameter("anonymous");

        if (anonymous == null) {
            anonymous = "NO";
        }

        Complaint c = new Complaint();
        c.setUserId(loggedUser.getUserId());
        c.setComplaintType(complaintType);
        c.setSubType(subType);
        c.setDescription(description);
        c.setDistrict(district);
        c.setSuspectUpiId(suspectUpiId != null && !suspectUpiId.trim().isEmpty() ? suspectUpiId.trim() : null);
        c.setSuspectBankAccount(suspectBankAccount != null && !suspectBankAccount.trim().isEmpty() ? suspectBankAccount.trim() : null);
        c.setSuspectUrl(suspectUrl);
        c.setSuspectEmail(suspectEmail);
        c.setAnonymous(anonymous);

        // 2. Evidence File Upload handling
        Part filePart = req.getPart("evidenceFile");
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (originalFileName != null && !originalFileName.isEmpty()) {
                // Determine absolute path in deployment directory
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                String fullPath = uploadPath + File.separator + uniqueFileName;
                filePart.write(fullPath);
                
                // Store relative path in database
                c.setEvidencePath("uploads/" + uniqueFileName);
            }
        }

        // 3. AI Risk Prediction with ML explanation
        String[] aiResult = AIService.analyzeThreat(
                suspectUrl,
                suspectEmail,
                description
        );
        c.setRiskLevel(aiResult[0]);
        c.setAiExplanation(aiResult[1]);

        System.out.println("AI Risk Level   = " + aiResult[0]);
        System.out.println("AI Explanation  = " + aiResult[1]);

        // 4. Duplicate Threat Detection
        ThreatDAO threatDAO = new ThreatDAO();
        if (suspectUrl != null && !suspectUrl.trim().isEmpty()) {
            String trimmedUrl = suspectUrl.trim();
            if (threatDAO.threatExists(trimmedUrl)) {
                threatDAO.increaseCount(trimmedUrl);
                System.out.println("Duplicate threat detected: " + trimmedUrl);
            } else {
                threatDAO.addThreat(trimmedUrl, suspectEmail);
                System.out.println("New threat logged: " + trimmedUrl);
            }
        }

        // 5. Save Complaint
        ComplaintDAO dao = new ComplaintDAO();
        boolean success = dao.insertComplaint(c);

        if (success) {
            // Send submission mock email
            String emailBody = "Dear " + loggedUser.getName() + ",\n\n"
                    + "Your cybercrime complaint has been successfully filed in the CyberShield Portal.\n\n"
                    + "--- Submission Receipt ---\n"
                    + "Complaint Type: " + complaintType + (subType != null && !subType.isEmpty() ? " - " + subType : "") + "\n"
                    + "Suspect URL: " + (suspectUrl != null && !suspectUrl.isEmpty() ? suspectUrl : "None") + "\n"
                    + "Suspect Email: " + (suspectEmail != null && !suspectEmail.isEmpty() ? suspectEmail : "None") + "\n"
                    + "AI Risk Level Category: " + aiResult[0] + "\n"
                    + "AI Model Explanation: " + aiResult[1] + "\n"
                    + "Status: Pending Action\n\n"
                    + "Our administration team will review your complaint and initiate action. You can track this complaint status in real-time under the Track Status panel.\n\n"
                    + "Sincerely,\n"
                    + "CyberShield Law Enforcement Response Team";
            
            EmailService.sendEmail(loggedUser.getEmail(), "CyberShield - Crime Incident Report Received", emailBody);

            // Generate a PDF copy of the complaint and email it as an attachment
            try {
                byte[] pdfBytes = buildComplaintPdf(c, loggedUser);
                String filename = "CyberShield_Complaint_" + c.getComplaintId() + ".pdf";
                String pdfEmailBody = "Dear " + loggedUser.getName() + ",\n\n"
                        + "Attached is a PDF copy of the cybercrime complaint you just filed (Complaint ID: #" + c.getComplaintId() + ").\n"
                        + "Please keep this for your records.\n\n"
                        + "Sincerely,\n"
                        + "CyberShield Law Enforcement Response Team";
                EmailService.sendEmailWithAttachment(loggedUser.getEmail(),
                        "CyberShield - Your Complaint Copy (#" + c.getComplaintId() + ")",
                        pdfEmailBody, pdfBytes, filename);
            } catch (Exception e) {
                // A PDF/email hiccup should never block the citizen's complaint from being filed
                System.err.println("Failed to generate/send complaint PDF: " + e.getMessage());
            }

            res.sendRedirect("user/mycomplaints.jsp?submitted=true");
        } else {
            req.setAttribute("error", "Failed to submit complaint. Try again.");
            req.getRequestDispatcher("user/complaint.jsp").forward(req, res);
        }
    }

    private byte[] buildComplaintPdf(Complaint c, User citizen) throws IOException {
        SimplePdfWriter pdf = new SimplePdfWriter("CyberShield - Cybercrime Complaint Receipt");
        pdf.addField("Complaint ID", "#" + c.getComplaintId());
        pdf.addField("Filed by", citizen.getName() + " (" + citizen.getEmail() + ")");
        pdf.addField("Anonymous filing", "YES".equalsIgnoreCase(c.getAnonymous()) ? "Yes (identity hidden from other citizens)" : "No");
        pdf.addField("Registration category", c.getComplaintType());
        pdf.addField("Specific incident type", c.getSubType());
        pdf.addField("District", c.getDistrict());
        pdf.addField("Description", c.getDescription());
        pdf.addField("Suspect URL", c.getSuspectUrl());
        pdf.addField("Suspect email", c.getSuspectEmail());
        pdf.addField("Suspect UPI ID", c.getSuspectUpiId());
        pdf.addField("Suspect bank account", c.getSuspectBankAccount());
        pdf.addField("AI risk level", c.getRiskLevel());
        pdf.addField("AI diagnostics", c.getAiExplanation());
        pdf.addField("Status", "Pending");
        pdf.addField("Filed on", new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(new java.util.Date()));
        pdf.addField("Note", "This is an automatically generated receipt from an academic project (CyberShield), not an official government document.");
        return pdf.build();
    }
}