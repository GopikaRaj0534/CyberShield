<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%
    // Small live counters for the homepage safety widget - reused from Learning Corner's digest logic
    ComplaintDAO homeComplaintDAO = new ComplaintDAO();
    List<Complaint> allComplaintsForHome = homeComplaintDAO.getAllComplaints();
    int totalComplaintsForHome = allComplaintsForHome.size();
    int highRiskForHome = 0;
    for (Complaint hc : allComplaintsForHome) {
        if ("HIGH".equals(hc.getRiskLevel())) highRiskForHome++;
    }
%>
<%@ include file="common/header.jsp" %>

<section class="hero-section">
    <div class="hero-inner reveal">
        <span class="eyebrow">Cybercrime reporting &amp; threat intelligence</span>
        <h1>Report cybercrime. Track your case. Stay informed.</h1>
        <p class="lead">
            CyberShield helps citizens report phishing, fraud, and online threats in a structured way.
            Every complaint is screened by an AI risk engine and tracked from submission through to resolution.
        </p>
        <div class="hero-actions">
            <a href="login.jsp" class="btn btn-primary"><i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i> Report cybercrime</a>
            <a href="user/track.jsp" class="btn btn-secondary">Track a complaint</a>
        </div>
        <div class="hero-stats">
            <div class="hero-stat">
                <div class="num">24/7</div>
                <div class="label">Complaint intake &amp; AI screening</div>
            </div>
            <div class="hero-stat">
                <div class="num">&lt; 2 min</div>
                <div class="label">Average risk assessment time</div>
            </div>
            <div class="hero-stat">
                <div class="num">100%</div>
                <div class="label">Anonymous reporting available</div>
            </div>
        </div>
    </div>
</section>

<section class="content-section site-container reveal">
    <div class="feature-grid" style="grid-template-columns: 1.3fr 1fr;">
        <div class="card">
            <span class="eyebrow">No login required</span>
            <h3 style="margin-top:8px;"><i class="fa-solid fa-bullhorn" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> District safety bulletin</h3>
            <p>See the top cybercrime patterns reported near you this week, in plain language — compiled live from real complaint data.</p>
            <p style="color:var(--cs-text-muted); font-size:13px;"><%= totalComplaintsForHome %> total complaints on file, <%= highRiskForHome %> flagged high risk by our AI engine.</p>
            <a href="bulletin.jsp" class="btn btn-secondary" style="margin-top:8px;">View your district's bulletin</a>
        </div>
        <div class="card">
            <span class="eyebrow">No login required</span>
            <h3 style="margin-top:8px;"><i class="fa-solid fa-shield-halved" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Check before you click</h3>
            <p>Paste a link, UPI ID, or scan a QR code and get an instant AI risk read — before you pay or click, not after.</p>
            <a href="preemptive-check.jsp" class="btn btn-primary" style="margin-top:8px;">Check risk now</a>
        </div>
    </div>
</section>



<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow">Featured</span>
        <h2>Resources to help you report and recover</h2>
        <p>Whether you have experienced a scam, suspicious message, or account compromise, CyberShield guides you through reporting and tracking your case.</p>
    </div>
    <div class="feature-grid">
        <a href="login.jsp" class="card card-link">
            <h3><i class="fa-solid fa-triangle-exclamation" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Report an incident</h3>
            <p>File a structured complaint with suspect URLs, emails, and supporting evidence.</p>
            <span class="card-arrow">Start a report →</span>
        </a>
        <a href="user/track.jsp" class="card card-link">
            <h3><i class="fa-solid fa-magnifying-glass" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Track your complaint</h3>
            <p>Follow your case through every stage — from submission to investigation and closure.</p>
            <span class="card-arrow">Track status →</span>
        </a>
        <a href="register.jsp" class="card card-link">
            <h3><i class="fa-solid fa-user-plus" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Create an account</h3>
            <p>Register to manage complaints, update your profile, and receive status notifications.</p>
            <span class="card-arrow">Register now →</span>
        </a>
        <a href="login.jsp" class="card card-link">
            <h3><i class="fa-solid fa-robot" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> AI threat analysis</h3>
            <p>Every report is automatically assessed for phishing, spam, and risk level classification.</p>
            <span class="card-arrow">Learn more →</span>
        </a>
        <a href="login.jsp" class="card card-link">
            <h3><i class="fa-solid fa-binoculars" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Check &amp; report suspects</h3>
            <p>Search the Suspect Repository before you click, pay, or reply — and report suspicious emails, numbers, or handles.</p>
            <span class="card-arrow">Open Suspect Repository →</span>
        </a>
        <a href="learning/index.jsp" class="card card-link">
            <h3><i class="fa-solid fa-graduation-cap" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Learning corner</h3>
            <p>FAQ, cyber safety tips, awareness guides, and a live daily digest of what's being reported.</p>
            <span class="card-arrow">Start learning →</span>
        </a>
        <a href="feedback.jsp" class="card card-link">
            <h3><i class="fa-solid fa-comment-dots" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Share feedback</h3>
            <p>Tell us what's working and what isn't — your feedback shapes what we build next.</p>
            <span class="card-arrow">Give feedback →</span>
        </a>
    </div>
</section>

<section class="content-section alt-bg reveal">
    <div class="site-container">
        <div class="section-head">
            <span class="eyebrow">Process</span>
            <h2>From report to resolution — a clear, tracked workflow</h2>
            <p>Every complaint follows the same transparent lifecycle so you always know where your case stands.</p>
        </div>
        <div class="step-grid">
            <div class="step-item">
                <div class="step-num">Step 1 — Submit</div>
                <h3>Report the incident</h3>
                <p>Describe what happened and attach suspect URLs, emails, or evidence files. Anonymous reporting is supported.</p>
            </div>
            <div class="step-item">
                <div class="step-num">Step 2 — Scan</div>
                <h3>AI risk analysis</h3>
                <p>Our engine screens URLs, sender addresses, and descriptions to assign a HIGH, MEDIUM, or LOW risk level.</p>
            </div>
            <div class="step-item">
                <div class="step-num">Step 3 — Review</div>
                <h3>Administrator verification</h3>
                <p>Trained administrators verify the AI assessment, assign investigators, and move cases forward.</p>
            </div>
            <div class="step-item">
                <div class="step-num">Step 4 — Resolve</div>
                <h3>Closure &amp; updates</h3>
                <p>You are notified as your case status changes, through to final resolution or rejection.</p>
            </div>
        </div>
    </div>
</section>


<section class="content-section alt-bg reveal">
    <div class="site-container">
        <div class="section-head">
            <span class="eyebrow">Stay safe</span>
            <h2>Practical steps to reduce your risk</h2>
        </div>
        <div class="tip-grid">
            <div class="tip-card">
                <h4>Check URLs before you click</h4>
                <p>Legitimate services rarely ask you to verify your account through a link in an unsolicited email or text message.</p>
            </div>
            <div class="tip-card">
                <h4>Use unique passwords</h4>
                <p>One leaked password should not unlock every account. Consider a password manager for strong, unique credentials.</p>
            </div>
            <div class="tip-card">
                <h4>Report suspicious activity early</h4>
                <p>The sooner a phishing site or scam account is reported, the faster it can be flagged for others in the community.</p>
            </div>
        </div>
    </div>
</section>

<section class="cta-band reveal">
    <h2>Experienced a cyber incident?</h2>
    <p>It takes less than two minutes to file a report. You can choose to remain anonymous throughout the process.</p>
    <div style="display:flex; gap:16px; justify-content:center; flex-wrap:wrap;">
        <a href="login.jsp" class="btn btn-primary">Report cybercrime</a>
        <a href="register.jsp" class="btn btn-secondary" style="background:transparent; color:#fff; border-color:rgba(255,255,255,0.6);">Create account</a>
    </div>
</section>

<%@ include file="common/footer.jsp" %>
