<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%@ page import="java.util.List" %>

<%
User investigator = (User) session.getAttribute("loggedUser");
if (investigator == null || !"INVESTIGATOR".equals(investigator.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

ComplaintDAO dao = new ComplaintDAO();
List<Complaint> cases = dao.getComplaintsAssignedToInvestigator(investigator.getUserId());
boolean submitted = "true".equals(request.getParameter("submitted"));

int pendingCount = 0, resolvedCount = 0;
for (Complaint c : cases) {
    if ("Resolved".equalsIgnoreCase(c.getStatus()) || "Rejected".equalsIgnoreCase(c.getStatus())) resolvedCount++;
    else pendingCount++;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cases - CyberShield Investigator</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/investigator-sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <main class="portal-main">
        <h1>Welcome, <%= SecurityUtil.escapeHtml(investigator.getName()) %></h1>
        <p class="page-sub">Cases the administration team has handed over to you for investigation.</p>

        <% if (submitted) { %>
            <div class="alert alert-success">Your findings were submitted and the citizen has been notified.</div>
        <% } %>

        <div class="hero-stats" style="margin: 20px 0 30px;">
            <div class="hero-stat">
                <div class="num"><%= cases.size() %></div>
                <div class="label">Total cases assigned</div>
            </div>
            <div class="hero-stat">
                <div class="num"><%= pendingCount %></div>
                <div class="label">Awaiting your findings</div>
            </div>
            <div class="hero-stat">
                <div class="num"><%= resolvedCount %></div>
                <div class="label">Closed</div>
            </div>
        </div>

        <% if (cases.isEmpty()) { %>
            <div class="empty-state">
                <h2>No cases assigned yet</h2>
                <p>Once the administration team hands you a case, it will appear here with full victim and complaint details.</p>
            </div>
        <% } else { %>
            <% for (Complaint c : cases) { %>
            <div class="record-card">
                <div class="record-row">
                    <span class="label">Complaint</span>
                    <span><strong>#<%= c.getComplaintId() %></strong> — <%= SecurityUtil.escapeHtml(c.getComplaintType()) %><%= c.getSubType() != null ? " / " + SecurityUtil.escapeHtml(c.getSubType()) : "" %></span>
                </div>
                <div class="record-row">
                    <span class="label">District</span>
                    <span><%= c.getDistrict() != null ? SecurityUtil.escapeHtml(c.getDistrict()) : "-" %></span>
                </div>
                <div class="record-row">
                    <span class="label">AI risk level</span>
                    <span class="<%= "HIGH".equals(c.getRiskLevel()) ? "risk-high" : "MEDIUM".equals(c.getRiskLevel()) ? "risk-medium" : "risk-low" %>"><%= c.getRiskLevel() %></span>
                </div>
                <%
                    String statusBadgeClass = "pending";
                    if ("Resolved".equalsIgnoreCase(c.getStatus())) statusBadgeClass = "resolved";
                    else if ("Rejected".equalsIgnoreCase(c.getStatus())) statusBadgeClass = "rejected";
                    else if ("Under Investigation".equalsIgnoreCase(c.getStatus())) statusBadgeClass = "investigation";
                %>
                <div class="record-row">
                    <span class="label">Status</span>
                    <span class="badge <%= statusBadgeClass %>"><%= c.getStatus() %></span>
                </div>
                <div class="record-row">
                    <span class="label">Your findings</span>
                    <span><%= c.getInvestigationReport() != null ? "Submitted" : "Not submitted yet" %></span>
                </div>
                <div style="margin-top:12px;">
                    <a href="case-detail.jsp?id=<%= c.getComplaintId() %>" class="btn btn-primary">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> View case &amp; submit findings
                    </a>
                </div>
            </div>
            <% } %>
        <% } %>
    </main>
</div>

</body>
</html>
