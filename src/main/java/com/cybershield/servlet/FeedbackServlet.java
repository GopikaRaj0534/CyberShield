package com.cybershield.servlet;

import com.cybershield.dao.FeedbackDAO;
import com.cybershield.model.Feedback;
import com.cybershield.model.User;
import com.cybershield.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // CSRF Token Verification
        if (!SecurityUtil.verifyCsrfToken(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
            return;
        }

        User loggedUser = (User) session.getAttribute("loggedUser");

        String name    = req.getParameter("name");
        String email   = req.getParameter("email");
        String category = req.getParameter("category");
        String ratingStr = req.getParameter("rating");
        String message = req.getParameter("message");

        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1) rating = 1;
            if (rating > 5) rating = 5;
        } catch (Exception e) {
            rating = 5;
        }

        Feedback f = new Feedback();
        if (loggedUser != null) {
            f.setUserId(loggedUser.getUserId());
            f.setName(name != null && !name.trim().isEmpty() ? name : loggedUser.getName());
            f.setEmail(email != null && !email.trim().isEmpty() ? email : loggedUser.getEmail());
        } else {
            f.setUserId(null);
            f.setName(name);
            f.setEmail(email);
        }
        f.setCategory(category);
        f.setRating(rating);
        f.setMessage(message);

        FeedbackDAO dao = new FeedbackDAO();
        boolean success = dao.insertFeedback(f);

        if (success) {
            res.sendRedirect("feedback.jsp?submitted=true");
        } else {
            res.sendRedirect("feedback.jsp?error=true");
        }
    }
}
