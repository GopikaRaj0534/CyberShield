<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}

ComplaintDAO dao = new ComplaintDAO();
int pending = dao.countByUserAndStatus(user.getUserId(), "Pending");
int resolved = dao.countByUserAndStatus(user.getUserId(), "Resolved");
int investigating = dao.countByUserAndStatus(user.getUserId(), "Under Investigation");
int total = pending + resolved + investigating;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <main class="portal-main">
        <h1>Welcome, <%= user.getName() %></h1>
        <p class="page-sub">Manage your cybercrime complaints securely.</p>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="label">Total complaints</div>
                <div class="value"><%= total %></div>
            </div>
            <div class="stat-card">
                <div class="label">Pending</div>
                <div class="value"><%= pending %></div>
            </div>
            <div class="stat-card">
                <div class="label">Resolved</div>
                <div class="value"><%= resolved %></div>
            </div>
        </div>

        <div style="display:flex; gap:16px; flex-wrap:wrap;">
            <a href="complaint.jsp" class="btn btn-primary">
                <i class="fa-solid fa-plus" aria-hidden="true"></i> Report cyber crime
            </a>
            <a href="mycomplaints.jsp" class="btn btn-secondary">View complaints</a>
        </div>
    </main>
</div>

</body>
</html>
