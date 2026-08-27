package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.UserDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;
import com.cybershield.util.EmailService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminComplaintServlet")
public class AdminComplaintServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("loggedUser");

        // Verify that the logged-in user is an Admin
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        // 1. CSRF Verification
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        int complaintId    = Integer.parseInt(req.getParameter("complaintId"));
        String status      = req.getParameter("status");
        String risk        = req.getParameter("risk");
        String assignedTo  = req.getParameter("assignedTo");
        String remarks     = req.getParameter("remarks");

        if (assignedTo == null) assignedTo = "";
        if (remarks == null) remarks = "";

        ComplaintDAO dao = new ComplaintDAO();
        Complaint oldComplaint = dao.getComplaintById(complaintId);
        
        if (oldComplaint == null) {
            res.sendRedirect("admin/complaints.jsp?err=not_found");
            return;
        }

        boolean updated = dao.updateComplaint(complaintId, status, risk, assignedTo, remarks);

        if (updated) {
            System.out.println("Complaint #" + complaintId + " updated successfully by admin.");

            // 2. Dispatch Email Update if status has changed
            if (!oldComplaint.getStatus().equalsIgnoreCase(status)) {
                UserDAO userDAO = new UserDAO();
                User citizen = userDAO.getUserById(oldComplaint.getUserId());
                if (citizen != null) {
                    String emailBody = "Dear " + citizen.getName() + ",\n\n"
                            + "The status of your CyberShield complaint (Complaint ID: #" + complaintId + ") has been updated.\n\n"
                            + "--- Updated Case Status ---\n"
                            + "New Status: " + status + "\n"
                            + "Risk Classification: " + risk + "\n"
                            + "Assigned Investigator: " + (assignedTo.isEmpty() ? "Not yet assigned" : assignedTo) + "\n"
                            + "Administrative Remarks:\n" + (remarks.isEmpty() ? "No remarks added." : remarks) + "\n\n"
                            + "You can track the live progress timeline of your case in the CyberShield portal.\n\n"
                            + "Sincerely,\n"
                            + "CyberShield Administration Office";

                    EmailService.sendEmail(citizen.getEmail(), "CyberShield - Case Status Updated (#" + complaintId + ")", emailBody);
                }
            }
            res.sendRedirect("admin/complaints.jsp?msg=success");
        } else {
            System.out.println("Update failed for complaint #" + complaintId);
            res.sendRedirect("admin/complaints.jsp?err=failed");
        }
    }
}