<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%
    // Ensure a CSRF token exists even for guest (non-logged-in) visitors
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }
    User loggedUser = (User) session.getAttribute("loggedUser");
    boolean submitted = "true".equals(request.getParameter("submitted"));
    boolean errorFlag = "true".equals(request.getParameter("error"));
%>
<%@ include file="common/header.jsp" %>

<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow">We'd love to hear from you</span>
        <h2>Share your feedback</h2>
        <p>Tell us about your experience with CyberShield — what worked well, what didn't, and what we should build next. Feedback from citizens and investigators directly shapes our roadmap.</p>
    </div>

    <div class="card" style="max-width: 680px;">
        <% if (submitted) { %>
            <div class="alert alert-success">Thank you! Your feedback has been recorded.</div>
        <% } else if (errorFlag) { %>
            <div class="alert alert-error">Something went wrong submitting your feedback. Please try again.</div>
        <% } %>

        <form action="FeedbackServlet" method="post">
            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
                <div class="form-group">
                    <label>Your name</label>
                    <input type="text" name="name" class="form-control" placeholder="Full name"
                           value="<%= loggedUser != null ? loggedUser.getName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Email address</label>
                    <input type="email" name="email" class="form-control" placeholder="you@example.com"
                           value="<%= loggedUser != null ? loggedUser.getEmail() : "" %>" required>
                </div>
            </div>

            <div class="form-group">
                <label>Feedback category</label>
                <select name="category" class="form-control" required>
                    <option value="">-- Select a category --</option>
                    <option>General Experience</option>
                    <option>Complaint Filing Process</option>
                    <option>AI Risk Assessment</option>
                    <option>Suspect Repository</option>
                    <option>Learning Corner</option>
                    <option>Bug Report</option>
                    <option>Feature Suggestion</option>
                    <option>Other</option>
                </select>
            </div>

            <div class="form-group">
                <label>How would you rate your experience?</label>
                <div class="star-rating" role="radiogroup" aria-label="Rating out of 5">
                    <input type="radio" id="star5" name="rating" value="5" checked><label for="star5" title="5 stars">&#9733;</label>
                    <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4 stars">&#9733;</label>
                    <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3 stars">&#9733;</label>
                    <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2 stars">&#9733;</label>
                    <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1 star">&#9733;</label>
                </div>
            </div>

            <div class="form-group">
                <label>Your feedback</label>
                <textarea name="message" class="form-control" style="height:120px; resize:none;" placeholder="Tell us what's on your mind..." required></textarea>
            </div>

            <button type="submit" class="btn btn-primary" style="width:100%;">
                <i class="fa-solid fa-paper-plane" aria-hidden="true"></i> Submit feedback
            </button>
        </form>
    </div>
</section>

<%@ include file="common/footer.jsp" %>
