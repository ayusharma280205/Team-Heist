<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard - Smart Healthcare EHR</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background-color: #f4f7f6; 
            padding: 20px; 
            margin: 0; 
        }
        .header { 
            text-align: center; 
            color: #2c3e50; 
            margin-bottom: 10px; 
        }
        .lab-link-container {
            text-align: center;
            margin-bottom: 30px;
        }
        .btn-lab-link {
            background-color: #f39c12;
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: bold;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .btn-lab-link:hover {
            background-color: #d68910;
        }
        .container { 
            display: flex; 
            gap: 20px; 
            max-width: 1200px; 
            margin: 0 auto; 
            align-items: flex-start; 
        }
        .card { 
            background: white; 
            padding: 20px; 
            border-radius: 8px; 
            flex: 1; 
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            min-height: 480px;
        }
        h2 { 
            border-bottom: 2px solid #3498db; 
            padding-bottom: 10px; 
            font-size: 1.2em; 
            color: #2c3e50; 
            margin-top: 0;
        }
        .group { margin-bottom: 15px; } 
        label { font-weight: bold; display: block; margin-bottom: 5px; font-size: 0.9em; }
        input[type="text"], input[type="file"], input[type="date"], input[type="password"], select { 
            width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; 
        }
        button { 
            width: 100%; color: white; border: none; padding: 10px 15px; cursor: pointer; border-radius: 4px; font-weight: bold; font-size: 14px;
        }
        .btn-ai { background-color: #8e44ad; } .btn-ai:hover { background-color: #732d91; }
        .btn-save { background-color: #3498db; } .btn-save:hover { background-color: #2980b9; }
        .btn-register { background-color: #27ae60; } .btn-register:hover { background-color: #219653; }
        .home-link { display: block; text-align: center; margin-top: 30px; text-decoration: none; color: #7f8c8d; font-weight: bold; }
        .alert { padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold; max-width: 1200px; margin-left: auto; margin-right: auto; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

    <h1 class="header">Doctor Master Dashboard</h1>
    
    <div class="lab-link-container">
        <a href="lab_dashboard.jsp" class="btn-lab-link">📂 View Diagnostic Lab Queue</a>
    </div>
    
    <% 
        String status = request.getParameter("status");
        if("success".equals(status)) { 
    %>
        <div class="alert alert-success">Consultation Record Saved Successfully! Tests Generated.</div>
    <%  } else if("failed".equals(status) || "error".equals(status)) { %>
        <div class="alert alert-error">Failed to save consultation. Check database logs.</div>
    <%  } else if("reg_failed".equals(status) || "reg_error".equals(status)) { %>
        <div class="alert alert-error">Failed to register patient profile. Aadhaar or Username might already exist.</div>
    <%  } %>

    <div class="container">
        
        <div class="card" style="border-top: 4px solid #8e44ad;">
            <h2>1. AI Report Analysis</h2>
            <p style="font-size: 0.9em; color: #7f8c8d; margin-bottom: 20px;">Upload a medical document to extract clinical symptoms automatically using NLP.</p>
            <form action="#" method="post" enctype="multipart/form-data">
                <div class="group">
                    <label>Select Clinical File (PDF/TXT):</label>
                    <input type="file" required>
                </div>
                <button type="button" class="btn-ai">Extract Symptoms with AI</button>
            </form>
        </div>

        <div class="card" style="border-top: 4px solid #3498db;">
            <h2>2. Log Consultation</h2>
            <p style="font-size: 0.9em; color: #7f8c8d; margin-bottom: 20px;">Add explicit symptoms manually and generate automated algorithmic test recommendations.</p>
            <form action="SaveConsultationServlet" method="post">
                <div class="group">
                    <label>Patient ID:</label>
                    <input type="text" name="patientId" placeholder="e.g., PT-1045" required>
                </div>
                <div class="group">
                    <label>Observed Symptoms:</label>
                    <input type="text" name="symptoms" placeholder="e.g., High fever, severe cough, joint pain" required>
                </div>
                <button type="submit" class="btn-save">Save & Generate Tests</button>
            </form>
        </div>

        <div class="card" style="border-top: 4px solid #27ae60;">
            <h2>3. Create Lifetime Profile</h2>
            <p style="font-size: 0.9em; color: #7f8c8d; margin-bottom: 20px;">Register a newborn or a new patient into the EHR system permanently.</p>
            
            <% if("reg_success".equals(status)) { %>
                <p style="color: #155724; background-color: #d4edda; padding: 8px; border-radius: 4px; font-weight: bold; font-size: 0.9em;">
                    ✅ Registered! Generated ID: <span style="color: #ff0000;"><%= request.getParameter("newId") %></span>
                </p>
            <% } %>

            <form action="RegisterPatientServlet" method="post">
                <div class="group"><label>Full Name:</label><input type="text" name="fullName" placeholder="Firstname Lastname" required></div>
                <div class="group"><label>Date of Birth:</label><input type="date" name="dob" required></div>
                <div class="group"><label>Gender:</label>
                    <select name="gender" required><option value="Male">Male</option><option value="Female">Female</option><option value="Other">Other</option></select>
                </div>
                <div class="group"><label>Aadhaar UID (12 Digits):</label><input type="text" name="aadhaar" pattern="\d{12}" title="Must be exactly 12 digits" placeholder="000000000000" required></div>
                <div class="group"><label>Set Portal Username:</label><input type="text" name="username" placeholder="e.g., john_doe" required></div>
                <div class="group"><label>Set Portal Password:</label><input type="password" name="password" required></div>
                <button type="submit" class="btn-register">Create Patient Profile</button>
            </form>
        </div>

    </div>

    <a href="index.jsp" class="home-link">← Return to Home Screen</a>

</body>
</html>