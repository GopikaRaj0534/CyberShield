<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CyberShield – Dashboard</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',sans-serif; background:#0d0d2b; color:#fff; display:flex; }
        .sidebar {
            width:240px; min-height:100vh;
            background:rgba(0,212,255,0.05);
            border-right:1px solid rgba(0,212,255,0.2);
            padding:30px 0;
        }
        .sidebar .brand { text-align:center; padding:0 20px 30px; border-bottom:1px solid rgba(0,212,255,0.2); }
        .sidebar .brand h2 { color:#00d4ff; font-size:20px; }
        .sidebar nav { margin-top:20px; }
        .sidebar nav a {
            display:block; padding:14px 25px; color:#ccc;
            text-decoration:none; font-size:14px;
            border-left:3px solid transparent; transition:all 0.2s;
        }
        .sidebar nav a:hover { color:#00d4ff; background:rgba(0,212,255,0.08); border-left-color:#00d4ff; }
        .main { flex:1; padding:30px; }
        .topbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:30px; }
        .topbar h1 { font-size:22px; }
        .logout-btn {
            background:rgba(255,50,50,0.15); border:1px solid rgba(255,50,50,0.3);
            color:#ff6b6b; padding:8px 16px; border-radius:6px;
            text-decoration:none; font-size:13px;
        }
        .stats { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:30px; }
        .stat-card {
            background:rgba(255,255,255,0.05);
            border:1px solid rgba(0,212,255,0.2);
            border-radius:12px; padding:20px;
        }
        .stat-card .label { color:#aaa; font-size:12px; margin-bottom:8px; }
        .stat-card .value { font-size:28px; font-weight:bold; color:#00d4ff; }
        .actions { display:grid; grid-template-columns:repeat(3,1fr); gap:15px; }
        .action-card {
            background:rgba(255,255,255,0.04);
            border:1px solid rgba(0,212,255,0.15);
            border-radius:12px; padding:25px; text-align:center;
            text-decoration:none; color:#fff; transition:all 0.3s;
        }
        .action-card:hover { border-color:#00d4ff; background:rgba(0,212,255,0.08); transform:translateY(-2px); }
        .action-card .icon  { font-size:32px; margin-bottom:10px; }
        .action-card .title { font-size:14px; font-weight:bold; color:#00d4ff; }
        .action-card .desc  { font-size:12px; color:#888; margin-top:5px; }
        .section-title { font-size:16px; color:#ccc; margin-bottom:15px; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:8px; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand"><h2>🛡 CyberShield</h2></div>
    <nav>
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="complaint.jsp">🚨 Report Crime</a>
        <a href="mycomplaints.jsp">📁 My Complaints</a>
        <a href="track.jsp">🔍 Track Status</a>
        <a href="../LogoutServlet">🚪 Logout</a>
    </nav>
</div>

<div class="main">
    <div class="topbar">
        <h1>Welcome, <%= loggedUser.getName() %> 👋</h1>
        <a href="../LogoutServlet" class="logout-btn">Logout</a>
    </div>

    <div class="stats">
        <div class="stat-card">
            <div class="label">Total Complaints</div>
            <div class="value">0</div>
        </div>
        <div class="stat-card">
            <div class="label">Pending</div>
            <div class="value" style="color:#f39c12;">0</div>
        </div>
        <div class="stat-card">
            <div class="label">Under Investigation</div>
            <div class="value" style="color:#9b59b6;">0</div>
        </div>
        <div class="stat-card">
            <div class="label">Resolved</div>
            <div class="value" style="color:#2ecc71;">0</div>
        </div>
    </div>

    <div class="section-title">Quick Actions</div>
    <div class="actions">
        <a href="complaint.jsp" class="action-card">
            <div class="icon">🚨</div>
            <div class="title">Report Cybercrime</div>
            <div class="desc">Submit a new complaint</div>
        </a>
        <a href="mycomplaints.jsp" class="action-card">
            <div class="icon">📁</div>
            <div class="title">My Complaints</div>
            <div class="desc">View all your reports</div>
        </a>
        <a href="track.jsp" class="action-card">
            <div class="icon">🔍</div>
            <div class="title">Track Status</div>
            <div class="desc">Check complaint progress</div>
        </a>
    </div>
</div>
</body>
</html>