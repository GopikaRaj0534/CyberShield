<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.ThreatDAO" %>
<%@ page import="com.cybershield.dao.SuspectDAO" %>
<%@ page import="com.cybershield.model.Suspect" %>

<%
ComplaintDAO complaintDAO = new ComplaintDAO();
List<Complaint> allComplaints = complaintDAO.getAllComplaints();

// Aggregate counts by top-level category and by specific sub-type
Map<String, Integer> byCategory = new LinkedHashMap<>();
Map<String, Integer> bySubType = new LinkedHashMap<>();
byCategory.put("Women & Child Related Crime", 0);
byCategory.put("Financial Fraud", 0);
byCategory.put("Other Cybercrime", 0);

int highRisk = 0, mediumRisk = 0, lowRisk = 0;

for (Complaint c : allComplaints) {
    String type = c.getComplaintType();
    if (type != null && byCategory.containsKey(type)) {
        byCategory.put(type, byCategory.get(type) + 1);
    }
    String sub = c.getSubType();
    if (sub != null && !sub.isEmpty()) {
        bySubType.put(sub, bySubType.getOrDefault(sub, 0) + 1);
    }
    if ("HIGH".equals(c.getRiskLevel())) highRisk++;
    else if ("MEDIUM".equals(c.getRiskLevel())) mediumRisk++;
    else lowRisk++;
}

// Top 5 specific incident types
List<Map.Entry<String, Integer>> subTypeEntries = new ArrayList<>(bySubType.entrySet());
subTypeEntries.sort((a, b) -> b.getValue() - a.getValue());
List<Map.Entry<String, Integer>> topSubTypes = subTypeEntries.subList(0, Math.min(5, subTypeEntries.size()));

ThreatDAO threatDAO = new ThreatDAO();
int threatCount = threatDAO.countThreats();

SuspectDAO suspectDAO = new SuspectDAO();
int suspectCount = suspectDAO.countSuspects();
List<Suspect> topTrusted = suspectDAO.getTopTrustScored(5);

int totalComplaints = allComplaints.size();
int maxSubTypeCount = topSubTypes.isEmpty() ? 1 : topSubTypes.get(0).getValue();
%>
<%@ include file="../common/header.jsp" %>

<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow i18n" data-en="Learning Corner &middot; Live data" data-ml="പഠന കോർണർ &middot; തത്സമയ വിവരം">Learning Corner &middot; Live data</span>
        <h2 class="i18n" data-en="Daily digest" data-ml="ദിനംപ്രതി വിവരം">Daily digest</h2>
        <p class="i18n" data-en="A real-time snapshot compiled from complaints and suspects reported on CyberShield." data-ml="CyberShield-ൽ റിപ്പോർട്ട് ചെയ്ത പരാതികളിൽ നിന്നും സസ്‌പെക്റ്റുകളിൽ നിന്നും തയ്യാറാക്കിയ തത്സമയ വിവരം.">A real-time snapshot compiled from complaints and suspects reported on CyberShield.</p>
    </div>

    <% if (totalComplaints == 0) { %>
        <div class="empty-state">
            <i class="fa-solid fa-chart-line" style="font-size:32px; color:var(--cs-text-light); margin-bottom:12px; display:block;" aria-hidden="true"></i>
            <h2 class="i18n" data-en="No complaints filed yet" data-ml="ഇതുവരെ പരാതികളൊന്നും ഫയൽ ചെയ്തിട്ടില്ല">No complaints filed yet</h2>
            <p class="i18n" data-en="Once citizens start filing complaints, this page will show a live breakdown by category, AI risk level, and the most-reported incident types. In the meantime, browse the Cyber Safety Tips and Awareness pages to stay protected." data-ml="പൗരന്മാർ പരാതികൾ ഫയൽ ചെയ്യാൻ തുടങ്ങുമ്പോൾ, ഈ പേജ് വിഭാഗം, AI റിസ്ക് ലെവൽ, ഏറ്റവും കൂടുതൽ റിപ്പോർട്ട് ചെയ്ത സംഭവങ്ങൾ എന്നിവയുടെ തത്സമയ വിവരം കാണിക്കും. അതുവരെ, സൈബർ സുരക്ഷാ ടിപ്പുകളും അവബോധ പേജും പരിശോധിക്കുക.">Once citizens start filing complaints, this page will show a live breakdown by category, AI risk level, and the most-reported incident types. In the meantime, browse the Cyber Safety Tips and Awareness pages to stay protected.</p>
            <div style="display:flex; gap:10px; justify-content:center; margin-top:16px; flex-wrap:wrap;">
                <a href="tips.jsp" class="btn btn-secondary i18n" data-en="Cyber Safety Tips" data-ml="സൈബർ സുരക്ഷാ ടിപ്പുകൾ">Cyber Safety Tips</a>
                <a href="awareness.jsp" class="btn btn-secondary i18n" data-en="Cyber Awareness" data-ml="സൈബർ അവബോധം">Cyber Awareness</a>
            </div>
        </div>
    <% } else { %>

    <div class="hero-stats" style="margin-bottom: 30px;">
        <div class="hero-stat">
            <div class="num"><%= totalComplaints %></div>
            <div class="label i18n" data-en="Total complaints filed" data-ml="ആകെ ഫയൽ ചെയ്ത പരാതികൾ">Total complaints filed</div>
        </div>
        <div class="hero-stat">
            <div class="num"><%= threatCount %></div>
            <div class="label i18n" data-en="Threat intelligence entries" data-ml="ത്രെട്ട് ഇന്റലിജൻസ് എൻട്രികൾ">Threat intelligence entries</div>
        </div>
        <div class="hero-stat">
            <div class="num"><%= suspectCount %></div>
            <div class="label i18n" data-en="Suspects in repository" data-ml="റെപ്പോസിറ്ററിയിലെ സസ്‌പെക്റ്റുകൾ">Suspects in repository</div>
        </div>
    </div>

    <div class="feature-grid">
        <div class="card">
            <h3><i class="fa-solid fa-chart-pie" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> <span class="i18n" data-en="By category" data-ml="വിഭാഗം അനുസരിച്ച്">By category</span></h3>
            <% for (Map.Entry<String, Integer> entry : byCategory.entrySet()) {
                int pct = totalComplaints > 0 ? (entry.getValue() * 100 / totalComplaints) : 0;
            %>
            <div class="digest-bar-row">
                <div class="digest-bar-label"><span><%= entry.getKey() %></span><strong><%= entry.getValue() %></strong></div>
                <div class="digest-bar-track"><div class="digest-bar-fill" style="width:<%= pct %>%;"></div></div>
            </div>
            <% } %>
        </div>

        <div class="card">
            <h3><i class="fa-solid fa-gauge-high" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> <span class="i18n" data-en="By AI risk level" data-ml="AI റിസ്ക് ലെവൽ അനുസരിച്ച്">By AI risk level</span></h3>
            <%
                int[] riskCounts = { highRisk, mediumRisk, lowRisk };
                String[] riskLabels = { "High risk", "Medium risk", "Low risk" };
                String[] riskColors = { "var(--cs-danger)", "var(--cs-warning)", "var(--cs-success)" };
                for (int i = 0; i < 3; i++) {
                    int pct = totalComplaints > 0 ? (riskCounts[i] * 100 / totalComplaints) : 0;
            %>
            <div class="digest-bar-row">
                <div class="digest-bar-label"><span><%= riskLabels[i] %></span><strong><%= riskCounts[i] %></strong></div>
                <div class="digest-bar-track"><div class="digest-bar-fill" style="width:<%= pct %>%; background:<%= riskColors[i] %>;"></div></div>
            </div>
            <% } %>
        </div>

        <div class="card">
            <h3><i class="fa-solid fa-fire" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> <span class="i18n" data-en="Top reported incident types" data-ml="ഏറ്റവും കൂടുതൽ റിപ്പോർട്ട് ചെയ്ത സംഭവങ്ങൾ">Top reported incident types</span></h3>
            <% if (topSubTypes.isEmpty()) { %>
                <p class="i18n" data-en="Not enough data yet." data-ml="വേണ്ടത്ര വിവരം ഇതുവരെയില്ല.">Not enough data yet.</p>
            <% } else { %>
                <% for (Map.Entry<String, Integer> entry : topSubTypes) {
                    int pct = entry.getValue() * 100 / maxSubTypeCount;
                %>
                <div class="digest-bar-row">
                    <div class="digest-bar-label"><span><%= entry.getKey() %></span><strong><%= entry.getValue() %></strong></div>
                    <div class="digest-bar-track"><div class="digest-bar-fill" style="width:<%= pct %>%;"></div></div>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>

    <div class="alert alert-info" style="margin-top:24px;">
        <i class="fa-solid fa-lightbulb" aria-hidden="true"></i>
        <span class="i18n" data-en="Recognize any of these patterns happening to you? Use Check Suspect before you click or pay, and file a report the moment something feels wrong." data-ml="ഇതിലേതെങ്കിലും നിങ്ങൾക്ക് സംഭവിക്കുന്നതായി തോന്നുന്നുണ്ടോ? ക്ലിക്ക് ചെയ്യും മുൻപ് ചെക്ക് സസ്‌പെക്റ്റ് ഉപയോഗിക്കുക, എന്തെങ്കിലും തെറ്റാണെന്ന് തോന്നിയാൽ ഉടൻ റിപ്പോർട്ട് ചെയ്യുക.">Recognize any of these patterns happening to you? Use <a href="<%= request.getContextPath() %>/user/suspect-check.jsp">Check Suspect</a> before you click or pay, and file a report the moment something feels wrong.</span>
    </div>

    <% if (!topTrusted.isEmpty()) { %>
    <div class="section-head" style="margin-top:40px;">
        <span class="eyebrow i18n" data-en="Community verification" data-ml="കമ്മ്യൂണിറ്റി വെരിഫിക്കേഷൻ">Community verification</span>
        <h2 class="i18n" data-en="Top community-flagged suspects" data-ml="കമ്മ്യൂണിറ്റി ഫ്ലാഗ് ചെയ്ത മുൻനിര സസ്‌പെക്റ്റുകൾ">Top community-flagged suspects</h2>
        <p class="i18n" data-en="Suspects with the highest combined score of formal reports and citizen corroborations." data-ml="ഫോർമൽ റിപ്പോർട്ടുകളും കമ്മ്യൂണിറ്റി സ്ഥിരീകരണങ്ങളും ഏറ്റവും കൂടുതലുള്ള സസ്‌പെക്റ്റുകൾ.">Suspects with the highest combined score of formal reports and citizen corroborations.</p>
    </div>
    <div class="card" style="max-width: 820px;">
        <% for (Suspect s : topTrusted) {
            int corroborations = suspectDAO.getCorroborationCount(s.getSuspectId());
            int trustScore = s.getReportCount() + corroborations;
        %>
        <div class="record-row">
            <span class="label"><%= s.getIdentifierType() %></span>
            <span class="badge rejected"><%= trustScore %> citizen confirmation(s)</span>
        </div>
        <% } %>
    </div>
    <% } %>
    <% } %>
</section>

<%@ include file="../common/footer.jsp" %>
