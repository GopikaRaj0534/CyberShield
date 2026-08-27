package com.cybershield.model;

import java.sql.Timestamp;

/** A citizen's rating of how their specific complaint was handled - distinct from the general site Feedback. */
public class ComplaintFeedback {
    private int complaintFeedbackId;
    private int complaintId;
    private int userId;
    private int rating;
    private String comments;
    private Timestamp createdAt;

    public ComplaintFeedback() {}

    public int getComplaintFeedbackId()     { return complaintFeedbackId; }
    public void setComplaintFeedbackId(int id) { this.complaintFeedbackId = id; }
    public int getComplaintId()             { return complaintId; }
    public void setComplaintId(int id)      { this.complaintId = id; }
    public int getUserId()                  { return userId; }
    public void setUserId(int id)           { this.userId = id; }
    public int getRating()                  { return rating; }
    public void setRating(int r)            { this.rating = r; }
    public String getComments()             { return comments; }
    public void setComments(String c)       { this.comments = c; }
    public Timestamp getCreatedAt()         { return createdAt; }
    public void setCreatedAt(Timestamp t)   { this.createdAt = t; }
}
