<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.Suspect" %>
<%@ page import="com.cybershield.model.Threat" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}

String queried = (String) request.getAttribute("queried");
Suspect suspect = (Suspect) request.getAttribute("suspect");
Threat threat = (Threat) request.getAttribute("threat");
String error = (String) request.getAttribute("error");
Integer corroborationCount = (Integer) request.getAttribute("corroborationCount");
Boolean alreadyCorroborated = (Boolean) request.getAttribute("alreadyCorroborated");
if (corroborationCount == null) corroborationCount = 0;
if (alreadyCorroborated == null) alreadyCorroborated = false;
boolean justCorroborated = "true".equals(request.getParameter("corroborated"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Check Suspect - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="suspect-check" />
    </jsp:include>

    <main class="portal-main">
        <h1>Report &amp; Check Suspect</h1>
        <p class="page-sub">Suspect Repository — check whether an email, mobile number, or URL has already been flagged by other citizens before you engage with it.</p>

        <div class="card" style="max-width: 680px;">
            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <form action="../SuspectCheckServlet" method="post">
                <div class="form-group">
                    <label>Email, mobile number, or URL to check</label>
                    <input type="text" name="identifierValue" class="form-control" placeholder="e.g. scammer@example.com, +91XXXXXXXXXX, or https://suspicious-site.com" required
                           value="<%= queried != null ? SecurityUtil.escapeHtml(queried) : "" %>">
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> Check suspect
                </button>
            </form>
        </div>

        <% if (queried != null) { %>
            <div class="card" style="max-width: 680px; margin-top: 20px;">
                <h3 style="margin-top:0;">Result for "<%= SecurityUtil.escapeHtml(queried) %>"</h3>

                <% if (suspect == null && threat == null) { %>
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                        No prior reports found for this identifier in our Suspect Repository or Threat Intelligence records.
                        This does not guarantee it is safe — stay cautious with any unsolicited request for money or personal details.
                    </div>
                <% } else { %>
                    <div class="alert alert-error">
                        <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i>
                        This identifier has been previously reported. Proceed with extreme caution.
                    </div>

                    <% if (suspect != null) { %>
                        <div class="record-card risk-border-high">
                            <div class="record-row">
                                <span class="label">Identifier type</span>
                                <span><%= SecurityUtil.escapeHtml(suspect.getIdentifierType()) %></span>
                            </div>
                            <div class="record-row">
                                <span class="label">Times reported</span>
                                <span class="badge rejected"><%= suspect.getReportCount() %> report(s)</span>
                            </div>
                            <div class="record-row">
                                <span class="label">Community confidence</span>
                                <span class="badge rejected"><%= corroborationCount %> citizen(s) confirm this</span>
                            </div>
                            <% if (suspect.getPlatform() != null && !suspect.getPlatform().isEmpty()) { %>
                            <div class="record-row">
                                <span class="label">Platform</span>
                                <span><%= SecurityUtil.escapeHtml(suspect.getPlatform()) %></span>
                            </div>
                            <% } %>
                            <div class="record-row">
                                <span class="label">Status</span>
                                <span><%= SecurityUtil.escapeHtml(suspect.getStatus()) %></span>
                            </div>
                        </div>

                        <% if (justCorroborated) { %>
                            <div class="alert alert-success" style="margin-top:12px;">Thanks — your confirmation has been added to the community trust score.</div>
                        <% } else if (alreadyCorroborated) { %>
                            <div class="alert alert-info" style="margin-top:12px;">You've already confirmed this suspect before.</div>
                        <% } else { %>
                            <form action="../SuspectCorroborateServlet" method="post" style="margin-top:12px;">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="suspectId" value="<%= suspect.getSuspectId() %>">
                                <input type="hidden" name="identifierValue" value="<%= SecurityUtil.escapeHtml(queried) %>">
                                <button type="submit" class="btn btn-secondary">
                                    <i class="fa-solid fa-people-group" aria-hidden="true"></i> I got this too — confirm this suspect
                                </button>
                            </form>
                        <% } %>
                    <% } %>

                    <% if (threat != null) { %>
                        <div class="record-card risk-border-high" style="margin-top:12px;">
                            <div class="record-row">
                                <span class="label">Also in threat intelligence</span>
                                <span class="badge rejected"><%= threat.getReportCount() %> report(s)</span>
                            </div>
                        </div>
                    <% } %>

                    <p style="margin-top:16px;">
                        <a href="suspect-report.jsp" class="btn btn-secondary">
                            <i class="fa-solid fa-flag" aria-hidden="true"></i> Add your own report for this suspect
                        </a>
                    </p>
                <% } %>
            </div>
        <% } %>
    </main>
</div>

</body>
</html>
