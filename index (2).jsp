<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart AI Healthcare - Login</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, sans-serif; 
            background-color: #eef2f5; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        
        /* The Main Split Card */
        .main-card {
            display: flex;
            background: white;
            width: 900px;
            height: 600px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        /* Left Side: Image & Branding */
        .left-panel {
            flex: 1;
            /* Make sure your image is located at src/main/webapp/images/family.jpeg */
            background: linear-gradient(to bottom, rgba(44, 62, 80, 0.4), rgba(44, 62, 80, 0.8)), url('images/family.jpeg') center/cover;
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }
        .left-panel h1 { margin: 0 0 10px 0; font-size: 2.5em; }
        .left-panel p { margin: 0; font-size: 1.1em; opacity: 0.9; }

        /* Right Side: Login Forms */
        .right-panel {
            flex: 1;
            padding: 40px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .security-badge {
            color: #27ae60;
            font-size: 0.85em;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        .right-panel h2 { text-align: center; color: #2c3e50; margin: 0 0 5px 0; }
        .right-panel p.subtitle { text-align: center; color: #7f8c8d; font-size: 0.9em; margin-bottom: 25px; }

        /* The Toggle Switch */
        .toggle-container {
            background-color: #f1f5f9;
            border-radius: 30px;
            display: flex;
            padding: 5px;
            margin-bottom: 30px;
        }
        .toggle-btn {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            color: #64748b;
            transition: all 0.3s ease;
        }
        .toggle-btn.active {
            background-color: white;
            color: #2c3e50;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        /* Form Inputs */
        .form-group { margin-bottom: 15px; }
        label { display: block; font-size: 0.85em; font-weight: bold; color: #334155; margin-bottom: 5px; }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 0.95em;
            transition: border 0.3s;
        }
        input:focus { border-color: #3498db; outline: none; background-color: white; }
        
        .submit-btn {
            width: 100%;
            background-color: #2c3e50;
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
            transition: background 0.3s;
        }
        .submit-btn:hover { background-color: #1a252f; }
        .submit-btn.doctor-btn { background-color: #27ae60; }
        .submit-btn.doctor-btn:hover { background-color: #219653; }
        
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
            <div class="security-badge">
                🔒 HIPAA Compliant & Encrypted
            </div>
            <h2>Welcome Back</h2>
            <p class="subtitle">Access your healthcare portal</p>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-msg">Invalid Credentials! Please try again.</div>
            <% } %>

            <div class="toggle-container">
                <div class="toggle-btn active" id="btn-patient" onclick="switchTab('patient')">Patient</div>
                <div class="toggle-btn" id="btn-doctor" onclick="switchTab('doctor')">Doctor</div>
            </div>

            <form id="form-patient" action="PatientLoginServlet" method="post">
                <div class="form-group">
                    <label>Aadhaar Number</label>
                    <input type="text" name="aadhaar" placeholder="12-digit UID" pattern="\d{12}" required>
                </div>
                <div class="form-group">
                    <label>Portal Username</label>
                    <input type="text" name="username" placeholder="e.g., rahul_s" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="submit-btn">Login as Patient</button>
            </form>

            <form id="form-doctor" action="DoctorLoginServlet" method="post" style="display: none;">
                <div class="form-group">
                    <label>Medical Staff ID</label>
                    <input type="text" name="doctorId" placeholder="e.g., DR-4099" required>
                </div>
                <div class="form-group">
                    <label>Security Pin</label>
                    <input type="password" name="securityPin" placeholder="••••••••" required>
                </div>
                <button type="submit" class="submit-btn doctor-btn">Access Clinical Dashboard</button>
            </form>

        </div>
    </div>

    <script>
        function switchTab(tab) {
            const btnPatient = document.getElementById('btn-patient');
            const btnDoctor = document.getElementById('btn-doctor');
            const formPatient = document.getElementById('form-patient');
            const formDoctor = document.getElementById('form-doctor');

            if(tab === 'patient') {
                btnPatient.classList.add('active');
                btnDoctor.classList.remove('active');
                formPatient.style.display = 'block';
                formDoctor.style.display = 'none';
            } else {
                btnDoctor.classList.add('active');
                btnPatient.classList.remove('active');
                formDoctor.style.display = 'block';
                formPatient.style.display = 'none';
            }
        }
    </script>

</body>
</html>