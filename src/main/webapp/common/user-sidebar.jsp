<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String active = request.getParameter("active");
    if (active == null) active = "";
%>
<aside class="portal-sidebar" id="portalSidebar">
    <div class="portal-sidebar-brand">
        <i class="fa-solid fa-shield-halved" style="color:var(--cs-saffron);" aria-hidden="true"></i>
        CyberShield
    </div>
    <nav class="portal-nav" aria-label="Citizen portal navigation">
        <a href="<%= ctx %>/user/dashboard.jsp" class="<%= "dashboard".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-house" aria-hidden="true"></i> Dashboard
        </a>
        <a href="<%= ctx %>/user/complaint.jsp" class="<%= "complaint".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i> Report crime
        </a>
        <a href="<%= ctx %>/user/mycomplaints.jsp" class="<%= "mycomplaints".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-folder-open" aria-hidden="true"></i> My complaints
        </a>
        <a href="<%= ctx %>/user/track.jsp" class="<%= "track".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> Track status
        </a>
        <a href="<%= ctx %>/user/suspect-check.jsp" class="<%= "suspect-check".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-binoculars" aria-hidden="true"></i> Check suspect
        </a>
        <a href="<%= ctx %>/user/suspect-report.jsp" class="<%= "suspect-report".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-flag" aria-hidden="true"></i> Report suspect
        </a>
        <a href="<%= ctx %>/user/my-suspect-reports.jsp" class="<%= "my-suspect-reports".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-list-check" aria-hidden="true"></i> My reported suspects
        </a>
        <a href="<%= ctx %>/learning/index.jsp">
            <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i> Learning corner
        </a>
        <a href="<%= ctx %>/feedback.jsp">
            <i class="fa-solid fa-comment-dots" aria-hidden="true"></i> Feedback
        </a>
        <a href="<%= ctx %>/user/profile.jsp" class="<%= "profile".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-user" aria-hidden="true"></i> My profile
        </a>
        <a href="<%= ctx %>/LogoutServlet" class="logout">
            <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i> Sign out
        </a>
    </nav>
</aside>
