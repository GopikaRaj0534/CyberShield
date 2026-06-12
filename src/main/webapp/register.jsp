<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Registration</title>
</head>
<body>

<h2>CyberShield - User Registration</h2>

<form action="RegisterServlet" method="post">

    Name:
    <input type="text" name="name" required>
    <br><br>

    Email:
    <input type="email" name="email" required>
    <br><br>

    Password:
    <input type="password" name="password" required>
    <br><br>

    Confirm Password:
    <input type="password" name="confirmPassword" required>
    <br><br>

    <input type="submit" value="Register">

</form>

</body>
</html>