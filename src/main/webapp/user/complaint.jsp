<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>

<%
User user = (User) session.getAttribute("loggedUser");
if (user == null) {
    response.sendRedirect("../login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Cyber Crime - CyberShield</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="complaint" />
    </jsp:include>

    <main class="portal-main">
        <h1>File a cyber crime incident</h1>
        <p class="page-sub">Report phishing, fraud, or any other cyber incident for investigation.</p>

        <div class="card" style="max-width: 680px;">
            <div class="alert alert-info">
                Your complaint details will be processed securely. The suspect URL/email and complaint description will be instantly scanned by our machine learning AI engine to classify threat risk.
            </div>

            <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
            %>
                <div class="alert alert-error"><%= error %></div>
            <%
            }
            %>

            <!-- Form handles file upload with enctype -->
            <form action="../ComplaintServlet" method="post" enctype="multipart/form-data">

                <!-- CSRF Protection Field -->
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">

                <div id="guidedIntro" class="card" style="background: var(--cs-bg-alt); margin-bottom:20px;">
                    <h3 style="margin-top:0;"><i class="fa-solid fa-comments" style="color:var(--cs-saffron-hover); margin-right:8px;"></i> Guided Complaint Assistant</h3>
                    <p>Answer a few quick questions and we'll fill out the form for you — helps make sure nothing important gets left out. You can still review and edit everything before submitting.</p>
                    <div style="display:flex; gap:10px; flex-wrap:wrap;">
                        <button type="button" id="startGuidedBtn" class="btn btn-primary">
                            <i class="fa-solid fa-wand-magic-sparkles" aria-hidden="true"></i> Start guided assistant
                        </button>
                        <button type="button" id="skipGuidedBtn" class="btn btn-secondary">Skip — I'll fill the form myself</button>
                    </div>
                </div>

                <div id="guidedWizard" style="display:none;"></div>

                <div id="manualFormFields" style="display:none;">

                <div class="form-group">
                    <label>Registration category</label>
                    <select name="complaintType" id="complaintType" class="form-control" required onchange="cybershieldUpdateSubTypes()">
                        <option value="">-- Select registration category --</option>
                        <option value="Women &amp; Child Related Crime">Women &amp; Child Related Crime</option>
                        <option value="Financial Fraud">Financial Fraud</option>
                        <option value="Other Cybercrime">Other Cybercrime</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Specific incident type</label>
                    <select name="subType" id="subType" class="form-control" required>
                        <option value="">-- Select a category above first --</option>
                    </select>
                </div>

                <script>
                    var cybershieldSubTypes = {
                        "Women & Child Related Crime": [
                            "Child Sexual Abuse Material (CSAM)",
                            "Cyberstalking / Harassment of Women",
                            "Cyberbullying of a Child",
                            "Online Sextortion",
                            "Non-consensual Image Sharing",
                            "Other"
                        ],
                        "Financial Fraud": [
                            "UPI / Payment Fraud",
                            "Debit / Credit Card Fraud",
                            "Internet Banking Fraud",
                            "Investment / Trading Scam",
                            "Loan App Harassment",
                            "OTP Fraud",
                            "Other"
                        ],
                        "Other Cybercrime": [
                            "Phishing",
                            "Account Hacking",
                            "Identity Theft",
                            "Social Media Crime",
                            "Ransomware / Malware",
                            "Job / Lottery Scam",
                            "Other"
                        ]
                    };

                    function cybershieldUpdateSubTypes() {
                        var category = document.getElementById("complaintType").value;
                        var subSelect = document.getElementById("subType");
                        subSelect.innerHTML = "";

                        if (!category || !cybershieldSubTypes[category]) {
                            var placeholder = document.createElement("option");
                            placeholder.value = "";
                            placeholder.textContent = "-- Select a category above first --";
                            subSelect.appendChild(placeholder);
                            return;
                        }

                        var blank = document.createElement("option");
                        blank.value = "";
                        blank.textContent = "-- Select specific incident type --";
                        subSelect.appendChild(blank);

                        cybershieldSubTypes[category].forEach(function (opt) {
                            var el = document.createElement("option");
                            el.value = opt;
                            el.textContent = opt;
                            subSelect.appendChild(el);
                        });
                    }
                </script>

                <script>
                (function () {
                    var introEl = document.getElementById("guidedIntro");
                    var wizardEl = document.getElementById("guidedWizard");
                    var manualEl = document.getElementById("manualFormFields");
                    var startBtn = document.getElementById("startGuidedBtn");
                    var skipBtn = document.getElementById("skipGuidedBtn");

                    var answers = {};
                    var stepIndex = 0;
                    var steps = []; // built dynamically once category is known

                    skipBtn.addEventListener("click", function () {
                        introEl.style.display = "none";
                        manualEl.style.display = "block";
                    });

                    startBtn.addEventListener("click", function () {
                        introEl.style.display = "none";
                        wizardEl.style.display = "block";
                        stepIndex = 0;
                        renderStep();
                    });

                    function baseSteps() {
                        return [
                            {
                                prompt: "Hi, I'll help you file this report. What kind of incident are you reporting?",
                                type: "buttons",
                                options: ["Women & Child Related Crime", "Financial Fraud", "Other Cybercrime"],
                                onAnswer: function (val) {
                                    answers.category = val;
                                    document.getElementById("complaintType").value = val;
                                    cybershieldUpdateSubTypes();
                                }
                            },
                            {
                                prompt: "Which of these best matches what happened?",
                                type: "buttons",
                                options: function () { return cybershieldSubTypes[answers.category] || ["Other"]; },
                                onAnswer: function (val) {
                                    answers.subType = val;
                                    document.getElementById("subType").value = val;
                                }
                            },
                            {
                                prompt: "Which district were you in when this happened?",
                                type: "select",
                                options: ["Thiruvananthapuram","Kollam","Pathanamthitta","Alappuzha","Kottayam","Idukki","Ernakulam","Thrissur","Palakkad","Malappuram","Kozhikode","Wayanad","Kannur","Kasaragod","Other / Outside Kerala"],
                                onAnswer: function (val) {
                                    answers.district = val;
                                    document.getElementById("district").value = val;
                                }
                            },
                            {
                                prompt: "Briefly describe what happened — what did the scammer say or do?",
                                type: "text",
                                placeholder: "e.g. Someone called claiming to be from my bank and asked for my OTP...",
                                onAnswer: function (val) { answers.mainDescription = val; }
                            },
                            {
                                prompt: "When did this happen? (You can skip this if you're not sure)",
                                type: "text",
                                placeholder: "e.g. yesterday evening, 3 days ago...",
                                optional: true,
                                onAnswer: function (val) { answers.timing = val; }
                            },
                            {
                                prompt: "Which platform or app was involved, if any? (You can skip this)",
                                type: "text",
                                placeholder: "e.g. WhatsApp, Instagram, a phone call, an SMS...",
                                optional: true,
                                onAnswer: function (val) { answers.platform = val; }
                            },
                            {
                                prompt: "Do you have the suspect's website link or URL? Leave blank if none.",
                                type: "text",
                                placeholder: "https://...",
                                optional: true,
                                onAnswer: function (val) { document.getElementById("suspectUrl").value = val; }
                            },
                            {
                                prompt: "Do you have the suspect's email address? Leave blank if none.",
                                type: "text",
                                placeholder: "attacker@example.com",
                                optional: true,
                                onAnswer: function (val) { document.getElementById("suspectEmail").value = val; }
                            }
                        ];
                    }

                    function financialSteps() {
                        return [
                            {
                                prompt: "Do you have the UPI ID the money was sent to? Leave blank if none.",
                                type: "text",
                                placeholder: "e.g. scammer@upi",
                                optional: true,
                                onAnswer: function (val) {
                                    document.getElementById("suspectUpiId").value = val;
                                    document.getElementById("financialFieldsGroup").style.display = "block";
                                }
                            },
                            {
                                prompt: "Do you have the bank account number the money was sent to? Leave blank if none.",
                                type: "text",
                                placeholder: "Account number",
                                optional: true,
                                onAnswer: function (val) {
                                    document.getElementById("suspectBankAccount").value = val;
                                    document.getElementById("financialFieldsGroup").style.display = "block";
                                }
                            }
                        ];
                    }

                    function addBubble(text, fromUser) {
                        var bubble = document.createElement("div");
                        bubble.className = "wizard-bubble" + (fromUser ? " wizard-bubble-user" : "");
                        bubble.textContent = text;
                        wizardEl.appendChild(bubble);
                        wizardEl.scrollTop = wizardEl.scrollHeight;
                    }

                    function renderStep() {
                        // Steps 0-7 are base steps; once category is known (after step 0),
                        // splice in the financial-only questions right after the URL/email steps.
                        if (stepIndex === 0) {
                            steps = baseSteps();
                        }
                        if (stepIndex === steps.length && answers.category === "Financial Fraud" && !answers._financialAdded) {
                            steps = steps.concat(financialSteps());
                            answers._financialAdded = true;
                        }

                        if (stepIndex >= steps.length) {
                            finishWizard();
                            return;
                        }

                        var step = steps[stepIndex];
                        addBubble(step.prompt, false);

                        var controls = document.createElement("div");
                        controls.className = "wizard-controls";

                        if (step.type === "buttons") {
                            var opts = typeof step.options === "function" ? step.options() : step.options;
                            opts.forEach(function (opt) {
                                var btn = document.createElement("button");
                                btn.type = "button";
                                btn.className = "wizard-option-btn";
                                btn.textContent = opt;
                                btn.addEventListener("click", function () {
                                    step.onAnswer(opt);
                                    addBubble(opt, true);
                                    controls.remove();
                                    stepIndex++;
                                    renderStep();
                                });
                                controls.appendChild(btn);
                            });
                        } else if (step.type === "select") {
                            var select = document.createElement("select");
                            select.className = "form-control";
                            var blank = document.createElement("option");
                            blank.value = ""; blank.textContent = "-- Select --";
                            select.appendChild(blank);
                            step.options.forEach(function (opt) {
                                var el = document.createElement("option");
                                el.value = opt; el.textContent = opt;
                                select.appendChild(el);
                            });
                            var goBtn = document.createElement("button");
                            goBtn.type = "button";
                            goBtn.className = "btn btn-secondary";
                            goBtn.textContent = "Continue";
                            goBtn.addEventListener("click", function () {
                                if (!select.value) return;
                                step.onAnswer(select.value);
                                addBubble(select.value, true);
                                controls.remove();
                                stepIndex++;
                                renderStep();
                            });
                            controls.appendChild(select);
                            controls.appendChild(goBtn);
                        } else if (step.type === "text") {
                            var input = document.createElement("textarea");
                            input.className = "form-control";
                            input.placeholder = step.placeholder || "";
                            input.style.height = "70px";
                            input.style.resize = "none";
                            var goBtn2 = document.createElement("button");
                            goBtn2.type = "button";
                            goBtn2.className = "btn btn-secondary";
                            goBtn2.textContent = step.optional ? "Continue (or leave blank to skip)" : "Continue";
                            goBtn2.addEventListener("click", function () {
                                var val = input.value.trim();
                                if (!val && !step.optional) return;
                                step.onAnswer(val);
                                addBubble(val || "(skipped)", true);
                                controls.remove();
                                stepIndex++;
                                renderStep();
                            });
                            controls.appendChild(input);
                            controls.appendChild(goBtn2);
                        }

                        wizardEl.appendChild(controls);
                        wizardEl.scrollTop = wizardEl.scrollHeight;
                    }

                    function finishWizard() {
                        // Assemble the structured answers into the real description field
                        var parts = [];
                        if (answers.mainDescription) parts.push(answers.mainDescription);
                        if (answers.timing) parts.push("Incident timing: " + answers.timing + ".");
                        if (answers.platform) parts.push("Platform/app involved: " + answers.platform + ".");
                        document.getElementById("description").value = parts.join(" ");

                        addBubble("Thanks — I've filled out your complaint below. Please review it, attach any evidence, and submit.", false);

                        var reviewBtn = document.createElement("button");
                        reviewBtn.type = "button";
                        reviewBtn.className = "btn btn-primary";
                        reviewBtn.style.marginTop = "10px";
                        reviewBtn.textContent = "Review & submit my complaint";
                        reviewBtn.addEventListener("click", function () {
                            manualEl.style.display = "block";
                            manualEl.scrollIntoView({ behavior: "smooth" });
                        });
                        wizardEl.appendChild(reviewBtn);
                    }
                })();
                </script>

                <div class="form-group">
                    <label>District (where the incident affected you)</label>
                    <select name="district" id="district" class="form-control" required>
                        <option value="">-- Select district --</option>
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
                    <p style="color: var(--cs-text-muted); font-size: 12px; margin-top: 6px;">Used only to compile the anonymous, area-level District Safety Bulletin — never shown next to your name.</p>
                </div>

                <div class="form-group">
                    <label>Describe the incident</label>
                    <textarea name="description" id="description" class="form-control" style="height:130px; resize:none;" placeholder="Provide a detailed explanation of the event (e.g. details of the fraud, threat language, etc.)..." required></textarea>
                    <p style="color: var(--cs-text-muted); font-size: 12px; margin-top: 6px;">You can write in English or Malayalam (മലയാളം) — our AI screening recognizes key terms in both.</p>
                </div>

                <div class="form-group">
                    <label>Suspect URL (if any)</label>
                    <input type="text" name="suspectUrl" id="suspectUrl" class="form-control" placeholder="https://malicious-login-verify.com">
                </div>

                <div class="form-group">
                    <label>Suspect email (if any)</label>
                    <input type="email" name="suspectEmail" id="suspectEmail" class="form-control" placeholder="attacker@scam-mail.net">
                </div>

                <div id="financialFieldsGroup" style="display:none;">
                    <div class="form-group">
                        <label>Suspect's UPI ID (if any)</label>
                        <input type="text" name="suspectUpiId" id="suspectUpiId" class="form-control" placeholder="e.g. scammer@upi">
                    </div>
                    <div class="form-group">
                        <label>Suspect's bank account number (if any)</label>
                        <input type="text" name="suspectBankAccount" id="suspectBankAccount" class="form-control" placeholder="Account number the money was sent to">
                        <p style="color: var(--cs-text-muted); font-size: 12px; margin-top: 6px;">Used to cross-link related financial fraud cases in our internal Money-Trail analysis — never shown publicly.</p>
                    </div>
                </div>

                <script>
                    // Show the UPI/bank account fields only for Financial Fraud, since
                    // they're the fields the Money-Trail Visualizer relies on.
                    document.getElementById("complaintType").addEventListener("change", function () {
                        var group = document.getElementById("financialFieldsGroup");
                        group.style.display = (this.value === "Financial Fraud") ? "block" : "none";
                    });
                </script>

                <div class="form-group">
                    <label>Attach evidence (screenshots, images, PDF)</label>
                    <input type="file" name="evidenceFile" class="form-control" accept="image/*,application/pdf" style="border-style:dashed; cursor:pointer;">
                    <p style="color: var(--cs-text-muted); font-size: 12px; margin-top: 6px;">Allowed file types: Images (JPG, PNG, GIF) and PDFs. Maximum size: 10MB.</p>
                </div>

                <div class="form-group">
                    <label style="display:flex; align-items:center; gap:8px; font-weight:normal; cursor:pointer;">
                        <input type="checkbox" name="anonymous" value="YES" style="width:auto; cursor:pointer;">
                        File this complaint anonymously
                    </label>
                    <p style="color: var(--cs-text-muted); font-size: 12px; margin-top: 5px; padding-left: 22px;">
                        Checking this option hides your profile details from other public lists. System administrators and investigators will still verify your identity.
                    </p>
                </div>

                <button type="submit" class="btn btn-primary" style="width:100%;">
                    <i class="fa-solid fa-paper-plane" aria-hidden="true"></i> Submit complaint
                </button>

                </div><!-- /#manualFormFields -->
            </form>
        </div>
    </main>
</div>

</body>
</html>
