<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%@ include file="common/header.jsp" %>

<div class="auth-page">
    <div class="auth-single">
        <h2 style="text-align:center; margin-bottom:8px;">Account recovery</h2>
        <p class="sub" style="text-align:center; margin-bottom:28px;">Reset your password using your security question</p>

        <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
        %>
            <div class="alert alert-error"><%= error %></div>
        <%
        }

        String step = (String) request.getAttribute("step");
        String email = (String) request.getAttribute("email");
        String secQuestion = (String) request.getAttribute("secQuestion");

        if (step == null) {
            step = "enterEmail";
        }

        if ("enterEmail".equals(step)) {
        %>
            <form action="ForgotPasswordServlet" method="post" data-loading>
                <input type="hidden" name="action" value="checkEmail">
                <div class="form-group">
                    <label for="email">Registered email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email address" required autocomplete="email">
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Find account</button>
            </form>
        <%
        } else if ("verifyAnswer".equals(step)) {
        %>
            <form action="ForgotPasswordServlet" method="post" data-loading>
                <input type="hidden" name="action" value="resetPassword">
                <input type="hidden" name="email" value="<%= SecurityUtil.escapeHtml(email) %>">

                <div class="form-group">
                    <label>Security question</label>
                    <p style="font-size:15px; color:var(--cs-text); margin-bottom:12px;"><%= SecurityUtil.escapeHtml(secQuestion) %></p>
                </div>
                <div class="form-group">
                    <label for="secAnswer">Security answer</label>
                    <input type="text" id="secAnswer" name="secAnswer" class="form-control" placeholder="Enter answer" required autocomplete="off">
                </div>
                <div class="form-group">
                    <label for="newPassword">New password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Enter new password" required autocomplete="new-password">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm new password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm new password" required autocomplete="new-password">
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Reset password</button>
            </form>
        <%
        }
        %>

        <p class="auth-footer-link">
            <a href="login.jsp">← Back to sign in</a>
        </p>
    </div>
</div>

<%@ include file="common/footer.jsp" %>
