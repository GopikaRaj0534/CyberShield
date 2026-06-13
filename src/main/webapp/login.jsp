<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CyberShield – Login</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0a0a2e, #1a1a5e);
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
        }
        .card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(0,212,255,0.3);
            border-radius: 16px; padding: 40px; width: 420px;
            backdrop-filter: blur(10px);
            box-shadow: 0 0 40px rgba(0,212,255,0.15);
        }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo h1 { color: #00d4ff; font-size: 28px; letter-spacing: 2px; }
        .logo p  { color: #aaa; font-size: 13px; margin-top: 5px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; color: #ccc; font-size: 13px; margin-bottom: 6px; }
        input {
            width: 100%; padding: 12px 15px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(0,212,255,0.3);
            border-radius: 8px; color: #fff; font-size: 14px;
            outline: none; transition: border 0.3s;
        }
        input:focus { border-color: #00d4ff; }
        .btn {
            width: 100%; padding: 13px;
            background: linear-gradient(90deg, #00d4ff, #0099cc);
            border: none; border-radius: 8px; color: #fff;
            font-size: 15px; font-weight: bold; cursor: pointer;
            letter-spacing: 1px; transition: opacity 0.2s;
        }
        .btn:hover { opacity: 0.85; }
        .error {
            background: rgba(255,50,50,0.15);
            border: 1px solid rgba(255,50,50,0.4);
            color: #ff6b6b; border-radius: 8px;
            padding: 10px 14px; margin-bottom: 18px; font-size: 13px;
        }
        .success {
            background: rgba(0,255,150,0.1);
            border: 1px solid rgba(0,255,150,0.3);
            color: #00ff96; border-radius: 8px;
            padding: 10px 14px; margin-bottom: 18px; font-size: 13px;
        }
        .footer-link { text-align: center; margin-top: 20px; color: #aaa; font-size: 13px; }
        .footer-link a { color: #00d4ff; text-decoration: none; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <h1>🛡 CyberShield</h1>
        <p>Smart Cybercrime Reporting System</p>
    </div>

    <% if ("true".equals(request.getParameter("registered"))) { %>
        <div class="success">✅ Registration successful! Please login.</div>
    <% } %>
    <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="success">👋 Logged out successfully.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error">⚠ <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="LoginServlet" method="post">
        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter your email" required />
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required />
        </div>
        <button type="submit" class="btn">LOGIN</button>
    </form>

    <div class="footer-link">
        Don't have an account? <a href="register.jsp">Register here</a>
    </div>
</div>
</body>
</html>