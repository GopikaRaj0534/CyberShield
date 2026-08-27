package com.cybershield.servlet;

import com.cybershield.dao.ComplaintDAO;
import com.cybershield.dao.ComplaintFeedbackDAO;
import com.cybershield.model.Complaint;
import com.cybershield.model.ComplaintFeedback;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/ComplaintFeedbackServlet")
public class ComplaintFeedbackServlet extends HttpServlet {

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

        int complaintId;
        int rating;
        try {
            complaintId = Integer.parseInt(req.getParameter("complaintId"));
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException e) {
            res.sendRedirect("mycomplaints.jsp?err=invalid");
            return;
        }
        if (rating < 1) rating = 1;
        if (rating > 5) rating = 5;

        ComplaintDAO complaintDAO = new ComplaintDAO();
        Complaint c = complaintDAO.getComplaintById(complaintId);

        // Citizens can only rate their own case, and only once it's closed
        boolean isClosed = c != null && ("Resolved".equalsIgnoreCase(c.getStatus()) || "Rejected".equalsIgnoreCase(c.getStatus()));
        if (c == null || c.getUserId() != user.getUserId() || !isClosed) {
            res.sendRedirect("mycomplaints.jsp?err=not_eligible");
            return;
        }

        ComplaintFeedbackDAO feedbackDAO = new ComplaintFeedbackDAO();
        if (feedbackDAO.getByComplaintId(complaintId) != null) {
            // Already rated - the UNIQUE constraint would reject a second insert anyway
            res.sendRedirect("mycomplaints.jsp?err=already_rated");
            return;
        }

        ComplaintFeedback f = new ComplaintFeedback();
        f.setComplaintId(complaintId);
        f.setUserId(user.getUserId());
        f.setRating(rating);
        f.setComments(req.getParameter("comments"));

        boolean saved = feedbackDAO.insert(f);

        if (saved) {
            res.sendRedirect("mycomplaints.jsp?rated=true");
        } else {
            res.sendRedirect("mycomplaints.jsp?err=save_failed");
        }
    }
}
