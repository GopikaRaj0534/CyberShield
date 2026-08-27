package com.cybershield.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String role; // "USER", "INVESTIGATOR", or "ADMIN"
    private String secQuestion;
    private String secAnswer;
    private String phone;

    public User() {}

    public User(String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public User(String name, String email, String password, String role, String secQuestion, String secAnswer) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.secQuestion = secQuestion;
        this.secAnswer = secAnswer;
    }

    public User(String name, String email, String password, String role, String secQuestion, String secAnswer, String phone) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.secQuestion = secQuestion;
        this.secAnswer = secAnswer;
        this.phone = phone;
    }

    // Getters & Setters
    public int getUserId()            { return userId; }
    public void setUserId(int id)     { this.userId = id; }
    public String getName()           { return name; }
    public void setName(String name)  { this.name = name; }
    public String getEmail()          { return email; }
    public void setEmail(String e)    { this.email = e; }
    public String getPassword()       { return password; }
    public void setPassword(String p) { this.password = p; }
    public String getRole()           { return role; }
    public void setRole(String r)     { this.role = r; }
    public String getSecQuestion()    { return secQuestion; }
    public void setSecQuestion(String q) { this.secQuestion = q; }
    public String getSecAnswer()      { return secAnswer; }
    public void setSecAnswer(String a)   { this.secAnswer = a; }
    public String getPhone()          { return phone; }
    public void setPhone(String p)    { this.phone = p; }
}