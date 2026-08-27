package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.UserDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/AdminExportServlet")
public class AdminExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("loggedUser");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            res.sendRedirect("login.jsp");
            return;
        }

        res.setContentType("text/csv; charset=UTF-8");
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Content-Disposition", "attachment; filename=\"cybershield_complaints_report.csv\"");

        try (PrintWriter writer = res.getWriter()) {
            // Write BOM for UTF-8 compatibility with Excel
            writer.write('\ufeff');

            // Header line
            writer.println("Complaint ID,Reporter Citizen,Incident Category,Incident Description,Suspect URL,Suspect Email,AI Risk Level,Processing State,Submission Date,Evidence File Path,Assigned Investigator,Administrative Remarks,AI Explanation");

            ComplaintDAO dao = new ComplaintDAO();
            UserDAO userDAO = new UserDAO();
            List<Complaint> complaints = dao.getAllComplaints();

            for (Complaint c : complaints) {
                User reporter = userDAO.getUserById(c.getUserId());
                String reporterName = "Unknown";
                if (c.getAnonymous() != null && c.getAnonymous().equalsIgnoreCase("YES")) {
                    reporterName = "Anonymous Citizen";
                } else if (reporter != null) {
                    reporterName = reporter.getName() + " (" + reporter.getEmail() + ")";
                }

                writer.println(
                    c.getComplaintId() + "," +
                    SecurityUtil.escapeCsv(reporterName) + "," +
                    SecurityUtil.escapeCsv(c.getComplaintType()) + "," +
                    SecurityUtil.escapeCsv(c.getDescription()) + "," +
                    SecurityUtil.escapeCsv(c.getSuspectUrl()) + "," +
                    SecurityUtil.escapeCsv(c.getSuspectEmail()) + "," +
                    SecurityUtil.escapeCsv(c.getRiskLevel()) + "," +
                    SecurityUtil.escapeCsv(c.getStatus()) + "," +
                    SecurityUtil.escapeCsv(c.getCreatedAt().toString()) + "," +
                    SecurityUtil.escapeCsv(c.getEvidencePath()) + "," +
                    SecurityUtil.escapeCsv(c.getAssignedTo()) + "," +
                    SecurityUtil.escapeCsv(c.getRemarks()) + "," +
                    SecurityUtil.escapeCsv(c.getAiExplanation())
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
