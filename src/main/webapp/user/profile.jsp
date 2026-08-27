<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="profile" />
    </jsp:include>

    <main class="portal-main">
        <h1>My profile</h1>
        <p class="page-sub">Update your details and manage account security.</p>

        <div style="display:flex; gap:24px; flex-wrap:wrap;">

            <!-- Profile Info Edit -->
            <div class="card" style="flex:1; min-width:320px; max-width:550px;">
                <h2 style="border-bottom:2px solid var(--cs-border-light); padding-bottom:10px; margin-bottom:22px;">
                    <i class="fa-solid fa-user" aria-hidden="true"></i> Profile management
                </h2>

                <%
                String msg = request.getParameter("msg");
                String err = request.getParameter("err");
                if ("updated".equals(msg)) {
                %>
                    <div class="alert alert-success">Profile updated successfully!</div>
                <%
                } else if ("pass_updated".equals(msg)) {
                %>
                    <div class="alert alert-success">Password changed successfully!</div>
                <%
                } else if (err != null) {
                    String errMsg = "An error occurred.";
                    if ("csrf".equals(err)) errMsg = "Invalid security token.";
                    else if ("wrong_pass".equals(err)) errMsg = "Old password is incorrect.";
                    else if ("mismatch".equals(err)) errMsg = "Passwords do not match.";
                    else if ("failed".equals(err)) errMsg = "Operation failed. Try again.";
                %>
                    <div class="alert alert-error"><%= errMsg %></div>
                <%
                }
                %>

                <form action="../ProfileServlet" method="post">
                    <input type="hidden" name="action" value="updateProfile">
                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

                    <div class="form-group">
                        <label>Full name</label>
                        <input type="text" name="name" class="form-control" value="<%= SecurityUtil.escapeHtml(user.getName()) %>" required>
                    </div>

                    <div class="form-group">
                        <label>Email address</label>
                        <input type="email" name="email" class="form-control" value="<%= SecurityUtil.escapeHtml(user.getEmail()) %>" required>
                    </div>

                    <div class="form-group">
                        <label>Phone number</label>
                        <input type="tel" name="phone" class="form-control" value="<%= user.getPhone() != null ? SecurityUtil.escapeHtml(user.getPhone()) : "" %>" placeholder="Enter your phone number" required>
                    </div>

                    <div class="form-group">
                        <label>Security recovery question</label>
                        <select name="secQuestion" class="form-control" required>
                            
                            <option value="What was the name of your first school?" <%= "What was the name of your first school?".equals(user.getSecQuestion()) ? "selected" : "" %>>What was the name of your first school?</option>
                            <option value="What is your pet's name?" <%= "What is your pet's name?".equals(user.getSecQuestion()) ? "selected" : "" %>>What is your pet's name?</option>
                            <option value="In which city were you born?" <%= "In which city were you born?".equals(user.getSecQuestion()) ? "selected" : "" %>>In which city were you born?</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Security recovery answer</label>
                        <input type="text" name="secAnswer" class="form-control" value="<%= SecurityUtil.escapeHtml(user.getSecAnswer()) %>" placeholder="Security answer" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width:100%;">Update profile</button>
                </form>
            </div>

            <!-- Password Change Box -->
            <div class="card" style="flex:1; min-width:320px; max-width:550px;">
                <h2 style="border-bottom:2px solid var(--cs-border-light); padding-bottom:10px; margin-bottom:22px;">
                    <i class="fa-solid fa-key" aria-hidden="true"></i> Change password
                </h2>

                <form action="../ProfileServlet" method="post">
                    <input type="hidden" name="action" value="changePassword">
                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

                    <div class="form-group">
                        <label>Old password</label>
                        <input type="password" name="oldPassword" class="form-control" placeholder="Enter current password" required>
                    </div>

                    <div class="form-group">
                        <label>New password</label>
                        <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required>
                    </div>

                    <div class="form-group">
                        <label>Confirm new password</label>
                        <input type="password" name="confirmNewPassword" class="form-control" placeholder="Confirm new password" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width:100%;">Change password</button>
                </form>
            </div>

        </div>
    </main>
</div>

</body>
</html>
