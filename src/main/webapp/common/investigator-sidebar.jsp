<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    String active = request.getParameter("active");
    if (active == null) active = "";
    String caseId = request.getParameter("id");
    String caseLink = (caseId != null && !caseId.trim().isEmpty())
            ? ctx + "/investigator/case-detail.jsp?id=" + caseId
            : ctx + "/investigator/dashboard.jsp";
%>
<aside class="portal-sidebar" id="portalSidebar">
    <div class="portal-sidebar-brand">
        <i class="fa-solid fa-user-shield" style="color:var(--cs-saffron);" aria-hidden="true"></i>
        CyberShield Investigator
    </div>
    <nav class="portal-nav" aria-label="Investigator portal navigation">
        <a href="<%= ctx %>/investigator/dashboard.jsp" data-section="dashboard" class="<%= "dashboard".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-chart-line" aria-hidden="true"></i> My cases
        </a>
        <a href="<%= caseLink %>#case-details" data-section="case-details" class="<%= "case-details".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-file-lines" aria-hidden="true"></i> Case Details
        </a>
        <a href="<%= caseLink %>#submit-report" data-section="submit-report" class="<%= "submit-report".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-paper-plane" aria-hidden="true"></i> Submit Investigation Report
        </a>
        <a href="<%= caseLink %>#upload-evidence" data-section="upload-evidence" class="<%= "upload-evidence".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-paperclip" aria-hidden="true"></i> Upload Investigation Evidence
        </a>
        <a href="<%= caseLink %>#update-status" data-section="update-status" class="<%= "update-status".equals(active) ? "active" : "" %>">
            <i class="fa-solid fa-arrows-rotate" aria-hidden="true"></i> Update Case Status
        </a>
        <a href="<%= ctx %>/LogoutServlet" class="logout">
            <i class="fa-solid fa-right-from-bracket" aria-hidden="true"></i> Sign out
        </a>
    </nav>
</aside>
<script>
(function () {
    var links = document.querySelectorAll('.portal-nav a[data-section]');
    function syncActive() {
        var hash = window.location.hash.replace('#', '');
        if (!hash) return;
        var matched = false;
        links.forEach(function (link) {
            if (link.getAttribute('data-section') === hash) {
                link.classList.add('active');
                matched = true;
            } else {
                link.classList.remove('active');
            }
        });
        if (matched) {
            var dashboardLink = document.querySelector('.portal-nav a[data-section="dashboard"]');
            if (dashboardLink) dashboardLink.classList.remove('active');
        }
    }
    syncActive();
    window.addEventListener('hashchange', syncActive);
})();
</script>
