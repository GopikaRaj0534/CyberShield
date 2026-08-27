<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
ComplaintDAO dao = new ComplaintDAO();

String selectedDistrict = request.getParameter("district");
List<Complaint> recent = new ArrayList<>();
Map<String, Integer> topThreats = new LinkedHashMap<>();
String bulletinSentence = null;

if (selectedDistrict != null && !selectedDistrict.trim().isEmpty()) {
    recent = dao.getRecentComplaintsByDistrict(selectedDistrict, 7);

    Map<String, Integer> counts = new LinkedHashMap<>();
    for (Complaint c : recent) {
        String sub = c.getSubType();
        String key = (sub != null && !sub.isEmpty()) ? sub : c.getComplaintType();
        if (key != null) {
            counts.put(key, counts.getOrDefault(key, 0) + 1);
        }
    }

    List<Map.Entry<String, Integer>> entries = new ArrayList<>(counts.entrySet());
    entries.sort((a, b) -> b.getValue() - a.getValue());
    List<Map.Entry<String, Integer>> top3 = entries.subList(0, Math.min(3, entries.size()));

    if (top3.isEmpty()) {
        bulletinSentence = "No cybercrime reports have been filed in " + selectedDistrict + " in the last 7 days.";
    } else {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < top3.size(); i++) {
            Map.Entry<String, Integer> e = top3.get(i);
            if (i > 0) sb.append(i == top3.size() - 1 ? " and " : ", ");
            sb.append(e.getValue()).append(" ").append(e.getKey()).append(e.getValue() == 1 ? "" : " reports");
        }
        bulletinSentence = sb.toString() + " reported in " + selectedDistrict + " this week.";
    }
    for (Map.Entry<String, Integer> e : top3) {
        topThreats.put(e.getKey(), e.getValue());
    }
}
%>
<%@ include file="common/header.jsp" %>

<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow">Public safety information &middot; No login required</span>
        <h2>District safety bulletin</h2>
        <p>A plain-language, weekly snapshot of what's actually being reported near you — compiled automatically from real complaint data so you know what to watch out for.</p>
    </div>

    <div class="card" style="max-width: 680px;">
        <form method="get" action="bulletin.jsp" class="filter-panel" style="flex-wrap:nowrap;">
            <select name="district" class="form-control" required>
                <option value="">-- Select your district --</option>
                <option>Thiruvananthapuram</option>
                <option>Kollam</option>
                <option>Pathanamthitta</option>
                <option>Alappuzha</option>
                <option>Kottayam</option>
                <option>Idukki</option>
                <option>Ernakulam</option>
                <option>Thrissur</option>
                <option>Palakkad</option>
                <option>Malappuram</option>
                <option>Kozhikode</option>
                <option>Wayanad</option>
                <option>Kannur</option>
                <option>Kasaragod</option>
                <option>Other / Outside Kerala</option>
            </select>
            <button type="submit" class="btn btn-primary">View bulletin</button>
        </form>
    </div>

    <% if (bulletinSentence != null) { %>
        <div class="card" style="max-width: 680px; margin-top: 20px;">
            <h3 style="margin-top:0;"><i class="fa-solid fa-bullhorn" style="color:var(--cs-saffron-hover);" aria-hidden="true"></i> This week in <%= SecurityUtil.escapeHtml(selectedDistrict) %></h3>
            <div class="alert alert-info"><%= SecurityUtil.escapeHtml(bulletinSentence) %></div>

            <% if (!topThreats.isEmpty()) { %>
                <% for (Map.Entry<String, Integer> e : topThreats.entrySet()) { %>
                    <div class="record-row">
                        <span class="label"><%= SecurityUtil.escapeHtml(e.getKey()) %></span>
                        <span class="badge rejected"><%= e.getValue() %> report(s)</span>
                    </div>
                <% } %>
            <% } %>

            <p style="margin-top:16px; color:var(--cs-text-muted); font-size:13px;">
                Recognize one of these happening to you? Use <a href="user/suspect-check.jsp">Check Suspect</a> or
                <a href="preemptive-check.jsp">Pre-emptive Risk Check</a> before you act, and
                <a href="login.jsp">file a complaint</a> if you've already been targeted.
            </p>
        </div>
    <% } %>
</section>

<%@ include file="common/footer.jsp" %>
