package com.cybershield.model;

import java.sql.Timestamp;

public class SuspectReport {
    private int suspectReportId;
    private int suspectId;
    private int userId;
    private String reportCategory; // Social Media Abuse, Scam Call, Fake Profile, Other
    private String platform;
    private String details;
    private String evidencePath;
    private Timestamp createdAt;

    // Populated via join for display purposes (not persisted directly)
    private String identifierType;
    private String identifierValue;

    public SuspectReport() {}

    // Getters and Setters
    public int getSuspectReportId()            { return suspectReportId; }
    public void setSuspectReportId(int id)     { this.suspectReportId = id; }
    public int getSuspectId()                  { return suspectId; }
    public void setSuspectId(int id)           { this.suspectId = id; }
    public int getUserId()                     { return userId; }
    public void setUserId(int id)              { this.userId = id; }
    public String getReportCategory()          { return reportCategory; }
    public void setReportCategory(String c)    { this.reportCategory = c; }
    public String getPlatform()                { return platform; }
    public void setPlatform(String p)          { this.platform = p; }
    public String getDetails()                 { return details; }
    public void setDetails(String d)           { this.details = d; }
    public String getEvidencePath()            { return evidencePath; }
    public void setEvidencePath(String p)      { this.evidencePath = p; }
    public Timestamp getCreatedAt()            { return createdAt; }
    public void setCreatedAt(Timestamp t)      { this.createdAt = t; }
    public String getIdentifierType()          { return identifierType; }
    public void setIdentifierType(String t)    { this.identifierType = t; }
    public String getIdentifierValue()         { return identifierValue; }
    public void setIdentifierValue(String v)   { this.identifierValue = v; }
}
