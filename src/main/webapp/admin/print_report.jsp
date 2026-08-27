<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.UserDAO" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>

<%
User admin = (User) session.getAttribute("loggedUser");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
    response.sendRedirect("../login.jsp");
    return;
}

ComplaintDAO dao = new ComplaintDAO();
UserDAO userDAO = new UserDAO();
List<Complaint> complaints = dao.getAllComplaints();
%>

<!DOCTYPE html>
<html>
<head>
    <title>CyberShield Incidents Report</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            color: #333;
            background: white;
            padding: 30px;
        }

        .report-header {
            text-align: center;
            border-bottom: 3px double #333;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .report-header h1 {
            font-size: 26px;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .report-header p {
            font-size: 14px;
            color: #666;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }

        th {
            background: #eaeaea;
            color: black;
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
            font-weight: bold;
            text-transform: uppercase;
        }

        td {
            border: 1px solid #ccc;
            padding: 10px;
            vertical-align: top;
        }

        tr:nth-child(even) {
            background: #fafafa;
        }

        .meta-text {
            color: #555;
            font-size: 11px;
            margin-top: 3px;
        }

        .badge {
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .high { color: #dc2626; }
        .medium { color: #d97706; }
        .low { color: #059669; }

        @media print {
            body {
                padding: 0;
            }
            .print-btn {
                display: none;
            }
        }

        .print-btn {
            background: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

    <button onclick="window.print();" class="print-btn">🖨️ Print Report / Save PDF</button>

    <div class="report-header">
        <h1>🛡️ CyberShield Law Enforcement Report</h1>
        <p>Generated on: <%= new java.util.Date() %> | System Administrator: <%= SecurityUtil.escapeHtml(admin.getName()) %></p>
        <p>Total Logged Cases: <%= complaints.size() %> Incidents</p>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 8%">ID</th>
                <th style="width: 18%">Reporter</th>
                <th style="width: 15%">Incident Type</th>
                <th style="width: 34%">Incident Description</th>
                <th style="width: 13%">Risk & State</th>
                <th style="width: 12%">Assignment</th>
            </tr>
        </thead>
        <tbody>
            <%
            for (Complaint c : complaints) {
                User reporter = userDAO.getUserById(c.getUserId());
                String reporterName = (c.getAnonymous() != null && c.getAnonymous().equalsIgnoreCase("YES")) 
                                      ? "Anonymous Citizen" 
                                      : (reporter != null ? reporter.getName() : "Unknown");
                
                String riskColor = "low";
                if ("HIGH".equals(c.getRiskLevel())) riskColor = "high";
                else if ("MEDIUM".equals(c.getRiskLevel())) riskColor = "medium";
            %>
            <tr>
                <td>#<%= c.getComplaintId() %></td>
                <td>
                    <strong><%= reporterName %></strong>
                    <% if (!"Anonymous Citizen".equals(reporterName) && reporter != null) { %>
                        <div class="meta-text"><%= SecurityUtil.escapeHtml(reporter.getEmail()) %></div>
                    <% } %>
                </td>
                <td><strong><%= SecurityUtil.escapeHtml(c.getComplaintType()) %></strong></td>
                <td>
                    <%= SecurityUtil.escapeHtml(c.getDescription()) %>
                    <% if (c.getSuspectUrl() != null && !c.getSuspectUrl().isEmpty()) { %>
                        <div class="meta-text">URL: <%= SecurityUtil.escapeHtml(c.getSuspectUrl()) %></div>
                    <% } %>
                    <% if (c.getSuspectEmail() != null && !c.getSuspectEmail().isEmpty()) { %>
                        <div class="meta-text">Email: <%= SecurityUtil.escapeHtml(c.getSuspectEmail()) %></div>
                    <% } %>
                </td>
                <td>
                    Risk: <span class="badge <%= riskColor %>"><%= c.getRiskLevel() %></span>
                    <div class="meta-text" style="font-weight: bold; margin-top: 5px;">State: <%= c.getStatus() %></div>
                </td>
                <td>
                    <%= c.getAssignedTo() != null && !c.getAssignedTo().isEmpty() ? "Assigned to:<br><strong>" + SecurityUtil.escapeHtml(c.getAssignedTo()) + "</strong>" : "Unassigned" %>
                    <% if (c.getRemarks() != null && !c.getRemarks().isEmpty()) { %>
                        <div class="meta-text" style="border-top: 1px solid #eee; margin-top: 5px; padding-top: 5px;">Remarks: <%= SecurityUtil.escapeHtml(c.getRemarks()) %></div>
                    <% } %>
                </td>
            </tr>
            <%
            }
            %>
        </tbody>
    </table>

    <script>
        // Auto trigger browser print dialogue on load
        window.addEventListener('load', function() {
            setTimeout(function() {
                window.print();
            }, 500);
        });
    </script>
</body>
</html>
