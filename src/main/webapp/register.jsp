<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="common/header.jsp" %>

<div class="auth-page">
    <div class="auth-layout">
        <aside class="auth-aside">
            <h3>Join the citizen reporting network</h3>
            <p>Create your account to file complaints, track investigations, and receive AI-backed risk assessments on every case you report.</p>
            <ul>
                <li><i class="fa-solid fa-shield-halved" aria-hidden="true"></i> Your data is protected end-to-end</li>
                <li><i class="fa-solid fa-key" aria-hidden="true"></i> Security question for account recovery</li>
                <li><i class="fa-solid fa-magnifying-glass-chart" aria-hidden="true"></i> Full visibility into complaint status</li>
            </ul>
        </aside>

        <div class="auth-panel">
            <h2>Create your account</h2>
            <p class="sub">Register to start reporting cybercrime securely</p>

            <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
            %>
                <div class="alert alert-error"><%= error %></div>
            <%
            }
            %>

            <form action="RegisterServlet" method="post" data-loading>
                <div class="form-group">
                    <label for="name">Full name</label>
                    <input type="text" id="name" name="name" class="form-control" placeholder="Enter your name" required autocomplete="name">
                </div>
                <div class="form-group">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required autocomplete="email">
                </div>
                <div class="form-group">
                    <label for="phone">Phone number</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="Enter your phone number" required autocomplete="tel">
                </div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Create password" required autocomplete="new-password">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Confirm password" required autocomplete="new-password">
                    </div>
                </div>
                <div class="form-group">
                    <label for="secQuestion">Security question</label>
                    <select id="secQuestion" name="secQuestion" class="form-control" required>
                       
                        <option value="What was the name of your first school?">What was the name of your first school?</option>
                        <option value="What is your pet's name?">What is your pet's name?</option>
                        <option value="In which city were you born?">In which city were you born?</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="secAnswer">Security answer</label>
                    <input type="text" id="secAnswer" name="secAnswer" class="form-control" placeholder="Enter security answer" required autocomplete="off">
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Register</button>
            </form>

            <p class="auth-footer-link">
                Already have an account? <a href="login.jsp">Sign in</a>
            </p>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>
