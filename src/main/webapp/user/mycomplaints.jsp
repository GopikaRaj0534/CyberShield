<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.cybershield.model.User" %>
<%@ page import="com.cybershield.model.Complaint" %>
<%@ page import="com.cybershield.model.ComplaintFeedback" %>
<%@ page import="com.cybershield.dao.ComplaintDAO" %>
<%@ page import="com.cybershield.dao.ComplaintFeedbackDAO" %>
<%@ page import="com.cybershield.util.SecurityUtil" %>
<%@ page import="java.util.List" %>

<%
User user = (User) session.getAttribute("loggedUser");

if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

ComplaintDAO dao = new ComplaintDAO();
ComplaintFeedbackDAO feedbackDAO = new ComplaintFeedbackDAO();

String keyword = request.getParameter("keyword");
String status = request.getParameter("status");
String riskLevel = request.getParameter("riskLevel");

boolean justRated = "true".equals(request.getParameter("rated"));

List<Complaint> complaints;

if ((keyword != null && !keyword.trim().isEmpty())
        || (status != null && !status.equals("ALL") && !status.trim().isEmpty())
        || (riskLevel != null && !riskLevel.equals("ALL") && !riskLevel.trim().isEmpty())) {

    complaints = dao.searchAndFilterUserComplaints(
            user.getUserId(),
            keyword,
            status,
            riskLevel
    );

} else {

    complaints = dao.getComplaintsByUserId(user.getUserId());
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Complaints - CyberShield</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Manrope:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/cybershield-theme.css">

    <style>

        .rating-section {
            margin-top: 10px;
            padding: 15px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .rating-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 3px;
            margin-bottom: 10px;
        }

        .star-rating input {
            display: none;
        }

        .star-rating label {
            font-size: 28px;
            color: #cbd5e1;
            cursor: pointer;
            transition: 0.2s;
        }

        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #f5a623;
        }

        .feedback-comment {
            width: 100%;
            box-sizing: border-box;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            padding: 9px;
            font-family: inherit;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .feedback-comment:focus {
            outline: none;
            border-color: #2563eb;
        }

        .feedback-success {
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .existing-rating {
            color: #f5a623;
            font-size: 20px;
        }

    </style>

</head>

<body>

<div class="portal-shell">

    <jsp:include page="/common/user-sidebar.jsp">
        <jsp:param name="active" value="mycomplaints" />
    </jsp:include>

    <main class="portal-main">

        <h1>My complaints history</h1>

        <p class="page-sub">
            Track and review every incident you've reported.
        </p>

        <a href="complaint.jsp"
           class="btn btn-primary"
           style="margin-bottom:25px;">

            <i class="fa-solid fa-plus"></i>
            File new complaint

        </a>


        <!-- =====================================================
             RATING SUCCESS MESSAGE
             ===================================================== -->

        <% if (justRated) { %>

            <div class="feedback-success">

                <i class="fa-solid fa-circle-check"></i>

                Thanks for your rating — it helps us evaluate
                how cases are being handled.

            </div>

        <% } %>


        <!-- =====================================================
             SEARCH AND FILTER
             ===================================================== -->

        <form method="get"
              action="mycomplaints.jsp"
              class="filter-panel">

            <input type="text"
                   name="keyword"
                   placeholder="Search by keywords..."
                   value="<%= keyword != null ? SecurityUtil.escapeHtml(keyword) : "" %>">

            <select name="status">

                <option value="ALL">
                    -- All statuses --
                </option>

                <option value="Pending"
                    <%= "Pending".equals(status) ? "selected" : "" %>>
                    Pending
                </option>

                <option value="Under Investigation"
                    <%= "Under Investigation".equals(status) ? "selected" : "" %>>
                    Under Investigation
                </option>

                <option value="Resolved"
                    <%= "Resolved".equals(status) ? "selected" : "" %>>
                    Resolved
                </option>

                <option value="Rejected"
                    <%= "Rejected".equals(status) ? "selected" : "" %>>
                    Rejected
                </option>

            </select>

            <button type="submit"
                    class="btn btn-primary">

                Search

            </button>

            <a href="mycomplaints.jsp"
               class="clear-btn">

                Clear

            </a>

        </form>


        <!-- =====================================================
             NO COMPLAINTS
             ===================================================== -->

        <% if (complaints == null || complaints.isEmpty()) { %>

            <div class="empty-state">

                <h2>No complaints found</h2>

                <p>
                    Verify your filters or file a new complaint
                    to get started.
                </p>

            </div>

        <% } else { %>


            <!-- =================================================
                 COMPLAINT LOOP
                 ================================================= -->

            <% for (Complaint c : complaints) {

                String statusClass = "pending";

                if ("Resolved".equalsIgnoreCase(c.getStatus())) {

                    statusClass = "resolved";

                } else if ("Under Investigation".equalsIgnoreCase(c.getStatus())) {

                    statusClass = "investigation";

                } else if ("Rejected".equalsIgnoreCase(c.getStatus())) {

                    statusClass = "rejected";
                }


                String riskClass = "risk-low";
                String cardBorder = "risk-border-low";

                if ("HIGH".equalsIgnoreCase(c.getRiskLevel())) {

                    riskClass = "risk-high";
                    cardBorder = "risk-border-high";

                } else if ("MEDIUM".equalsIgnoreCase(c.getRiskLevel())) {

                    riskClass = "risk-medium";
                    cardBorder = "risk-border-medium";
                }

            %>


            <div class="record-card <%= cardBorder %>">


                <!-- Complaint ID -->

                <div class="record-row">

                    <span class="label">
                        Complaint ID
                    </span>

                    <span>
                        #<%= c.getComplaintId() %>
                    </span>

                </div>


                <!-- Complaint Type -->

                <div class="record-row">

                    <span class="label">
                        Registration category
                    </span>

                    <span>
                        <strong>
                            <%= SecurityUtil.escapeHtml(c.getComplaintType()) %>
                        </strong>
                    </span>

                </div>


                <!-- Sub Type -->

                <% if (c.getSubType() != null
                        && !c.getSubType().isEmpty()) { %>

                    <div class="record-row">

                        <span class="label">
                            Specific incident type
                        </span>

                        <span>
                            <%= SecurityUtil.escapeHtml(c.getSubType()) %>
                        </span>

                    </div>

                <% } %>


                <!-- Description -->

                <div class="record-row">

                    <span class="label">
                        Description
                    </span>

                    <span style="max-width:75%;
                                 text-align:right;">

                        <%= SecurityUtil.escapeHtml(c.getDescription()) %>

                    </span>

                </div>


                <!-- Suspect Details -->

                <div class="record-row">

                    <span class="label">
                        Suspect details
                    </span>

                    <span>

                        URL:

                        <%= c.getSuspectUrl() != null
                                && !c.getSuspectUrl().isEmpty()
                                ? SecurityUtil.escapeHtml(c.getSuspectUrl())
                                : "N/A" %>

                        |

                        Email:

                        <%= c.getSuspectEmail() != null
                                && !c.getSuspectEmail().isEmpty()
                                ? SecurityUtil.escapeHtml(c.getSuspectEmail())
                                : "N/A" %>

                    </span>

                </div>


                <!-- Risk -->

                <div class="record-row">

                    <span class="label">
                        AI risk category
                    </span>

                    <span class="<%= riskClass %>">

                        <%= c.getRiskLevel() %>

                    </span>

                </div>


                <!-- Status -->

                <div class="record-row">

                    <span class="label">
                        Processing state
                    </span>

                    <span class="badge <%= statusClass %>">

                        <%= c.getStatus() %>

                    </span>

                </div>


                <!-- Created Date -->

                <div class="record-row">

                    <span class="label">
                        Submitted on
                    </span>

                    <span>
                        <%= c.getCreatedAt() %>
                    </span>

                </div>


                <!-- Evidence -->

                <% if (c.getEvidencePath() != null
                        && !c.getEvidencePath().isEmpty()) { %>

                    <div class="record-row">

                        <span class="label">
                            Evidence file
                        </span>

                        <a href="../<%= c.getEvidencePath() %>"
                           target="_blank"
                           class="evidence-btn">

                            <i class="fa-solid fa-paperclip"></i>

                            View evidence attachment

                        </a>

                    </div>

                <% } %>


                <!-- =================================================
                     INVESTIGATION / ADMIN DETAILS
                     ================================================= -->

                <% if ((c.getAssignedTo() != null
                        && !c.getAssignedTo().isEmpty())
                        ||
                        (c.getRemarks() != null
                        && !c.getRemarks().isEmpty())
                        ||
                        (c.getInvestigationReport() != null
                        && !c.getInvestigationReport().isEmpty())
                        ||
                        (c.getAiExplanation() != null
                        && !c.getAiExplanation().isEmpty())) { %>


                    <div class="record-row nested">


                        <% if (c.getAiExplanation() != null
                                && !c.getAiExplanation().isEmpty()) { %>

                            <div style="margin-bottom:8px;">

                                <span class="label">
                                    <i class="fa-solid fa-robot"></i>
                                    AI diagnostics:
                                </span>

                                <span style="color:var(--cs-text-muted);
                                             font-size:14px;">

                                    <%= SecurityUtil.escapeHtml(
                                            c.getAiExplanation()) %>

                                </span>

                            </div>

                        <% } %>


                        <% if (c.getAssignedTo() != null
                                && !c.getAssignedTo().isEmpty()) { %>

                            <div style="margin-bottom:8px;">

                                <span class="label">

                                    <i class="fa-solid fa-user-shield"></i>

                                    Assigned investigator:

                                </span>
                                <span style="color:var(--cs-text-muted);
                                             font-size:14px;">
                                    <%= SecurityUtil.escapeHtml(
                                            c.getAssignedTo()) %>
                                </span>
                            </div>
                        <% } %>
                        <% if (c.getInvestigationReport() != null
                                && !c.getInvestigationReport().isEmpty()) { %>
                            <div style="margin-bottom:8px;">
                                <span class="label">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    Investigation findings:
                                </span>
                                <span style="color:var(--cs-text-muted);
                                             font-size:14px;">
                                    <%= SecurityUtil.escapeHtml(
                                            c.getInvestigationReport()) %>
                                </span>
                                <% if (c.getInvestigationEvidencePath() != null
                                        && !c.getInvestigationEvidencePath().isEmpty()) { %>
                                    <br>
                                    <a href="../<%= c.getInvestigationEvidencePath() %>"
                                       target="_blank"
                                       class="evidence-btn"
                                       style="margin-top:6px;">
                                        <i class="fa-solid fa-paperclip"></i>
                                        View investigator's evidence
                                    </a>
                                <% } %>
                            </div>
                        <% } %>
                        <% if (c.getRemarks() != null
                                && !c.getRemarks().isEmpty()) { %>
                            <div>
                                <span class="label">
                                    <i class="fa-solid fa-note-sticky"></i>
                                    Administrative remarks:
                                </span>
                                <span style="color:var(--cs-text-muted);
                                             font-size:14px;">
                                    <%= SecurityUtil.escapeHtml(
                                            c.getRemarks()) %>
                                </span>
                            </div>
                        <% } %>
                    </div>
                <% } %>
                <!-- =================================================
                     FEEDBACK / RATING SECTION
                     ================================================= -->

                <% if ("Resolved".equalsIgnoreCase(c.getStatus())
                        || "Rejected".equalsIgnoreCase(c.getStatus())) {


                    ComplaintFeedback existingFeedback =
                            feedbackDAO.getByComplaintId(
                                    c.getComplaintId()
                            );

                %>


                    <div class="record-row nested rating-section">


                        <% if (existingFeedback != null) { %>


                            <!-- EXISTING RATING -->

                            <div>

                                <div class="rating-title">

                                    <i class="fa-solid fa-star"></i>

                                    Your rating of how this case was handled:

                                </div>


                                <div class="existing-rating">

                                    <% for (int i = 1; i <= 5; i++) { %>

                                        <i class="fa-solid fa-star"
                                           style="<%= i <= existingFeedback.getRating()
                                                   ? ""
                                                   : "opacity:0.25;" %>">
                                        </i>

                                    <% } %>

                                </div>


                                <% if (existingFeedback.getComments() != null
                                        && !existingFeedback.getComments().trim().isEmpty()) { %>

                                    <div style="color:var(--cs-text-muted);
                                                font-size:13px;
                                                margin-top:6px;">

                                        <strong>Comment:</strong>

                                        <%= SecurityUtil.escapeHtml(
                                                existingFeedback.getComments()) %>

                                    </div>

                                <% } %>

                            </div>


                        <% } else { %>


                            <!-- NEW RATING FORM -->

                            <form action="<%= request.getContextPath() %>/ComplaintFeedbackServlet"
                                  method="post"
                                  style="width:100%;">

                                <input type="hidden"
                                       name="csrfToken"
                                       value="<%= session.getAttribute("csrfToken") != null
                                               ? session.getAttribute("csrfToken")
                                               : "" %>">


                                <input type="hidden"
                                       name="complaintId"
                                       value="<%= c.getComplaintId() %>">


                                <label class="rating-title">

                                    <i class="fa-solid fa-star"></i>

                                    How was your case handled?

                                </label>


                                <!-- STARS -->

                                <div class="star-rating">


                                    <input type="radio"
                                           id="rating5_<%= c.getComplaintId() %>"
                                           name="rating"
                                           value="5"
                                           checked>

                                    <label for="rating5_<%= c.getComplaintId() %>"
                                           title="Excellent">

                                        ★

                                    </label>


                                    <input type="radio"
                                           id="rating4_<%= c.getComplaintId() %>"
                                           name="rating"
                                           value="4">

                                    <label for="rating4_<%= c.getComplaintId() %>"
                                           title="Very good">

                                        ★

                                    </label>


                                    <input type="radio"
                                           id="rating3_<%= c.getComplaintId() %>"
                                           name="rating"
                                           value="3">

                                    <label for="rating3_<%= c.getComplaintId() %>"
                                           title="Good">

                                        ★

                                    </label>


                                    <input type="radio"
                                           id="rating2_<%= c.getComplaintId() %>"
                                           name="rating"
                                           value="2">

                                    <label for="rating2_<%= c.getComplaintId() %>"
                                           title="Average">

                                        ★

                                    </label>


                                    <input type="radio"
                                           id="rating1_<%= c.getComplaintId() %>"
                                           name="rating"
                                           value="1">

                                    <label for="rating1_<%= c.getComplaintId() %>"
                                           title="Poor">

                                        ★

                                    </label>


                                </div>


                                <!-- COMMENT -->

                                <textarea name="comments"
                                          class="feedback-comment"
                                          rows="3"
                                          maxlength="500"
                                          placeholder="Optional comment about how it was handled..."></textarea>


                                <!-- SUBMIT -->

                                <button type="submit"
                                        class="btn btn-secondary">

                                    <i class="fa-solid fa-paper-plane"></i>

                                    Submit rating

                                </button>


                            </form>


                        <% } %>


                    </div>


                <% } %>


            </div>


            <% } %>
        <% } %>
    </main>
</div>
</body>
</html>