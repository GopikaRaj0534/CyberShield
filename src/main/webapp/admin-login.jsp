<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="common/header.jsp" %>
<div class="auth-page">
  <div class="auth-layout">
    <aside class="auth-aside">
      <h3>Administrator Access</h3>
      <p>This secure sign-in is reserved for CyberShield administrators. Administrator accounts are created by the system/database administrator.</p>
      <ul>
        <li><i class="fa-solid fa-user-lock" aria-hidden="true"></i> Restricted administrator access</li>
        <li><i class="fa-solid fa-chart-line" aria-hidden="true"></i> Case and system management</li>
        <li><i class="fa-solid fa-users-gear" aria-hidden="true"></i> User and officer management</li>
      </ul>
    </aside>
    <div class="auth-panel">
      <h2>Admin Login</h2>
      <p class="sub">Sign in with your administrator credentials</p>
      <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
      <% } %>
      <form action="AdminLoginServlet" method="post" data-loading>
        <div class="form-group"><label for="email">Admin email</label><input type="email" id="email" name="email" class="form-control" required autocomplete="username"></div>
        <div class="form-group"><label for="password">Password</label><input type="password" id="password" name="password" class="form-control" required autocomplete="current-password"></div>
        <button type="submit" class="btn btn-primary" style="width:100%;">Admin Sign in</button>
      </form>
      <p class="auth-footer-link">Administrator accounts cannot be registered publicly.</p>
      
    </div>
  </div>
</div>
<%@ include file="common/footer.jsp" %>
