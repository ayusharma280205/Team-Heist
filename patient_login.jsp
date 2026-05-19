<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Portal - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #e8f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #2c3e50; }
        .form-group { margin-bottom: 15px; }
        label { font-weight: bold; display: block; margin-bottom: 5px; color: #333; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background-color: #2980b9; color: white; border: none; padding: 12px; border-radius: 4px; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #1c5980; }
        .error-msg { color: red; text-align: center; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="login-card">
        <h2>Patient Portal Login</h2>
        <p style="text-align:center; color:#7f8c8d; font-size: 14px;">Access your lifetime medical records</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-msg">Invalid Aadhaar, Username, or Password!</div>
        <% } %>
        
        <form action="PatientLoginServlet" method="post">
            <div class="form-group">
                <label for="aadhaar">Aadhaar Number (12 Digits):</label>
                <input type="text" id="aadhaar" name="aadhaar" pattern="\d{12}" title="Please enter exactly 12 digits" required>
            </div>
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Access My Records</button>
        </form>
    </div>

</body>
</html>s