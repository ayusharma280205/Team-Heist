<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.railway.DBConnection" %>
<%
    if(session.getAttribute("aadhaarNo") == null) { response.sendRedirect("patient_login.jsp"); return; }
    String currentAadhaar = (String) session.getAttribute("aadhaarNo");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Health Timeline</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f0f4f8; margin: 0; padding: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; border-radius: 8px; max-width: 900px; margin: 0 auto 30px auto; }
        .timeline { max-width: 800px; margin: 0 auto; }
        .card { background-color: white; border-left: 6px solid #3498db; padding: 20px; margin-bottom: 20px; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .badge { background-color: #e8f4f8; color: #2980b9; padding: 6px 12px; border-radius: 20px; font-weight: bold; display: inline-block; margin-bottom: 15px; }
        .logout { float: right; background-color: #e74c3c; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="header">
        <a href="patient_login.jsp" class="logout">Log Out</a>
        <h2>Welcome, <%= session.getAttribute("patientName") %></h2>
        <p>Aadhaar: <%= currentAadhaar %> | DOB: <%= session.getAttribute("dob") %></p>
    </div>
    <div class="timeline">
        <%
            try {
                Connection con = DBConnection.getConnection();
                String query = "SELECT c.* FROM consultations c JOIN patients p ON c.patient_id = p.patient_id WHERE p.aadhaar_no = ? ORDER BY c.consultation_date DESC";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, currentAadhaar);
                ResultSet rs = pst.executeQuery();
                while(rs.next()) {
        %>
                    <div class="card">
                        <div class="badge"><%= rs.getTimestamp("consultation_date") %></div>
                        <h4>Consultation Record</h4>
                        <p><strong>Symptoms:</strong> <%= rs.getString("symptoms") %></p>
                        <p><strong>Tests:</strong> <%= rs.getString("recommended_tests") %></p>
                    </div>
        <%      } con.close(); } catch (Exception e) {} %>
        <div class="card" style="border-left-color: #27ae60;">
            <div class="badge"><%= session.getAttribute("dob") %></div>
            <h4>Birth Records</h4><p>Patient registered into Smart EHR.</p>
        </div>
    </div>
</body>
</html>