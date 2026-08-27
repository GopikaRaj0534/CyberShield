<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="../common/header.jsp" %>

<style>
    /* FAQ PAGE */
    .faq-page {
        width: 100%;
        max-width: 900px;
        margin: 40px auto;
        padding: 0 20px;
        box-sizing: border-box;
    }

    .faq-card {
        width: 100%;
        background: #ffffff;
        border-radius: 12px;
        padding: 0;
        margin: 0 auto;
        box-sizing: border-box;
        overflow: hidden;
        border: 1px solid #e2e6ea;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
    }

    /* Each FAQ */
    .faq-item {
        width: 100%;
        margin: 0;
        padding: 0;
        border-bottom: 1px solid #e2e6ea;
        box-sizing: border-box;
    }

    .faq-item:last-child {
        border-bottom: none;
    }

    /* Question */
    .faq-question {
        width: 100%;
        margin: 0;
        padding: 20px 55px 20px 24px;
        box-sizing: border-box;

        display: block;
        position: relative;

        background: #ffffff;
        color: #1f2937;

        font-size: 16px;
        font-weight: 600;
        line-height: 1.5;

        cursor: pointer;
        text-align: left;

        list-style: none;
        user-select: none;
    }

    /* Remove browser default arrow */
    .faq-question::-webkit-details-marker {
        display: none;
    }

    .faq-question::marker {
        display: none;
    }

    /* Plus icon */
    .faq-question::after {
        content: "+";
        position: absolute;
        right: 24px;
        top: 50%;
        transform: translateY(-50%);

        font-size: 24px;
        font-weight: 400;
        line-height: 1;

        color: #555;
    }

    /* Hover */
    .faq-question:hover {
        background: #f8fafc;
    }

    /* Open question */
    .faq-item details[open] .faq-question {
        background: #f8fafc;
    }

    /* Minus icon when opened */
    .faq-item details[open] .faq-question::after {
        content: "−";
    }

    /* Answer */
    .faq-answer {
        width: 100%;
        margin: 0;
        padding: 0 55px 22px 24px;
        box-sizing: border-box;

        background: #f8fafc;
        color: #555;

        font-size: 15px;
        line-height: 1.7;

        text-align: left;
    }

    .faq-answer a {
        color: #0f2c4c;
        font-weight: 600;
        text-decoration: none;
    }

    .faq-answer a:hover {
        text-decoration: underline;
    }

    /* Mobile */
    @media (max-width: 600px) {

        .faq-page {
            margin: 25px auto;
            padding: 0 12px;
        }

        .faq-question {
            padding: 17px 45px 17px 18px;
            font-size: 15px;
        }

        .faq-question::after {
            right: 18px;
            font-size: 22px;
        }

        .faq-answer {
            padding: 0 45px 18px 18px;
            font-size: 14px;
        }
    }
</style>


<div class="faq-page">

    <div class="faq-card">

        <!-- FAQ 1 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    Do I need an account to report cybercrime?
                </summary>

                <div class="faq-answer">
                    Yes — so we can send status updates. You can still file
                    anonymously; your name stays hidden from other citizens.
                </div>
            </details>
        </div>


        <!-- FAQ 2 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    Which category should I choose?
                </summary>

                <div class="faq-answer">
                    Women &amp; Child Related Crime, Financial Fraud, or Other
                    Cybercrime — then the specific incident type shown for that
                    category.
                </div>
            </details>
        </div>


        <!-- FAQ 3 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    How is my risk level decided?
                </summary>

                <div class="faq-answer">
                    An AI model screens your description, suspect URL, and email,
                    and classifies the case as Low, Medium, or High risk.
                </div>
            </details>
        </div>


        <!-- FAQ 4 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    What is the Suspect Repository?
                </summary>

                <div class="faq-answer">
                    A shared list of emails, numbers, URLs, and handles citizens
                    have flagged. Check it before you click or pay.
                </div>
            </details>
        </div>


        <!-- FAQ 5 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    Can I track my complaint?
                </summary>

                <div class="faq-answer">
                    Yes — every complaint moves through Pending, Under
                    Investigation, Resolved, or Rejected.
                </div>
            </details>
        </div>


        <!-- FAQ 6 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    Is this an official government portal?
                </summary>

                <div class="faq-answer">
                    No — CyberShield is an academic project. For official
                    reporting in India, use cybercrime.gov.in or call 1930.
                </div>
            </details>
        </div>


        <!-- FAQ 7 -->
        <div class="faq-item">
            <details>
                <summary class="faq-question">
                    How do I give feedback?
                </summary>

                <div class="faq-answer">
                    Use the
                    <a href="<%= request.getContextPath() %>/feedback.jsp">
                        Feedback page
                    </a>
                    — logged in or not.
                </div>
            </details>
        </div>

    </div>

</div>


<%@ include file="../common/footer.jsp" %>