package com.cybershield.model;

import java.sql.Timestamp;

public class Complaint {
    private int complaintId;
    private int userId;
    private String complaintType;
    private String subType;
    private String description;
    private String district;
    private String suspectUpiId;
    private String suspectBankAccount;
    private String suspectUrl;
    private String suspectEmail;
    private String riskLevel;
    private String status;
    private Timestamp createdAt;
    private String anonymous;
    private String evidencePath;
    private String assignedTo;
    private String remarks;
    private String aiExplanation;
    private Integer assignedInvestigatorId;
    private String assignedInvestigatorName; // populated via join for display only
    private Timestamp assignedAt;
    private String investigationReport;
    private String investigationEvidencePath;
    private Timestamp investigationSubmittedAt;

    
    public String getAnonymous() {
        return anonymous;
    }


    public void setAnonymous(String anonymous) {
        this.anonymous = anonymous;
    }
    
    public Complaint() {}

    // Getters and Setters
    public int getComplaintId()              { return complaintId; }
    public void setComplaintId(int id)       { this.complaintId = id; }
    public int getUserId()                   { return userId; }
    public void setUserId(int id)            { this.userId = id; }
    public String getComplaintType()         { return complaintType; }
    public void setComplaintType(String t)   { this.complaintType = t; }
    public String getSubType()               { return subType; }
    public void setSubType(String t)         { this.subType = t; }
    public String getDistrict()              { return district; }
    public void setDistrict(String d)        { this.district = d; }
    public String getSuspectUpiId()          { return suspectUpiId; }
    public void setSuspectUpiId(String v)    { this.suspectUpiId = v; }
    public String getSuspectBankAccount()    { return suspectBankAccount; }
    public void setSuspectBankAccount(String v) { this.suspectBankAccount = v; }
    public String getDescription()           { return description; }
    public void setDescription(String d)     { this.description = d; }
    public String getSuspectUrl()            { return suspectUrl; }
    public void setSuspectUrl(String u)      { this.suspectUrl = u; }
    public String getSuspectEmail()          { return suspectEmail; }
    public void setSuspectEmail(String e)    { this.suspectEmail = e; }
    public String getRiskLevel()             { return riskLevel; }
    public void setRiskLevel(String r)       { this.riskLevel = r; }
    public String getStatus()                { return status; }
    public void setStatus(String s)          { this.status = s; }
    public Timestamp getCreatedAt()          { return createdAt; }
    public void setCreatedAt(Timestamp t)    { this.createdAt = t; }
    public String getEvidencePath()          { return evidencePath; }
    public void setEvidencePath(String p)    { this.evidencePath = p; }
    public String getAssignedTo()            { return assignedTo; }
    public void setAssignedTo(String a)      { this.assignedTo = a; }
    public String getRemarks()               { return remarks; }
    public void setRemarks(String r)         { this.remarks = r; }
    public String getAiExplanation()         { return aiExplanation; }
    public void setAiExplanation(String e)   { this.aiExplanation = e; }
    public Integer getAssignedInvestigatorId()        { return assignedInvestigatorId; }
    public void setAssignedInvestigatorId(Integer id) { this.assignedInvestigatorId = id; }
    public String getAssignedInvestigatorName()       { return assignedInvestigatorName; }
    public void setAssignedInvestigatorName(String n) { this.assignedInvestigatorName = n; }
    public Timestamp getAssignedAt()                  { return assignedAt; }
    public void setAssignedAt(Timestamp t)            { this.assignedAt = t; }
    public String getInvestigationReport()            { return investigationReport; }
    public void setInvestigationReport(String r)      { this.investigationReport = r; }
    public String getInvestigationEvidencePath()      { return investigationEvidencePath; }
    public void setInvestigationEvidencePath(String p) { this.investigationEvidencePath = p; }
    public Timestamp getInvestigationSubmittedAt()          { return investigationSubmittedAt; }
    public void setInvestigationSubmittedAt(Timestamp t)    { this.investigationSubmittedAt = t; }
}

