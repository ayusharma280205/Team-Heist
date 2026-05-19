<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Portal - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e8f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #2c3e50; }
        .group { margin-bottom: 15px; } label { font-weight: bold; display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background-color: #2980b9; color: white; border: none; padding: 12px; border-radius: 4px; cursor: pointer; }
        .error { color: red; text-align: center; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Patient Portal Login</h2>
        <% if(request.getParameter("error") != null) { %><div class="error">Invalid Credentials!</div><% } %>
        <form action="PatientLoginServlet" method="post">
            <div class="group"><label>Aadhaar (12 Digits):</label><input type="text" name="aadhaar" required></div>
            <div class="group"><label>Username:</label><input type="text" name="username" required></div>
            <div class="group"><label>Password:</label><input type="password" name="password" required></div>
            <button type="submit">Access My Records</button>
        </form>
    </div>
</body>
</html>