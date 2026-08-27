<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="common/header.jsp" %>
<div class="auth-page">
  <div class="auth-layout">
    <aside class="auth-aside">
      <h3>Investigation Officer Portal</h3>
      <p>Secure access for registered investigation officers to review assigned cybercrime cases and submit investigation findings.</p>
      <ul>
        <li><i class="fa-solid fa-user-shield" aria-hidden="true"></i> Dedicated officer access</li>
        <li><i class="fa-solid fa-folder-open" aria-hidden="true"></i> View assigned cases</li>
        <li><i class="fa-solid fa-file-circle-check" aria-hidden="true"></i> Submit investigation reports</li>
      </ul>
    </aside>
    <div class="auth-panel">
      <h2>Investigation Officer Login</h2>
      <p class="sub">Sign in with your officer credentials</p>
      <% if ("true".equals(request.getParameter("registered"))) { %>
        <div class="alert alert-success">Registration successful. Please sign in.</div>
      <% } %>
      <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
      <% } %>
      <form action="InvestigatorLoginServlet" method="post" data-loading>
        <div class="form-group"><label for="email">Email address</label><input type="email" id="email" name="email" class="form-control" required autocomplete="email"></div>
        <div class="form-group"><label for="password">Password</label><input type="password" id="password" name="password" class="form-control" required autocomplete="current-password"></div>
        <button type="submit" class="btn btn-primary" style="width:100%;">Sign in</button>
      </form>
      <p class="auth-footer-link">New investigation officer? <a href="investigator-register.jsp">Register here</a></p>
     
    </div>
  </div>
</div>
<%@ include file="common/footer.jsp" %>
