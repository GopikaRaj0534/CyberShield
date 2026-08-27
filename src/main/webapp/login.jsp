
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="common/header.jsp" %>

<div class="auth-page">
    <div class="auth-layout">
        <aside class="auth-aside">
            <h3>Report cybercrime with confidence</h3>
            <p>CyberShield gives citizens a secure, guided channel to report threats and track every complaint through to resolution.</p>
            <ul>
                <li><i class="fa-solid fa-lock" aria-hidden="true"></i> Secure session and credential handling</li>
                <li><i class="fa-solid fa-user-secret" aria-hidden="true"></i> Anonymous reporting supported</li>
                <li><i class="fa-solid fa-robot" aria-hidden="true"></i> AI-assisted risk analysis on every case</li>
            </ul>
        </aside>

        <div class="auth-panel">
            <h2>Sign in</h2>
            <p class="sub">Access your CyberShield account</p>

            <%
            if ("true".equals(request.getParameter("registered"))) {
            %>
                <div class="alert alert-success">Registration successful. Please sign in with your credentials.</div>
            <%
            }
            if ("true".equals(request.getParameter("reset"))) {
            %>
                <div class="alert alert-success">Password reset successful. Sign in with your new password.</div>
            <%
            }
            if ("true".equals(request.getParameter("logout"))) {
            %>
                <div class="alert alert-info">You have been signed out successfully.</div>
            <%
            }
            String error = (String) request.getAttribute("error");
            if (error != null) {
            %>
                <div class="alert alert-error"><%= error %></div>
            <%
            }
            %>

            <form action="LoginServlet" method="post" data-loading>
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" required autocomplete="email">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required autocomplete="current-password">
                </div>
                <p style="text-align:right; margin:-8px 0 20px;">
                    <a href="forgot_password.jsp">Forgot password?</a>
                </p>
                <button type="submit" class="btn btn-primary" style="width:100%;">Sign in</button>
            </form>

            <p class="auth-footer-link">
                Don't have an account? <a href="register.jsp">Register</a>
            </p>
            <div style="margin-top:24px; padding-top:18px; border-top:1px solid var(--cs-border); text-align:center;">
                <p class="auth-footer-link" style="margin:6px 0;">
                    <strong>Are you an Investigation Officer?</strong>
                    <a href="investigator-login.jsp">Investigation Officer Login</a>
                </p>
                
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>
