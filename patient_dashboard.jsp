<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // SECURITY CHECK: If someone tries to visit this page without logging in, kick them out!
    if(session.getAttribute("aadhaarNo") == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Portal - My Health Timeline</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f0f4f8; margin: 0; padding: 20px; }
        .patient-header { background-color: #2c3e50; color: white; padding: 20px; border-radius: 8px; max-width: 900px; margin: 0 auto 30px auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .patient-header h2 { margin-top: 0; }
        .timeline-container { max-width: 800px; margin: 0 auto; }
        .record-card { background-color: white; border-left: 6px solid #3498db; padding: 20px; margin-bottom: 20px; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .date-badge { background-color: #e8f4f8; color: #2980b9; padding: 6px 12px; border-radius: 20px; font-size: 0.9em; font-weight: bold; display: inline-block; margin-bottom: 15px; }
        h4 { margin: 0 0 10px 0; color: #333; }
        p { margin: 5px 0; color: #555; }
        .logout-btn { float: right; background-color: #e74c3c; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .logout-btn:hover { background-color: #c0392b; }
    </style>
</head>
<body>

    <div class="patient-header">
        <a href="patient_login.jsp" class="logout-btn">Log Out</a>
        
        <h2>Welcome, <%= session.getAttribute("patientName") %></h2>
        <p><strong>Aadhaar No:</strong> <%= session.getAttribute("aadhaarNo") %> &nbsp;&nbsp;|&nbsp;&nbsp; <strong>DOB:</strong> <%= session.getAttribute("dob") %></p>
    </div>

    <h3 style="text-align: center; color: #2c3e50;">Your Lifetime Medical Timeline</h3>

    <div class="timeline-container">
        
        <div class="record-card">
            <div class="date-badge">May 19, 2026</div>
            <h4>Consultation: General Checkup</h4>
            <p><strong>Symptoms Recorded:</strong> Fever, Mild Headache</p>
            <p><strong>Tests Recommended:</strong> CBC Blood Test, COVID-19 Rapid Antigen</p>
            <p><strong>Doctor's Notes:</strong> Patient advised to rest and take prescribed antipyretics.</p>
        </div>

        <div class="record-card" style="border-left-color: #27ae60;">
            <div class="date-badge"><%= session.getAttribute("dob") %></div>
            <h4>Initial Registration & Birth Records</h4>
            <p><strong>Vaccines Administered:</strong> BCG, OPV-0, Hepatitis B-1</p>
            <p><strong>Notes:</strong> Patient registered into Smart EHR system.</p>
        </div>

    </div>

</body>
</html>