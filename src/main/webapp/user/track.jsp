<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}

Complaint complaint = null;
String id = request.getParameter("id");

if (id != null && !id.trim().isEmpty()) {
    try {
        ComplaintDAO dao = new ComplaintDAO();
        complaint = dao.getComplaintById(Integer.parseInt(id.trim()));
    } catch (NumberFormatException e) {
        // Handled below
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Complaint - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
    <style>
        /* Timeline component — specific to the tracking view */
        .track-form {
            display: flex;
            gap: 10px;
            margin-bottom: 28px;
        }

        .track-form input { flex: 1; }

        .divider {
            border: 0;
            border-top: 1px solid var(--cs-border-light);
            margin-bottom: 28px;
        }

        .info-card {
            background: var(--cs-bg-alt);
            padding: 16px;
            border-radius: var(--cs-radius);
            margin-bottom: 25px;
            font-size: 14.5px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .info-row:last-child { margin-bottom: 0; }

        .timeline {
            display: flex;
            flex-direction: column;
            gap: 20px;
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10px;
            width: 2px;
            height: 100%;
            background: var(--cs-border);
        }

        .timeline-step {
            position: relative;
            background: var(--cs-bg-alt);
            padding: 18px;
            border-radius: var(--cs-radius-lg);
            border: 1px solid var(--cs-border-light);
        }

        .timeline-step::before {
            content: '●';
            position: absolute;
            top: 18px;
            left: -27px;
            font-size: 20px;
            color: var(--cs-text-light);
            background: var(--cs-bg);
            line-height: 1;
        }

        .timeline-step.completed::before {
            content: '\2713';
            font-weight: bold;
            font-size: 14px;
            color: white;
            background: var(--cs-success);
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            left: -31px;
            top: 18px;
        }

        .timeline-step.active::before {
            content: '\23F1';
            font-size: 14px;
            color: var(--cs-navy);
            background: var(--cs-saffron);
            width: 22px;
            height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            left: -31px;
            top: 18px;
            box-shadow: 0 0 0 4px var(--cs-saffron-light);
        }

        .step-title {
            font-family: var(--cs-font-display);
            font-size: 16px;
            font-weight: 700;
            color: var(--cs-navy);
            margin-bottom: 5px;
        }

        .step-desc {
            font-size: 14px;
            color: var(--cs-text-muted);
        }
    </style>
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="track" />
    </jsp:include>

    <main class="portal-main">
        <h1>Track case status</h1>
        <p class="page-sub">Enter a complaint ID to view its investigation timeline.</p>

        <div class="card" style="max-width: 650px;">
            <form method="get" action="track.jsp" class="track-form">
                <input type="number" name="id" class="form-control" placeholder="Enter complaint ID (e.g. 1)" value="<%= id != null ? SecurityUtil.escapeHtml(id) : "" %>" required>
                <button type="submit" class="btn btn-primary">Track incident</button>
            </form>

            <hr class="divider">

            <%
            if (id != null) {
                if (complaint != null) {
                    // Check if it belongs to the user or if they are admin, or if it is anonymous
                    // To be safe, we allow tracking if the complaint belongs to loggedUser or admin or if it is valid.
                    if (complaint.getUserId() == user.getUserId() || "ADMIN".equals(user.getRole())) {
            %>
                    <div class="info-card">
                        <div class="info-row">
                            <span style="font-weight: 700; color: var(--cs-navy);">Complaint ID:</span>
                            <span>#<%= complaint.getComplaintId() %></span>
                        </div>
                        <div class="info-row">
                            <span style="font-weight: 700; color: var(--cs-navy);">Category:</span>
                            <span><%= SecurityUtil.escapeHtml(complaint.getComplaintType()) %></span>
                        </div>
                        <div class="info-row">
                            <span style="font-weight: 700; color: var(--cs-navy);">Assigned risk level:</span>
                            <span class="<%= "HIGH".equals(complaint.getRiskLevel()) ? "risk-high" : ("MEDIUM".equals(complaint.getRiskLevel()) ? "risk-medium" : "risk-low") %>">
                                <%= complaint.getRiskLevel() %>
                            </span>
                        </div>
                    </div>

                    <div class="timeline">
                        <!-- Step 1: Submit -->
                        <div class="timeline-step completed">
                            <div class="step-title">Complaint submitted successfully</div>
                            <div class="step-desc">The incident details were filed in the secure CyberShield threat database.</div>
                        </div>

                        <!-- Step 2: AI Check -->
                        <div class="timeline-step completed">
                            <div class="step-title">Machine learning scan completed</div>
                            <div class="step-desc">
                                AI risk classification engine scanned the suspect assets.<br>
                                <% if (complaint.getAiExplanation() != null && !complaint.getAiExplanation().isEmpty()) { %>
                                    <span style="font-style: italic; color: var(--cs-text-muted); font-size: 13px;">Reasoning: <%= SecurityUtil.escapeHtml(complaint.getAiExplanation()) %></span>
                                <% } %>
                            </div>
                        </div>

                        <!-- Step 3: Admin Actions -->
                        <%
                        boolean isInvestigating = "Under Investigation".equalsIgnoreCase(complaint.getStatus());
                        boolean isResolved = "Resolved".equalsIgnoreCase(complaint.getStatus());
                        boolean isRejected = "Rejected".equalsIgnoreCase(complaint.getStatus());
                        %>
                        <div class="timeline-step <%= (isInvestigating || isResolved || isRejected) ? "completed" : "active" %>">
                            <div class="step-title">
                                <% if (isInvestigating) { %>
                                    Case under investigation
                                <% } else if (isResolved) { %>
                                    Case investigation completed
                                <% } else if (isRejected) { %>
                                    Case review rejected
                                <% } else { %>
                                    Pending administrative review
                                <% } %>
                            </div>
                            <div class="step-desc">
                                <% if (isInvestigating) { %>
                                    Case has been verified and routed to field investigation team.<br>
                                    <% if (complaint.getAssignedTo() != null && !complaint.getAssignedTo().isEmpty()) { %>
                                        <strong>Assigned officer:</strong> <%= SecurityUtil.escapeHtml(complaint.getAssignedTo()) %><br>
                                    <% } %>
                                    <% if (complaint.getInvestigationReport() != null && !complaint.getInvestigationReport().isEmpty()) { %>
                                        <strong>Investigation findings:</strong> <%= SecurityUtil.escapeHtml(complaint.getInvestigationReport()) %><br>
                                    <% } %>
                                    <% if (complaint.getRemarks() != null && !complaint.getRemarks().isEmpty()) { %>
                                        <strong>Officer remarks:</strong> <%= SecurityUtil.escapeHtml(complaint.getRemarks()) %>
                                    <% } %>
                                <% } else if (isResolved || isRejected) { %>
                                    Administrator finalized incident reviews and updated state.<br>
                                    <% if (complaint.getInvestigationReport() != null && !complaint.getInvestigationReport().isEmpty()) { %>
                                        <strong>Investigation findings:</strong> <%= SecurityUtil.escapeHtml(complaint.getInvestigationReport()) %><br>
                                    <% } %>
                                    <% if (complaint.getRemarks() != null && !complaint.getRemarks().isEmpty()) { %>
                                        <strong>Closing remarks:</strong> <%= SecurityUtil.escapeHtml(complaint.getRemarks()) %>
                                    <% } %>
                                <% } else { %>
                                    Incident log is awaiting assignment to a cyber investigation officer.
                                <% } %>
                            </div>
                        </div>

                        <!-- Step 4: Resolution -->
                        <% if (isResolved) { %>
                        <div class="timeline-step completed">
                            <div class="step-title">Incident resolved</div>
                            <div class="step-desc">Case has been closed. Actions have been completed regarding suspect vectors.</div>
                        </div>
                        <% } else if (isRejected) { %>
                        <div class="timeline-step completed">
                            <div class="step-title">Case rejected</div>
                            <div class="step-desc">Incident was flagged as invalid or duplicate. Investigation terminated.</div>
                        </div>
                        <% } %>
                    </div>
            <%
                    } else {
            %>
                        <div class="alert alert-error">Access denied: you do not have permission to track this complaint ID.</div>
            <%
                    }
                } else {
            %>
                    <div class="alert alert-error">Incident ID #<%= SecurityUtil.escapeHtml(id) %> not found in database. Check the number and try again.</div>
            <%
                }
            }
            %>
        </div>
    </main>
</div>

</body>
</html>
