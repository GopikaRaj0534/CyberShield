<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String active = request.getParameter("active");
    if (active == null) active = "";
%>
<aside class="portal-sidebar" id="portalSidebar">
    <div class="portal-sidebar-brand">
        <i class="fa-solid fa-shield-halved" style="color:var(--cs-saffron);" aria-hidden="true"></i>
        CyberShield Admin
    </div>
    <nav class="portal-nav" aria-label="Admin portal navigation">
        <a href="<%= ctx %>/admin/dashboard.jsp" class="<%= "dashboard".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-chart-line" aria-hidden="true"></i> Dashboard
        </a>
        <a href="<%= ctx %>/admin/complaints.jsp" class="<%= "complaints".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-folder-tree" aria-hidden="true"></i> Complaints
        </a>
        <a href="<%= ctx %>/admin/users.jsp" class="<%= "users".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-users" aria-hidden="true"></i> Citizens
        </a>
        <a href="<%= ctx %>/admin/investigators.jsp" class="<%= "investigators".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-user-shield" aria-hidden="true"></i> Investigation officers
        </a>
        <a href="<%= ctx %>/admin/threats.jsp" class="<%= "threats".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-virus" aria-hidden="true"></i> Threat intel
        </a>
        <a href="<%= ctx %>/admin/feedback.jsp" class="<%= "feedback".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-comment-dots" aria-hidden="true"></i> Feedback
        </a>
        <a href="<%= ctx %>/LogoutServlet" class="logout">
            <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i> Sign out
        </a>
    </nav>
</aside>
