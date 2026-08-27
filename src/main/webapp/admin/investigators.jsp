<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.UserDAO" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.ComplaintFeedbackDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%@ page import="java.util.List" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

UserDAO userDAO = new UserDAO();
ComplaintDAO complaintDAO = new ComplaintDAO();
ComplaintFeedbackDAO feedbackDAO = new ComplaintFeedbackDAO();
List<User> investigators = userDAO.getUsersByRole("INVESTIGATOR");
boolean created = "true".equals(request.getParameter("created"));
String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Investigation Officers - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
    <style>
        .remove-btn {
            background: var(--cs-danger);
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: var(--cs-radius);
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: background var(--cs-transition);
        }
        .remove-btn:hover { background: #8f1717; }
    </style>
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="investigators" />
    </jsp:include>

    <main class="portal-main">
        <h1>Investigation officers</h1>
        <p class="page-sub">Create accounts for investigation officers, then hand off cases to them from the Complaints page.</p>

        <% if (created) { %>
            <div class="alert alert-success">Investigation officer account created.</div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert alert-error"><%= SecurityUtil.escapeHtml(error) %></div>
        <% } %>

        

        <div class="data-table-box">
            <table>
                <tr>
                    <th>Officer ID</th>
                    <th>Name</th>
                    <th>Email address</th>
                    <th>Caseload</th>
                    <th>Avg. resolution time</th>
                    <th>Citizen rating</th>
                    <th>Actions</th>
                </tr>
                <% if (investigators.isEmpty()) { %>
                <tr><td colspan="7" style="text-align:center; color:var(--cs-text-light); padding:30px;">No investigation officers yet — create one above.</td></tr>
                <% } %>
                <%
                for (User inv : investigators) {
                    List<Complaint> caseload = complaintDAO.getComplaintsAssignedToInvestigator(inv.getUserId());
                    int openCount = 0, closedCount = 0;
                    long totalResolutionMillis = 0;
                    int resolutionSamples = 0;

                    for (Complaint cse : caseload) {
                        boolean isClosed = "Resolved".equalsIgnoreCase(cse.getStatus()) || "Rejected".equalsIgnoreCase(cse.getStatus());
                        if (isClosed) closedCount++; else openCount++;

                        if (cse.getAssignedAt() != null && cse.getInvestigationSubmittedAt() != null) {
                            totalResolutionMillis += (cse.getInvestigationSubmittedAt().getTime() - cse.getAssignedAt().getTime());
                            resolutionSamples++;
                        }
                    }

                    String avgResolutionDisplay = "No data yet";
                    if (resolutionSamples > 0) {
                        double avgHours = (totalResolutionMillis / (double) resolutionSamples) / (1000.0 * 60 * 60);
                        avgResolutionDisplay = avgHours < 24
                            ? String.format("%.1f hrs", avgHours)
                            : String.format("%.1f days", avgHours / 24.0);
                    }

                    double avgRating = feedbackDAO.getAverageRatingForInvestigator(inv.getUserId());
                    int ratedCount = feedbackDAO.getRatedCaseCountForInvestigator(inv.getUserId());
                %>
                <tr>
                    <td>#<%= inv.getUserId() %></td>
                    <td><strong><%= SecurityUtil.escapeHtml(inv.getName()) %></strong></td>
                    <td><%= SecurityUtil.escapeHtml(inv.getEmail()) %></td>
                    <td>
                        <%= caseload.size() %> total
                        <div style="font-size:11px; color:var(--cs-text-muted);"><%= openCount %> open &middot; <%= closedCount %> closed</div>
                    </td>
                    <td><%= avgResolutionDisplay %></td>
                    <td>
                        <% if (ratedCount > 0) { %>
                            <span style="color:#f5a623;">
                                <% int roundedRating = (int) Math.round(avgRating); %>
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="fa-solid fa-star" aria-hidden="true" style="<%= i <= roundedRating ? "" : "opacity:0.25;" %>"></i>
                                <% } %>
                            </span>
                            <div style="font-size:11px; color:var(--cs-text-muted);"><%= String.format("%.1f", avgRating) %> from <%= ratedCount %> case(s)</div>
                        <% } else { %>
                            <span style="color:var(--cs-text-light); font-size:12px;">No ratings yet</span>
                        <% } %>
                    </td>
                    <td>
                        <form action="../AdminInvestigatorServlet" method="post" onsubmit="return confirm('Remove this investigation officer account? Cases already assigned to them will keep their history.');">
                            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="userId" value="<%= inv.getUserId() %>">
                            <button type="submit" class="remove-btn">Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </main>
</div>

</body>
</html>
