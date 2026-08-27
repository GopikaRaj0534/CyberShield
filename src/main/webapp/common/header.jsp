<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    if (ctx == null) ctx = "";

    /* Compute base path for assets when JSP is in a subdirectory (user/, admin/) */
    String servletPath = request.getServletPath() != null ? request.getServletPath() : "";
    String assetBase = servletPath.contains("/user/") || servletPath.contains("/admin/")
            ? ctx + "/"
            : ctx + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CyberShield — Smart Cybercrime Complaint and Threat Reporting System. Report cybercrime, track complaints, and access AI-assisted risk analysis.">
    <title>CyberShield</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= assetBase %>assets/css/cybershield-theme.css">
</head>
<body>

<header class="site-header">
    <div class="header-main">
        <a href="<%= ctx %>/" class="site-brand">
            <span class="brand-mark"><i class="fa-solid fa-shield-halved" aria-hidden="true"></i></span>
            <span class="brand-text">
                <span class="brand-name">CyberShield</span>
                <span class="brand-tagline">Cybercrime Complaint &amp; Threat Reporting</span>
            </span>
        </a>

        <button type="button" class="nav-toggle" id="navToggle" aria-label="Open navigation menu" aria-expanded="false">
            <i class="fa-solid fa-bars"></i>
        </button>

        <nav class="main-nav" id="navLinks" aria-label="Main navigation">
            <a href="<%= ctx %>/" class="<%= servletPath.equals("/index.jsp") || servletPath.equals("/") ? "active" : "" %>"><span class="i18n" data-en="Home">Home</span></a>
            <a href="<%= ctx %>/preemptive-check.jsp" class="<%= servletPath.contains("preemptive-check") ? "active" : "" %>"><span class="i18n" data-en="Check a link">Check a link</span></a>
            <a href="<%= ctx %>/learning/index.jsp" class="<%= servletPath.contains("/learning/") ? "active" : "" %>"><span class="i18n" data-en="Learning corner">Learning corner</span></a>
            <a href="<%= ctx %>/login.jsp" class="<%= servletPath.equals("/login.jsp") ? "active" : "" %>"><span class="i18n" data-en="Sign in">Sign in</span></a>
            <a href="<%= ctx %>/register.jsp" class="<%= servletPath.equals("/register.jsp") ? "active" : "" %>"><span class="i18n" data-en="Register">Register</span></a>
         
            <a href="<%= ctx %>/login.jsp" class="nav-cta"><span class="i18n" data-en="Report cybercrime">Report cybercrime</span></a>
        </nav>
    </div>
</header>

<script>
    // Lightweight EN/ML toggle - swaps any element tagged .i18n between its
    // data-en / data-ml text, remembered across pages via localStorage.
    function cybershieldApplyLanguage(lang) {
        document.querySelectorAll(".i18n").forEach(function (el) {
            var text = lang === "ml" ? el.getAttribute("data-ml") : el.getAttribute("data-en");
            if (text) el.textContent = text;
        });
        var btn = document.getElementById("langToggle");
        if (btn) btn.textContent = lang === "ml" ? "English" : "മലയാളം";
    }
    document.addEventListener("DOMContentLoaded", function () {
        var saved = localStorage.getItem("cs_lang") || "en";
        cybershieldApplyLanguage(saved);
        var btn = document.getElementById("langToggle");
        if (btn) {
            btn.addEventListener("click", function () {
                var current = localStorage.getItem("cs_lang") || "en";
                var next = current === "en" ? "ml" : "en";
                localStorage.setItem("cs_lang", next);
                cybershieldApplyLanguage(next);
            });
        }
    });
</script>

<main id="main-content">
