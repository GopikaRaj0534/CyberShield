<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.UserDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User investigator = (User) session.getAttribute("loggedUser");
if (investigator == null || !"INVESTIGATOR".equals(investigator.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

int complaintId;
try {
    complaintId = Integer.parseInt(request.getParameter("id"));
} catch (Exception e) {
    response.sendRedirect("dashboard.jsp");
    return;
}

ComplaintDAO complaintDAO = new ComplaintDAO();
Complaint c = complaintDAO.getComplaintById(complaintId);

if (c == null || c.getAssignedInvestigatorId() == null || c.getAssignedInvestigatorId() != investigator.getUserId()) {
    response.sendRedirect("dashboard.jsp?err=not_yours");
    return;
}

UserDAO userDAO = new UserDAO();
User citizen = userDAO.getUserById(c.getUserId());
String error = request.getParameter("err");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Case #<%= complaintId %> - CyberShield Investigator</title>
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
        <a href="dashboard.jsp" class="card-arrow" style="display:inline-block; margin-bottom:16px;">&larr; Back to my cases</a>
        <h1>Case #<%= complaintId %></h1>
        <p class="page-sub">Full victim and complaint details handed over by the administration team.</p>

        <% if ("save_failed".equals(error)) { %>
            <div class="alert alert-error">Failed to save your findings. Please try again.</div>
        <% } %>

        <div class="card" style="max-width: 760px;" id="case-details">
            <h3 style="margin-top:0;">Victim details</h3>
            <% if ("YES".equalsIgnoreCase(c.getAnonymous())) { %>
                <div class="alert alert-info">This citizen filed anonymously. Their identity is available to you as the assigned investigator for the purpose of this case, but should be handled confidentially.</div>
            <% } %>
            <div class="record-row">
                <span class="label">Name</span>
                <span><%= citizen != null ? SecurityUtil.escapeHtml(citizen.getName()) : "Unknown" %></span>
            </div>
            <div class="record-row">
                <span class="label">Email</span>
                <span><%= citizen != null ? SecurityUtil.escapeHtml(citizen.getEmail()) : "Unknown" %></span>
            </div>
            <div class="record-row">
                <span class="label">Phone</span>
                <span><%= (citizen != null && citizen.getPhone() != null && !citizen.getPhone().trim().isEmpty()) ? SecurityUtil.escapeHtml(citizen.getPhone()) : "Not provided" %></span>
            </div>
        </div>

        <div class="card" style="max-width: 760px; margin-top:20px;">
            <h3 style="margin-top:0;">Complaint details</h3>
            <div class="record-row">
                <span class="label">Category</span>
                <span><%= SecurityUtil.escapeHtml(c.getComplaintType()) %><%= c.getSubType() != null ? " / " + SecurityUtil.escapeHtml(c.getSubType()) : "" %></span>
            </div>
            <div class="record-row">
                <span class="label">District</span>
                <span><%= c.getDistrict() != null ? SecurityUtil.escapeHtml(c.getDistrict()) : "-" %></span>
            </div>
            <div class="record-row">
                <span class="label">Description</span>
                <span style="max-width:70%; text-align:right;"><%= SecurityUtil.escapeHtml(c.getDescription()) %></span>
            </div>
            <% if (c.getSuspectUrl() != null && !c.getSuspectUrl().isEmpty()) { %>
            <div class="record-row"><span class="label">Suspect URL</span><span><%= SecurityUtil.escapeHtml(c.getSuspectUrl()) %></span></div>
            <% } %>
            <% if (c.getSuspectEmail() != null && !c.getSuspectEmail().isEmpty()) { %>
            <div class="record-row"><span class="label">Suspect email</span><span><%= SecurityUtil.escapeHtml(c.getSuspectEmail()) %></span></div>
            <% } %>
            <% if (c.getSuspectUpiId() != null && !c.getSuspectUpiId().isEmpty()) { %>
            <div class="record-row"><span class="label">Suspect UPI ID</span><span><%= SecurityUtil.escapeHtml(c.getSuspectUpiId()) %></span></div>
            <% } %>
            <% if (c.getSuspectBankAccount() != null && !c.getSuspectBankAccount().isEmpty()) { %>
            <div class="record-row"><span class="label">Suspect bank account</span><span><%= SecurityUtil.escapeHtml(c.getSuspectBankAccount()) %></span></div>
            <% } %>
            <div class="record-row">
                <span class="label">AI risk level</span>
                <span class="<%= "HIGH".equals(c.getRiskLevel()) ? "risk-high" : "MEDIUM".equals(c.getRiskLevel()) ? "risk-medium" : "risk-low" %>"><%= c.getRiskLevel() %></span>
            </div>
            <% if (c.getEvidencePath() != null && !c.getEvidencePath().isEmpty()) { %>
            <div class="record-row">
                <span class="label">Citizen's evidence</span>
                <a href="../<%= c.getEvidencePath() %>" target="_blank" class="evidence-btn"><i class="fa-solid fa-paperclip" aria-hidden="true"></i> View attachment</a>
            </div>
            <% } %>
        </div>

        <div class="card" style="max-width: 760px; margin-top:20px;">
            <h3 style="margin-top:0;">Submit your findings</h3>
            <% if (c.getInvestigationReport() != null) { %>
                <div class="alert alert-info">You already submitted findings for this case on <%= c.getInvestigationSubmittedAt() %>. Submitting again will update them.</div>
            <% } %>
            <form action="../InvestigatorReportServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                <input type="hidden" name="complaintId" value="<%= complaintId %>">

                <div class="form-group" id="submit-report">
                    <label>Investigation findings</label>
                    <textarea name="findings" class="form-control" style="height:140px; resize:none;" placeholder="Describe what you found during the investigation..." required><%= c.getInvestigationReport() != null ? SecurityUtil.escapeHtml(c.getInvestigationReport()) : "" %></textarea>
                </div>

                <div class="form-group" id="upload-evidence">
                    <label>Attach supporting evidence (optional)</label>
                    <input type="file" name="evidenceFile" class="form-control" style="border-style:dashed; cursor:pointer;">
                </div>

                <div class="form-group" id="update-status">
                    <label>Recommended case status</label>
                    <select name="recommendedStatus" class="form-control">
                        <option value="">-- Leave status unchanged --</option>
                        <option value="Under Investigation">Still under investigation</option>
                        <option value="Resolved">Resolved</option>
                        <option value="Rejected">Rejected / not substantiated</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fa-solid fa-paper-plane" aria-hidden="true"></i> Submit findings to admin &amp; citizen
                </button>
            </form>
        </div>
    </main>
</div>

</body>
</html>
