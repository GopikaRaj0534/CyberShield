<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.ThreatDAO" %>
<%@ page import="com.cybershield.model.User" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

ComplaintDAO cdao = new ComplaintDAO();
ThreatDAO tdao = new ThreatDAO();

int total = cdao.countAll();
int pending = cdao.countAllByStatus("Pending");
int investigate = cdao.countAllByStatus("Under Investigation");
int resolved = cdao.countAllByStatus("Resolved");
int rejected = cdao.countAllByStatus("Rejected");

int highRisk = cdao.countAllByRiskLevel("HIGH");
int medRisk = cdao.countAllByRiskLevel("MEDIUM");
int lowRisk = cdao.countAllByRiskLevel("LOW");

int threats = tdao.countThreats();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CyberShield Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="portal-shell">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="dashboard" />
    </jsp:include>

    <main class="portal-main">
        <h1>Command intelligence dashboard</h1>
        <p class="page-sub">Welcome, <%= admin.getName() %> &mdash; command operations overview.</p>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="label">Total reports filed</div>
                <div class="value"><%= total %></div>
            </div>
            <div class="stat-card">
                <div class="label">Pending case action</div>
                <div class="value" style="color: var(--cs-warning);"><%= pending %></div>
            </div>
            <div class="stat-card">
                <div class="label">Active investigations</div>
                <div class="value" style="color: var(--cs-saffron-hover);"><%= investigate %></div>
            </div>
            <div class="stat-card">
                <div class="label">Resolved closures</div>
                <div class="value" style="color: var(--cs-success);"><%= resolved %></div>
            </div>
            <div class="stat-card">
                <div class="label">Active malicious vectors</div>
                <div class="value" style="color: var(--cs-danger);"><%= threats %></div>
            </div>
        </div>

        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 24px;">
            <!-- Status Distribution Doughnut Chart -->
            <div class="card">
                <h3 style="border-bottom:1px solid var(--cs-border-light); padding-bottom:10px; margin-bottom:20px;">Case processing lifecycle</h3>
                <div style="height: 300px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>

            <!-- Risk Distribution Bar Chart -->
            <div class="card">
                <h3 style="border-bottom:1px solid var(--cs-border-light); padding-bottom:10px; margin-bottom:20px;">Threat risk level distribution</h3>
                <div style="height: 300px; display: flex; justify-content: center; align-items: center;">
                    <canvas id="riskChart"></canvas>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // Setup Case Status Chart
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    new Chart(statusCtx, {
        type: 'doughnut',
        data: {
            labels: ['Pending', 'Under Investigation', 'Resolved', 'Rejected'],
            datasets: [{
                data: [<%= pending %>, <%= investigate %>, <%= resolved %>, <%= rejected %>],
                backgroundColor: ['#b45309', '#FF9933', '#0F7B4E', '#b91c1c'],
                borderWidth: 2,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        font: { family: 'Inter', size: 12 }
                    }
                }
            }
        }
    });

    // Setup Risk Level Chart
    const riskCtx = document.getElementById('riskChart').getContext('2d');
    new Chart(riskCtx, {
        type: 'bar',
        data: {
            labels: ['High Risk', 'Medium Risk', 'Low Risk'],
            datasets: [{
                label: 'Cases Count',
                data: [<%= highRisk %>, <%= medRisk %>, <%= lowRisk %>],
                backgroundColor: ['#b91c1c', '#FF9933', '#0F7B4E'],
                borderRadius: 6,
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            }
        }
    });
</script>
</body>
</html>
