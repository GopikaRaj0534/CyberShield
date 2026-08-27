<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.dao.ThreatDAO" %>
<%@ page import="com.cybershield.model.Threat" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

ThreatDAO dao = new ThreatDAO();
List<Threat> threats = dao.getAllThreats();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Threat Intel Panel - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
    <style>
        .threat-url {
            color: var(--cs-danger);
            font-family: 'Courier New', Courier, monospace;
            font-weight: bold;
        }
        .purge-btn {
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
        .purge-btn:hover { background: #8f1717; }
    </style>
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="threats" />
    </jsp:include>

    <main class="portal-main">
        <h1>Real-time vector threat intelligence</h1>
        <p class="page-sub">Suspect URLs and emails flagged across all citizen reports.</p>

        <div class="data-table-box">
            <table>
                <tr>
                    <th>Threat ID</th>
                    <th>Flagged suspect URL</th>
                    <th>Flagged attack email</th>
                    <th>Aggregated report count</th>
                    <th>System classification status</th>
                    <th>Administrative options</th>
                </tr>
                <%
                for (Threat t : threats) {
                %>
                <tr>
                    <td>#<%= t.getThreatId() %></td>
                    <td><span class="threat-url"><%= SecurityUtil.escapeHtml(t.getUrl()) %></span></td>
                    <td><%= t.getEmail() != null && !t.getEmail().isEmpty() ? SecurityUtil.escapeHtml(t.getEmail()) : "<span style='color:var(--cs-text-light);'>N/A</span>" %></td>
                    <td><span style="font-size: 15px; font-weight: bold;"><%= t.getReportCount() %></span></td>
                    <td>
                        <span style="color: var(--cs-danger); font-weight: bold; font-size: 13px;">&#9679; ACTIVE THREAT</span>
                    </td>
                    <td>
                        <form action="../ThreatRemoveServlet" method="post" onsubmit="return confirm('Are you sure you want to purge this threat? This will delete the recorded report counts.');">
                            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                            <input type="hidden" name="id" value="<%= t.getThreatId() %>">
                            <button type="submit" class="purge-btn">Purge record</button>
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
