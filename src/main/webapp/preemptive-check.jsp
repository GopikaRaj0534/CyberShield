<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.Suspect" %>
<%@ page import="com.cybershield.model.Threat" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }
    String checked = (String) request.getAttribute("checked");
    String riskLevel = (String) request.getAttribute("riskLevel");
    String explanation = (String) request.getAttribute("explanation");
    Suspect suspect = (Suspect) request.getAttribute("suspect");
    Threat threat = (Threat) request.getAttribute("threat");
    String error = (String) request.getAttribute("error");
%>
<%@ include file="common/header.jsp" %>

<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow">Check before you click, scan, or pay</span>
        <h2>Pre-emptive risk check</h2>
        <p>Paste a link, UPI ID — or scan a QR code — and get an instant AI risk read <strong>before</strong> you act on it. No account needed.</p>
    </div>

    <div class="card" style="max-width: 680px;">
        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>

        <form action="PreemptiveCheckServlet" method="post" id="preemptiveForm">
            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

            <div class="form-group">
                <label>URL or UPI ID</label>
                <input type="text" name="checkValue" id="checkValue" class="form-control"
                       placeholder="e.g. https://pay-secure-verify.com, scammer@upi " required
                       value="<%= checked != null ? SecurityUtil.escapeHtml(checked) : "" %>">
            </div>

            <div class="form-group">
                <label>Or scan a QR code image instead</label>
                <input type="file" id="qrImageInput" class="form-control" accept="image/*" style="border-style:dashed; cursor:pointer;">
                <p id="qrStatus" style="color: var(--cs-text-muted); font-size: 12px; margin-top: 6px;">Upload a screenshot of the QR code — it's decoded right here in your browser and never uploaded anywhere.</p>
            </div>

            <button type="submit" class="btn btn-primary" style="width:100%;">
                <i class="fa-solid fa-shield-halved" aria-hidden="true"></i> Check risk now
            </button>
        </form>
    </div>

    <% if (checked != null && riskLevel != null) { %>
        <div class="card" style="max-width: 680px; margin-top: 20px;">
            <h3 style="margin-top:0;">Result for "<%= SecurityUtil.escapeHtml(checked) %>"</h3>

            <%
                String riskClass = "risk-low";
                String alertClass = "alert-success";
                String verdict = "Looks low risk based on current signals.";
                if ("HIGH".equals(riskLevel)) {
                    riskClass = "risk-high";
                    alertClass = "alert-error";
                    verdict = "High risk — avoid clicking, paying, or sharing details.";
                } else if ("MEDIUM".equals(riskLevel)) {
                    riskClass = "risk-medium";
                    alertClass = "alert-info";
                    verdict = "Medium risk — proceed with caution and verify independently.";
                }
                if (suspect != null || threat != null) {
                    alertClass = "alert-error";
                    verdict = "This has been directly reported by other citizens. Avoid it.";
                }
            %>

            <div class="alert <%= alertClass %>">
                <i class="fa-solid fa-gauge-high" aria-hidden="true"></i>
                AI risk level: <span class="<%= riskClass %>" style="text-transform:uppercase;"><%= riskLevel %></span> — <%= verdict %>
            </div>

            <div class="record-card">
                <div class="record-row">
                    <span class="label">AI diagnostics</span>
                    <span style="max-width:75%; text-align:right;"><%= SecurityUtil.escapeHtml(explanation) %></span>
                </div>
                <% if (suspect != null) { %>
                <div class="record-row">
                    <span class="label">Suspect Repository</span>
                    <span class="badge rejected">Reported <%= suspect.getReportCount() %> time(s)</span>
                </div>
                <% } %>
                <% if (threat != null) { %>
                <div class="record-row">
                    <span class="label">Threat intelligence</span>
                    <span class="badge rejected">Reported <%= threat.getReportCount() %> time(s)</span>
                </div>
                <% } %>
            </div>

            <p style="margin-top:16px; color:var(--cs-text-muted); font-size:13px;">
                This is an automated assessment, not a guarantee. If you've already lost money or shared sensitive details,
                <a href="login.jsp">file a complaint</a> right away instead of only checking risk.
            </p>
        </div>
    <% } %>
</section>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jsQR/1.4.0/jsQR.js"></script>
<script>
(function () {
    var qrInput = document.getElementById("qrImageInput");
    var statusEl = document.getElementById("qrStatus");
    var checkValueInput = document.getElementById("checkValue");

    if (!qrInput) return;

    qrInput.addEventListener("change", function (e) {
        var file = e.target.files && e.target.files[0];
        if (!file) return;

        statusEl.textContent = "Decoding QR code...";

        var reader = new FileReader();
        reader.onload = function (evt) {
            var img = new Image();
            img.onload = function () {
                var canvas = document.createElement("canvas");
                canvas.width = img.width;
                canvas.height = img.height;
                var ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0);
                var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

                if (typeof jsQR === "undefined") {
                    statusEl.textContent = "QR decoder failed to load. Please type the value manually.";
                    return;
                }

                var code = jsQR(imageData.data, imageData.width, imageData.height);
                if (code && code.data) {
                    checkValueInput.value = code.data;
                    statusEl.textContent = "QR code decoded successfully — review the value above, then check risk.";
                } else {
                    statusEl.textContent = "Could not read a QR code in that image. Try a clearer screenshot or type the value manually.";
                }
            };
            img.src = evt.target.result;
        };
        reader.readAsDataURL(file);
    });
})();
</script>

<%@ include file="common/footer.jsp" %>
