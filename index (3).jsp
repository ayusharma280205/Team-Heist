<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart AI Healthcare - Login</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #eef2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .main-card { display: flex; background: white; width: 900px; height: 600px; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); overflow: hidden; }
        .left-panel { flex: 1; background: linear-gradient(to bottom, rgba(44, 62, 80, 0.4), rgba(44, 62, 80, 0.8)), url('images/family.jpeg') center/cover; color: white; padding: 40px; display: flex; flex-direction: column; justify-content: flex-end; }
        .left-panel h1 { margin: 0 0 10px 0; font-size: 2.5em; }
        .left-panel p { margin: 0; font-size: 1.1em; opacity: 0.9; }
        .right-panel { flex: 1; padding: 40px 50px; display: flex; flex-direction: column; justify-content: center; }
        .security-badge { color: #27ae60; font-size: 0.85em; font-weight: bold; text-align: center; margin-bottom: 20px; }
        .right-panel h2 { text-align: center; color: #2c3e50; margin: 0 0 5px 0; }
        .right-panel p.subtitle { text-align: center; color: #7f8c8d; font-size: 0.9em; margin-bottom: 25px; }
        .toggle-container { background-color: #f1f5f9; border-radius: 30px; display: flex; padding: 5px; margin-bottom: 30px; }
        .toggle-btn { flex: 1; text-align: center; padding: 10px; border-radius: 25px; cursor: pointer; font-weight: bold; color: #64748b; transition: all 0.3s ease; }
        .toggle-btn.active { background-color: white; color: #2c3e50; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-size: 0.85em; font-weight: bold; color: #334155; margin-bottom: 5px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 12px; background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; box-sizing: border-box; }
        .submit-btn { width: 100%; background-color: #2c3e50; color: white; border: none; padding: 14px; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .submit-btn.doctor-btn { background-color: #27ae60; }
        .error-msg { color: #e74c3c; text-align: center; font-size: 0.9em; font-weight: bold; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="main-card">
        <div class="left-panel">
            <h1>Smart AI Healthcare</h1>
            <p>Your lifetime medical records, securely stored and powered by AI diagnostics.</p>
        </div>
        <div class="right-panel">
            <div class="security-badge">🔒 HIPAA Compliant & Encrypted</div>
            <h2>Welcome Back</h2><p class="subtitle">Access your healthcare portal</p>
            <% if(request.getParameter("error") != null) { %><div class="error-msg">Invalid Credentials!</div><% } %>
            
            <div class="toggle-container">
                <div class="toggle-btn active" id="btn-patient" onclick="switchTab('patient')">Patient</div>
                <div class="toggle-btn" id="btn-doctor" onclick="switchTab('doctor')">Doctor</div>
            </div>

            <form id="form-patient" action="PatientLoginServlet" method="post">
                <div class="form-group"><label>Aadhaar Number</label><input type="text" name="aadhaar" pattern="\d{12}" required></div>
                <div class="form-group"><label>Portal Username</label><input type="text" name="username" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" required></div>
                <button type="submit" class="submit-btn">Login as Patient</button>
            </form>

            <form id="form-doctor" action="DoctorLoginServlet" method="post" style="display: none;">
                <div class="form-group"><label>Medical Staff ID</label><input type="text" name="doctorId" required></div>
                <div class="form-group"><label>Security Pin</label><input type="password" name="securityPin" required></div>
                <button type="submit" class="submit-btn doctor-btn">Access Clinical Dashboard</button>
            </form>
        </div>
    </div>
    <script>
        function switchTab(tab) {
            document.getElementById('btn-patient').classList.toggle('active', tab === 'patient');
            document.getElementById('btn-doctor').classList.toggle('active', tab === 'doctor');
            document.getElementById('form-patient').style.display = tab === 'patient' ? 'block' : 'none';
            document.getElementById('form-doctor').style.display = tab === 'doctor' ? 'block' : 'none';
        }
    </script>
</body>
</html>