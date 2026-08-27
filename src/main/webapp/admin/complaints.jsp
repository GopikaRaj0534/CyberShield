<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.UserDAO" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

ComplaintDAO dao = new ComplaintDAO();
UserDAO userDAO = new UserDAO();
List<User> investigators = userDAO.getUsersByRole("INVESTIGATOR");

String keyword = request.getParameter("keyword");
String status = request.getParameter("status");
String riskLevel = request.getParameter("riskLevel");

List<Complaint> complaints;
if (keyword != null || status != null || riskLevel != null) {
    complaints = dao.searchAndFilterComplaints(keyword, status, riskLevel);
} else {
    complaints = dao.getAllComplaints();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints pipeline - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="complaints" />
    </jsp:include>

    <main class="portal-main">
        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px; margin-bottom:28px;">
            <h1 style="margin-bottom:0;">Complaint management pipeline</h1>
            <div style="display:flex; gap:12px;">
                <a href="../AdminExportServlet" class="btn btn-primary" style="background: var(--cs-success); border-color: var(--cs-success);">
                    <i class="fa-solid fa-file-csv" aria-hidden="true"></i> Export Excel (CSV)
                </a>
                <a href="print_report.jsp" target="_blank" class="btn btn-secondary">
                    <i class="fa-solid fa-print" aria-hidden="true"></i> Print PDF report
                </a>
            </div>
        </div>

        <!-- Search and Filter Form -->
        <form method="get" action="complaints.jsp" class="filter-panel">
            <input type="text" name="keyword" placeholder="Search by description, URL, email..." value="<%= keyword != null ? SecurityUtil.escapeHtml(keyword) : "" %>">

            <select name="status">
                <option value="ALL">-- All statuses --</option>
                <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                <option value="Under Investigation" <%= "Under Investigation".equals(status) ? "selected" : "" %>>Under Investigation</option>
                <option value="Resolved" <%= "Resolved".equals(status) ? "selected" : "" %>>Resolved</option>
                <option value="Rejected" <%= "Rejected".equals(status) ? "selected" : "" %>>Rejected</option>
            </select>

            <select name="riskLevel">
                <option value="ALL">-- All risk levels --</option>
                <option value="HIGH" <%= "HIGH".equals(riskLevel) ? "selected" : "" %>>High risk</option>
                <option value="MEDIUM" <%= "MEDIUM".equals(riskLevel) ? "selected" : "" %>>Medium risk</option>
                <option value="LOW" <%= "LOW".equals(riskLevel) ? "selected" : "" %>>Low risk</option>
            </select>

            <button type="submit" class="btn btn-primary">Filter pipeline</button>
            <a href="complaints.jsp" class="clear-btn">Clear</a>
        </form>

        <div class="data-table-box">
            <table>
                <tr>
                    <th style="width: 5%">ID</th>
                    <th style="width: 15%">Filer citizen</th>
                    <th style="width: 25%">Complaint details</th>
                    <th style="width: 15%">Suspect details</th>
                    <th style="width: 15%">AI diagnostics</th>
                    <th style="width: 25%">Commit case updates</th>
                </tr>
                <%
                for (Complaint c : complaints) {
                    User reporter = userDAO.getUserById(c.getUserId());
                    String reporterName = (c.getAnonymous() != null && c.getAnonymous().equalsIgnoreCase("YES"))
                                          ? "<span style='color:var(--cs-text-muted); font-style:italic;'>Anonymous Citizen</span>"
                                          : (reporter != null ? "<strong>" + SecurityUtil.escapeHtml(reporter.getName()) + "</strong><br><span style='color:var(--cs-text-muted); font-size:11px;'>" + SecurityUtil.escapeHtml(reporter.getEmail()) + "</span>" : "Unknown");

                    String riskBadge = "risk-low";
                    if ("HIGH".equals(c.getRiskLevel())) riskBadge = "risk-high";
                    else if ("MEDIUM".equals(c.getRiskLevel())) riskBadge = "risk-medium";
                %>
                <tr>
                    <td>#<%= c.getComplaintId() %></td>
                    <td><%= reporterName %></td>
                    <td>
                        <strong><%= SecurityUtil.escapeHtml(c.getComplaintType()) %></strong>
                        <% if (c.getSubType() != null && !c.getSubType().isEmpty()) { %>
                            <br><span style="color:var(--cs-blue); font-size:12px; font-weight:600;"><%= SecurityUtil.escapeHtml(c.getSubType()) %></span>
                        <% } %>
                        <br>
                        <span style="color:var(--cs-text-muted); font-size:12px; display:block; margin-top:5px;"><%= SecurityUtil.escapeHtml(c.getDescription()) %></span>
                        <% if (c.getEvidencePath() != null && !c.getEvidencePath().isEmpty()) { %>
                            <a href="../<%= c.getEvidencePath() %>" target="_blank" class="evidence-btn" style="margin-top:6px;"><i class="fa-solid fa-paperclip" aria-hidden="true"></i> View evidence</a>
                        <% } %>
                    </td>
                    <td>
                        URL: <%= c.getSuspectUrl() != null && !c.getSuspectUrl().isEmpty() ? "<span style='color:var(--cs-danger); word-break:break-all; font-weight:600;'>" + SecurityUtil.escapeHtml(c.getSuspectUrl()) + "</span>" : "<span style='color:var(--cs-text-light);'>N/A</span>" %><br>
                        Email: <%= c.getSuspectEmail() != null && !c.getSuspectEmail().isEmpty() ? "<strong>" + SecurityUtil.escapeHtml(c.getSuspectEmail()) + "</strong>" : "<span style='color:var(--cs-text-light);'>N/A</span>" %>
                    </td>
                    <td>
                        Risk: <span class="<%= riskBadge %>"><%= c.getRiskLevel() %></span>
                        <% if (c.getAiExplanation() != null && !c.getAiExplanation().isEmpty()) { %>
                            <div style="font-size:12px; color:var(--cs-text-muted); background:var(--cs-bg-alt); border:1px solid var(--cs-border-light); padding:8px; border-radius:6px; margin-top:5px; max-width:250px;">
                                <i class="fa-solid fa-robot" aria-hidden="true"></i> <%= SecurityUtil.escapeHtml(c.getAiExplanation()) %>
                            </div>
                        <% } %>
                    </td>
                    <td>
                        <% if (c.getAssignedInvestigatorId() != null) { %>
                            <div style="margin-bottom:10px; font-size:12px;">
                                <span class="badge investigation">Assigned: <%= SecurityUtil.escapeHtml(c.getAssignedTo()) %></span>
                            </div>
                            <% if (c.getInvestigationReport() != null && !c.getInvestigationReport().isEmpty()) { %>
                                <div style="font-size:12px; color:var(--cs-text-muted); background:var(--cs-bg-alt); border:1px solid var(--cs-border-light); padding:8px; border-radius:6px; margin-bottom:10px; max-width:250px;">
                                    <i class="fa-solid fa-user-shield" aria-hidden="true"></i> <strong>Investigator findings:</strong> <%= SecurityUtil.escapeHtml(c.getInvestigationReport()) %>
                                </div>
                            <% } %>
                        <% } else if (!investigators.isEmpty()) { %>
                            <form action="../AdminAssignInvestigatorServlet" method="post" style="display:flex; gap:6px; margin-bottom:10px;">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                <select name="investigatorId" class="form-control" style="flex:1; padding:6px; font-size:12px;" required>
                                    <option value="">Assign to...</option>
                                    <% for (User inv : investigators) { %>
                                    <option value="<%= inv.getUserId() %>"><%= SecurityUtil.escapeHtml(inv.getName()) %></option>
                                    <% } %>
                                </select>
                                <button type="submit" class="btn btn-secondary" style="font-size:12px; padding:6px 10px;">Assign</button>
                            </form>
                        <% } else { %>
                            <p style="font-size:11px; color:var(--cs-text-light); margin-bottom:10px;">
                                <a href="investigators.jsp">Create an investigation officer</a> to assign cases.
                            </p>
                        <% } %>

                        <!-- Unified update form -->
                        <form action="../AdminComplaintServlet" method="post" style="display:flex; flex-direction:column; gap:8px;">
                            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                            <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">

                            <div style="display:flex; gap:8px;">
                                
                                <select name="status" class="form-control" style="flex:1; padding:6px; font-size:12px;">
                                    <option value="Pending" <%= "Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Under Investigation" <%= "Under Investigation".equals(c.getStatus()) ? "selected" : "" %>>Investigation</option>
                                    <option value="Resolved" <%= "Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                                    <option value="Rejected" <%= "Rejected".equals(c.getStatus()) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </div>

                            <input type="text" name="assignedTo" class="form-control" placeholder="Investigator name" value="<%= c.getAssignedTo() != null ? SecurityUtil.escapeHtml(c.getAssignedTo()) : "" %>" style="padding:6px; font-size:12px;">
                            

                            <button type="submit" class="btn btn-primary" style="font-size:12px; padding:6px 12px;">Commit updates</button>
                        </form>
                    </td>
                </tr>
                <%
                }
                %>
            </table>
        </div>
    </main>
</div>

</body>
</html>
