package com.cybershield.model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private Integer userId; // nullable - guests can submit feedback
    private String name;
    private String email;
    private String category;
    private int rating;
    private String message;
    private Timestamp createdAt;

    public Feedback() {}

    // Getters and Setters
    public int getFeedbackId()             { return feedbackId; }
    public void setFeedbackId(int id)      { this.feedbackId = id; }
    public Integer getUserId()             { return userId; }
    public void setUserId(Integer id)      { this.userId = id; }
    public String getName()                { return name; }
    public void setName(String name)       { this.name = name; }
    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }
    public String getCategory()            { return category; }
    public void setCategory(String c)      { this.category = c; }
    public int getRating()                 { return rating; }
    public void setRating(int r)           { this.rating = r; }
    public String getMessage()             { return message; }
    public void setMessage(String m)       { this.message = m; }
    public Timestamp getCreatedAt()        { return createdAt; }
    public void setCreatedAt(Timestamp t)  { this.createdAt = t; }
}
