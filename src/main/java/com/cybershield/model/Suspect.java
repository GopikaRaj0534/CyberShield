package com.cybershield.model;

import java.sql.Timestamp;

public class Suspect {
    private int suspectId;
    private String identifierType;  // EMAIL, MOBILE, URL, SOCIAL_HANDLE
    private String identifierValue;
    private String platform;
    private int reportCount;
    private String status;
    private Timestamp createdAt;

    public Suspect() {}

    // Getters and Setters
    public int getSuspectId()                 { return suspectId; }
    public void setSuspectId(int id)          { this.suspectId = id; }
    public String getIdentifierType()         { return identifierType; }
    public void setIdentifierType(String t)   { this.identifierType = t; }
    public String getIdentifierValue()        { return identifierValue; }
    public void setIdentifierValue(String v)  { this.identifierValue = v; }
    public String getPlatform()               { return platform; }
    public void setPlatform(String p)         { this.platform = p; }
    public int getReportCount()               { return reportCount; }
    public void setReportCount(int c)         { this.reportCount = c; }
    public String getStatus()                 { return status; }
    public void setStatus(String s)           { this.status = s; }
    public Timestamp getCreatedAt()           { return createdAt; }
    public void setCreatedAt(Timestamp t)     { this.createdAt = t; }
}
