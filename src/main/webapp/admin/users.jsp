<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.dao.UserDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%@ page import="java.util.List" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

UserDAO dao = new UserDAO();
List<User> users = dao.getUsersByRole("USER");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
    <style>
        .remove-btn {
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
        .remove-btn:hover { background: #8f1717; }
    </style>
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="users" />
    </jsp:include>

    <main class="portal-main">
        <h1>Registered system citizens</h1>
        <p class="page-sub">Manage citizen accounts registered on the platform.</p>

        <div class="data-table-box">
            <table>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email address</th>
                    <th>Security question</th>
                    <th>System role</th>
                    <th>Administrative actions</th>
                </tr>
                <%
                for (User u : users) {
                %>
                <tr>
                    <td>#<%= u.getUserId() %></td>
                    <td><strong><%= SecurityUtil.escapeHtml(u.getName()) %></strong></td>
                    <td><%= SecurityUtil.escapeHtml(u.getEmail()) %></td>
                    <td><%= u.getSecQuestion() != null ? SecurityUtil.escapeHtml(u.getSecQuestion()) : "<span style='color:var(--cs-text-light);'>Not set</span>" %></td>
                    <td>
                        <%
                        if ("ADMIN".equals(u.getRole())) {
                        %>
                            <span class="badge admin-role">ADMIN</span>
                        <%
                        } else {
                        %>
                            <span class="badge user-role">CITIZEN</span>
                        <%
                        }
                        %>
                    </td>
                    <td>
                        <%
                        if (u.getUserId() != admin.getUserId() && !"ADMIN".equals(u.getRole())) {
                        %>
                            <form action="../AdminUserServlet" method="post" onsubmit="return confirm('Are you sure you want to remove this citizen account? This will prevent them from logging in.');">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                <button type="submit" class="remove-btn">Remove user</button>
                            </form>
                        <%
                        } else {
                        %>
                            <span style="color: var(--cs-text-light); font-size: 12px; font-style: italic;">Protected</span>
                        <%
                        }
                        %>
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
