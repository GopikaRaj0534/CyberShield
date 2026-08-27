<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}

String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Suspect - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="suspect-report" />
    </jsp:include>

    <main class="portal-main">
        <h1>Report a suspect</h1>
        <p class="page-sub">Report a suspicious email, mobile number, URL, or social media handle — including abuse that should be flagged to the platform it originated on.</p>

        <div class="card" style="max-width: 680px;">
            <div class="alert alert-info">
                This adds the suspect to our shared Suspect Repository so other citizens are warned via Check Suspect. It does not replace filing a formal complaint for financial loss or serious crimes — use <a href="complaint.jsp">Report crime</a> for that.
            </div>

            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <form action="../SuspectReportServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

                <div class="form-group">
                    <label>Identifier type</label>
                    <select name="identifierType" class="form-control" required>
                        <option value="">-- Select type --</option>
                        <option value="EMAIL">Email address</option>
                        <option value="MOBILE">Mobile number</option>
                        <option value="URL">Website / URL</option>
                        <option value="SOCIAL_HANDLE">Social media handle</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Suspect's email, mobile, URL, or handle</label>
                    <input type="text" name="identifierValue" class="form-control" placeholder="e.g. scammer@example.com or @suspicious_handle" required>
                </div>

                <div class="form-group">
                    <label>Report category</label>
                    <select name="reportCategory" class="form-control" required>
                        <option value="">-- Select category --</option>
                        <option>Social Media Abuse</option>
                        <option>Scam Call / SMS</option>
                        <option>Fake Profile / Impersonation</option>
                        <option>Phishing Attempt</option>
                        <option>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Platform (if applicable)</label>
                    <input type="text" name="platform" class="form-control" placeholder="e.g. Instagram, WhatsApp, Facebook">
                </div>

                <div class="form-group">
                    <label>Details</label>
                    <textarea name="details" class="form-control" style="height:110px; resize:none;" placeholder="Describe what happened..."></textarea>
                </div>

                <div class="form-group">
                    <label>Attach evidence (screenshot, PDF)</label>
                    <input type="file" name="evidenceFile" class="form-control" accept="image/*,application/pdf" style="border-style:dashed; cursor:pointer;">
                </div>

                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fa-solid fa-flag" aria-hidden="true"></i> Submit suspect report
                </button>
            </form>
        </div>

        <p style="margin-top:16px;">
            <a href="suspect-check.jsp" class="card-arrow">Check a suspect instead &rarr;</a>
            &nbsp;|&nbsp;
            <a href="my-suspect-reports.jsp" class="card-arrow">View my reported suspects &rarr;</a>
        </p>
    </main>
</div>

</body>
</html>
