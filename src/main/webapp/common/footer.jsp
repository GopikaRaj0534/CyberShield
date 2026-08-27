</main><!-- /#main-content -->

<footer class="site-footer">
    <div class="footer-grid">
        <div>
            <h4>CyberShield</h4>
            <p>A smart cybercrime complaint and threat reporting platform with AI-assisted risk analysis, case tracking, and admin investigation tools.</p>
            <p class="footer-disclaimer">This is an independent academic project. It is not affiliated with, endorsed by, or operated by any government agency.</p>
        </div>

        <div>
            <h4>Platform</h4>
            <a href="<%= request.getContextPath() %>/">Home</a>
            <a href="<%= request.getContextPath() %>/login.jsp">Sign in</a>
            <a href="<%= request.getContextPath() %>/register.jsp">Create account</a>
            <a href="<%= request.getContextPath() %>/admin-login.jsp">Admin Login</a>
            <a href="<%= request.getContextPath() %>/user/track.jsp">Track a complaint</a>
            <a href="<%= request.getContextPath() %>/feedback.jsp">Give feedback</a>
        </div>

        <div>
            <h4>Stay protected</h4>
            <a href="<%= request.getContextPath() %>/preemptive-check.jsp">Check a link / QR / UPI ID</a>
            <a href="<%= request.getContextPath() %>/bulletin.jsp">District safety bulletin</a>
            <a href="<%= request.getContextPath() %>/learning/faq.jsp">FAQ</a>
            <a href="<%= request.getContextPath() %>/learning/tips.jsp">Cyber safety tips</a>
            <a href="<%= request.getContextPath() %>/learning/awareness.jsp">Cyber awareness</a>
            <a href="<%= request.getContextPath() %>/learning/digest.jsp">Daily digest</a>
        </div>

        <div>
            <h4>Report categories</h4>
            <span>Phishing &amp; fraud</span>
            <span>Account hacking</span>
            <span>Identity theft</span>
            <span>Online scams</span>
            <span>Cyber bullying</span>
        </div>

        <div>
            <h4>Need help?</h4>
            <p>Every complaint submitted through CyberShield is screened by our AI risk engine and reviewed by administrators.</p>
            <span class="eyebrow" style="color:var(--cs-saffron); font-size:11px; background:rgba(255,153,51,0.15); border-left-color:var(--cs-saffron);">System status: monitoring active</span>
        </div>
    </div>

    <div class="footer-bottom">
        <span>&copy; 2026 CyberShield. All rights reserved.</span>
        <span>Smart Cybercrime Complaint &amp; Threat Reporting System</span>
    </div>
</footer>

<script src="<%= request.getContextPath() %>/assets/js/cybershield.js"></script>
</body>
</html>
