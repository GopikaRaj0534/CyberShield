package com.cybershield.model;


public class Threat {


    private int threatId;

    private String url;

    private String email;

    private String messageHash;

    private int reportCount;

    private String status;



    public int getThreatId() {
        return threatId;
    }


    public void setThreatId(int threatId) {
        this.threatId = threatId;
    }



    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
    }



    public String getEmail() {
        return email;
    }


    public void setEmail(String email) {
        this.email = email;
    }



    public String getMessageHash() {
        return messageHash;
    }


    public void setMessageHash(String messageHash) {
        this.messageHash = messageHash;
    }



    public int getReportCount() {
        return reportCount;
    }


    public void setReportCount(int reportCount) {
        this.reportCount = reportCount;
    }



    public String getStatus() {
        return status;
    }


    public void setStatus(String status) {
        this.status = status;
    }

}