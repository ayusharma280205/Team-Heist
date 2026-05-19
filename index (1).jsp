<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Smart Healthcare EHR - Home</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #f4f7f6; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            margin: 0; 
        }
        .hero-section { 
            text-align: center; 
            margin-bottom: 40px; 
        }
        .hero-section h1 { 
            color: #2c3e50; 
            font-size: 3em; 
            margin-bottom: 10px; 
        }
        .hero-section p { 
            color: #7f8c8d; 
            font-size: 1.2em; 
        }
        .button-container { 
            display: flex; 
            gap: 20px; 
            flex-wrap: wrap; 
            justify-content: center; 
            max-width: 900px;
        }
        .nav-btn { 
            padding: 15px 30px; 
            font-size: 18px; 
            text-decoration: none; 
            border-radius: 8px; 
            color: white; 
            font-weight: bold; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
            transition: 0.3s; 
            text-align: center; 
        }
        
        /* Button Colors and Hover Effects */
        .btn-doctor { background-color: #27ae60; }
        .btn-doctor:hover { background-color: #219653; }
        
        .btn-lab { background-color: #f39c12; }
        .btn-lab:hover { background-color: #d68910; }
        
        .btn-patient { background-color: #2980b9; }
        .btn-patient:hover { background-color: #1c5980; }
    </style>
</head>
<body>

    <div class="hero-section">
        <h1>Smart Healthcare EHR</h1>
        <p>AI-Powered Diagnostics & Lifetime Medical Records</p>
    </div>

    <div class="button-container">
        <a href="consultation.jsp" class="nav-btn btn-doctor">Doctor Dashboard (Consult & Register)</a>
        <a href="lab_dashboard.jsp" class="nav-btn btn-lab">Diagnostic Lab Queue</a>
        <a href="patient_login.jsp" class="nav-btn btn-patient">Patient Portal Login</a>
    </div>

</body>
</html>