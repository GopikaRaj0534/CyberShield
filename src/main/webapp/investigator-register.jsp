<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="common/header.jsp" %>
<div class="auth-page">
  <div class="auth-layout">
    <aside class="auth-aside">
      <h3>Register as an Investigation Officer</h3>
      <p>Create a dedicated officer account. Your account will be stored with the INVESTIGATOR role and can access only the investigation officer portal.</p>
      <ul>
        <li><i class="fa-solid fa-user-shield" aria-hidden="true"></i> Dedicated officer role</li>
        <li><i class="fa-solid fa-lock" aria-hidden="true"></i> Secure password storage</li>
        <li><i class="fa-solid fa-clipboard-check" aria-hidden="true"></i> Case assignment access</li>
      </ul>
    </aside>
    <div class="auth-panel">
      <h2>Create Officer Account</h2>
      <p class="sub">Register for Investigation Officer access</p>
      <% String error = (String) request.getAttribute("error"); if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
      <% } %>
      <form action="InvestigatorRegisterServlet" method="post" data-loading>
        <div class="form-group"><label for="name">Full name</label><input type="text" id="name" name="name" class="form-control" required autocomplete="name"></div>
        <div class="form-group"><label for="email">Email address</label><input type="email" id="email" name="email" class="form-control" required autocomplete="email"></div>
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
          <div class="form-group"><label for="password">Password</label><input type="password" id="password" name="password" class="form-control" required autocomplete="new-password"></div>
          <div class="form-group"><label for="confirmPassword">Confirm password</label><input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required autocomplete="new-password"></div>
        </div>
        

        <button type="submit" class="btn btn-primary" style="width:100%;">Register as Investigation Officer</button>
      </form>
      <p class="auth-footer-link">Already registered? <a href="investigator-login.jsp">Officer Login</a></p>
     
    </div>
  </div>
</div>
<%@ include file="common/footer.jsp" %>
