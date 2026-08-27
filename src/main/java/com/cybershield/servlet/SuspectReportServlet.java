package com.cybershield.servlet;

import com.cybershield.dao.SuspectDAO;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/SuspectReportServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class SuspectReportServlet extends HttpServlet {

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

        String identifierType  = req.getParameter("identifierType");
        String identifierValue = req.getParameter("identifierValue");
        String platform         = req.getParameter("platform");
        String reportCategory   = req.getParameter("reportCategory");
        String details          = req.getParameter("details");

        if (identifierValue == null || identifierValue.trim().isEmpty()
                || identifierType == null || reportCategory == null) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("user/suspect-report.jsp").forward(req, res);
            return;
        }

        String evidencePath = null;
        Part filePart = req.getPart("evidenceFile");
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (!originalFileName.isEmpty()) {
                String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                evidencePath = "uploads/" + uniqueFileName;
            }
        }

        SuspectDAO dao = new SuspectDAO();
        boolean success = dao.reportSuspect(
                identifierType,
                identifierValue.trim(),
                platform,
                user.getUserId(),
                reportCategory,
                details,
                evidencePath
        );

        if (success) {
            res.sendRedirect("user/my-suspect-reports.jsp?submitted=true");
        } else {
            req.setAttribute("error", "Failed to submit suspect report. Please try again.");
            req.getRequestDispatcher("user/suspect-report.jsp").forward(req, res);
        }
    }
}
