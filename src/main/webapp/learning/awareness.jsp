<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="../common/header.jsp" %>

<section class="content-section site-container reveal">
    <div class="section-head">
        <span class="eyebrow i18n" data-en="Learning Corner" data-ml="പഠന കോർണർ">Learning Corner</span>
        <h2 class="i18n" data-en="Cyber awareness" data-ml="സൈബർ അവബോധം">Cyber awareness</h2>
        <p class="i18n" data-en="Knowing how a scam works makes it easy to spot." data-ml="ഒരു തട്ടിപ്പ് എങ്ങനെ പ്രവർത്തിക്കുന്നു എന്നറിയുന്നത് അത് തിരിച്ചറിയാൻ സഹായിക്കും.">Knowing how a scam works makes it easy to spot.</p>
    </div>

    <div class="tip-grid">
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-hand-holding-dollar" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="UPI &amp; payment fraud" data-ml="UPI, പേയ്‌മെന്റ് തട്ടിപ്പ്">UPI &amp; payment fraud</h3>
            <p class="i18n" data-en="A 'collect request' or QR scan disguised as a refund always sends money out, never in." data-ml="'റീഫണ്ട്' എന്ന വ്യാജേന വരുന്ന QR അല്ലെങ്കിൽ കളക്ട് റിക്വസ്റ്റ് എപ്പോഴും പണം അയക്കാൻ മാത്രമേ ഉപകരിക്കൂ, സ്വീകരിക്കാൻ അല്ല.">A "collect request" or QR scan disguised as a refund always sends money out, never in.</p>
        </div>
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-phone-volume" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="'Digital arrest' calls" data-ml="'ഡിജിറ്റൽ അറസ്റ്റ്' കോളുകൾ">"Digital arrest" calls</h3>
            <p class="i18n" data-en="No police or agency arrests anyone over video call. Hang up and verify independently." data-ml="ഒരു ഏജൻസിയും വീഡിയോ കോളിലൂടെ അറസ്റ്റ് ചെയ്യില്ല. കോൾ കട്ട് ചെയ്ത് സ്വന്തമായി ഉറപ്പാക്കുക.">No police or agency arrests anyone over video call. Hang up and verify independently.</p>
        </div>
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-briefcase" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="Fake job &amp; task scams" data-ml="വ്യാജ ജോലി തട്ടിപ്പ്">Fake job &amp; task scams</h3>
            <p class="i18n" data-en="A real employer never asks you to pay upfront to 'get paid' later." data-ml="യഥാർത്ഥ തൊഴിലുടമ ഒരിക്കലും മുൻകൂർ പണം ചോദിക്കില്ല.">A real employer never asks you to pay upfront to "get paid" later.</p>
        </div>
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-heart-crack" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="Romance &amp; investment scams" data-ml="പ്രണയം, നിക്ഷേപ തട്ടിപ്പ്">Romance &amp; investment scams</h3>
            <p class="i18n" data-en="A new online contact pushing 'guaranteed returns' or urgent money help is a red flag." data-ml="'ഗ്യാരണ്ടീഡ് റിട്ടേൺ' വാഗ്ദാനം ചെയ്യുന്ന പുതിയ ഓൺലൈൻ പരിചയക്കാർ അപകടസൂചനയാണ്.">A new online contact pushing "guaranteed returns" or urgent money help is a red flag.</p>
        </div>
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-envelope-open-text" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="Phishing emails &amp; SMS" data-ml="ഫിഷിംഗ് ഇമെയിൽ, SMS">Phishing emails &amp; SMS</h3>
            <p>
                <span class="i18n" data-en="A lookalike link asks you to 'verify' your account. Check it with" data-ml="'വെരിഫൈ' ചെയ്യാൻ ആവശ്യപ്പെടുന്ന വ്യാജ ലിങ്കുകൾ. ഇത് ഉപയോഗിച്ച് പരിശോധിക്കുക:">A lookalike link asks you to "verify" your account. Check it with</span>
                <a href="<%= request.getContextPath() %>/user/suspect-check.jsp" class="i18n" data-en="Check Suspect" data-ml="ചെക്ക് സസ്‌പെക്റ്റ്">Check Suspect</a>
                <span class="i18n" data-en="first." data-ml="ആദ്യം.">first.</span>
            </p>
        </div>
        <div class="tip-card">
            <div class="tip-icon"><i class="fa-solid fa-child" aria-hidden="true"></i></div>
            <h3 class="i18n" data-en="Online sextortion" data-ml="ഓൺലൈൻ ചൂഷണം">Online sextortion</h3>
            <p class="i18n" data-en="A stranger threatens to share a private image unless paid. Report immediately — the child is never at fault." data-ml="സ്വകാര്യ ചിത്രം പങ്കിടുമെന്ന് ഭീഷണിപ്പെടുത്തി പണം ആവശ്യപ്പെടുന്നത് കുറ്റകൃത്യമാണ്. ഉടൻ റിപ്പോർട്ട് ചെയ്യുക — കുട്ടിക്ക് ഒരിക്കലും കുറ്റമില്ല.">A stranger threatens to share a private image unless paid. Report immediately — the child is never at fault.</p>
        </div>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>
