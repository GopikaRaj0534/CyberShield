<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.dao.FeedbackDAO" %>
<%@ page import="com.cybershield.model.Feedback" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

FeedbackDAO dao = new FeedbackDAO();
List<Feedback> feedbackList = dao.getAllFeedback();
double avgRating = dao.getAverageRating();
int total = dao.countAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Feedback - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="feedback" />
    </jsp:include>

    <main class="portal-main">
        <h1>Citizen feedback</h1>
        <p class="page-sub">Feedback submitted by citizens and site visitors, most recent first.</p>

        <div class="hero-stats" style="margin: 20px 0 30px;">
            <div class="hero-stat">
                <div class="num"><%= total %></div>
                <div class="label">Total feedback entries</div>
            </div>
            <div class="hero-stat">
                <div class="num"><%= String.format("%.1f", avgRating) %> / 5</div>
                <div class="label">Average rating</div>
            </div>
        </div>

        <% if (feedbackList.isEmpty()) { %>
            <div class="empty-state">
                <h2>No feedback yet</h2>
                <p>Once citizens submit feedback, it will appear here.</p>
            </div>
        <% } else { %>
            <% for (Feedback f : feedbackList) { %>
            <div class="record-card">
                <div class="record-row">
                    <span class="label">Submitted by</span>
                    <span><strong><%= SecurityUtil.escapeHtml(f.getName()) %></strong> &lt;<%= SecurityUtil.escapeHtml(f.getEmail()) %>&gt;</span>
                </div>
                <div class="record-row">
                    <span class="label">Category</span>
                    <span><%= SecurityUtil.escapeHtml(f.getCategory()) %></span>
                </div>
                <div class="record-row">
                    <span class="label">Rating</span>
                    <span style="color:#f5a623;">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <i class="fa-solid fa-star" aria-hidden="true" style="<%= i <= f.getRating() ? "" : "opacity:0.25;" %>"></i>
                        <% } %>
                    </span>
                </div>
                <div class="record-row">
                    <span class="label">Message</span>
                    <span style="max-width: 75%; text-align: right;"><%= SecurityUtil.escapeHtml(f.getMessage()) %></span>
                </div>
                <div class="record-row">
                    <span class="label">Submitted on</span>
                    <span><%= f.getCreatedAt() %></span>
                </div>
            </div>
            <% } %>
        <% } %>
    </main>
</div>

</body>
</html>
