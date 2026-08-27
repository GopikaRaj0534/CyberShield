<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.SuspectReport" %>
<%@ page import="com.cybershield.dao.SuspectDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}

SuspectDAO dao = new SuspectDAO();
List<SuspectReport> myReports = dao.getReportsByUser(user.getUserId());
boolean submitted = "true".equals(request.getParameter("submitted"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Reported Suspects - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="my-suspect-reports" />
    </jsp:include>

    <main class="portal-main">
        <h1>My reported suspects</h1>
        <p class="page-sub">Every suspect you've flagged through the Suspect Repository, and how many other citizens have also reported them.</p>

        <% if (submitted) { %>
            <div class="alert alert-success">Your suspect report has been added to the repository. Thank you for helping protect other citizens.</div>
        <% } %>

        <a href="suspect-report.jsp" class="btn btn-primary" style="margin-bottom: 25px;">
            <i class="fa-solid fa-flag" aria-hidden="true"></i> Report another suspect
        </a>

        <% if (myReports.isEmpty()) { %>
            <div class="empty-state">
                <h2>No suspects reported yet</h2>
                <p>Use Report Suspect to flag a suspicious email, mobile number, URL, or social media handle.</p>
            </div>
        <% } else { %>
            <% for (SuspectReport r : myReports) { %>
            <div class="record-card">
                <div class="record-row">
                    <span class="label">Suspect identifier</span>
                    <span><strong><%= SecurityUtil.escapeHtml(r.getIdentifierValue()) %></strong> <span style="color:var(--cs-text-muted); font-size:12px;">(<%= SecurityUtil.escapeHtml(r.getIdentifierType()) %>)</span></span>
                </div>
                <div class="record-row">
                    <span class="label">Report category</span>
                    <span><%= SecurityUtil.escapeHtml(r.getReportCategory()) %></span>
                </div>
                <% if (r.getPlatform() != null && !r.getPlatform().isEmpty()) { %>
                <div class="record-row">
                    <span class="label">Platform</span>
                    <span><%= SecurityUtil.escapeHtml(r.getPlatform()) %></span>
                </div>
                <% } %>
                <% if (r.getDetails() != null && !r.getDetails().isEmpty()) { %>
                <div class="record-row">
                    <span class="label">Details</span>
                    <span style="max-width: 75%; text-align: right;"><%= SecurityUtil.escapeHtml(r.getDetails()) %></span>
                </div>
                <% } %>
                <% if (r.getEvidencePath() != null && !r.getEvidencePath().isEmpty()) { %>
                <div class="record-row">
                    <span class="label">Evidence file</span>
                    <a href="../<%= r.getEvidencePath() %>" target="_blank" class="evidence-btn">
                        <i class="fa-solid fa-paperclip" aria-hidden="true"></i> View evidence attachment
                    </a>
                </div>
                <% } %>
                <div class="record-row">
                    <span class="label">Reported on</span>
                    <span><%= r.getCreatedAt() %></span>
                </div>
            </div>
            <% } %>
        <% } %>
    </main>
</div>

</body>
</html>
