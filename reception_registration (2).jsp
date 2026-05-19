<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reception - Registration</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; display: flex; justify-content: center; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 600px; }
        h2 { text-align: center; color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 20px; }
        .row { display: flex; gap: 15px; margin-bottom: 15px; }
        .group { flex: 1; }
        label { font-weight: bold; display: block; margin-bottom: 5px; color: #333; font-size: 14px; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; background-color: #27ae60; color: white; border: none; padding: 12px; border-radius: 4px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .link { display: block; text-align: center; margin-top: 15px; color: #7f8c8d; text-decoration: none; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Register New Patient</h2>
        <form action="#" method="post">
            <div class="group" style="margin-bottom: 15px;"><label>Full Name:</label><input type="text" required></div>
            <div class="row">
                <div class="group"><label>Date of Birth:</label><input type="date" required></div>
                <div class="group"><label>Gender:</label><select required><option>Male</option><option>Female</option></select></div>
            </div>
            <div class="row">
                <div class="group"><label>Contact:</label><input type="text" required></div>
                <div class="group"><label>Aadhaar:</label><input type="text" required></div>
            </div>
            <h4>Generate Login</h4>
            <div class="row">
                <div class="group"><label>Username:</label><input type="text" required></div>
                <div class="group"><label>Password:</label><input type="password" required></div>
            </div>
            <button type="submit">Complete Registration</button>
            <a href="index.jsp" class="link">Return to Home</a>
        </form>
    </div>
</body>
</html>