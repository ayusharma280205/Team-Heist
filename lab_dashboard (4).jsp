<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.railway.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Diagnostic Laboratory Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .header-panel { background-color: #2c3e50; color: white; padding: 20px; border-radius: 8px; max-width: 1000px; margin: 0 auto 30px auto; display: flex; justify-content: space-between; align-items: center; }
        .home-btn { background-color: #34495e; color: white; padding: 10px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; }
        .queue-container { max-width: 1000px; margin: 0 auto; display: flex; flex-direction: column; gap: 20px; }
        .test-card { background: white; border-left: 6px solid #f39c12; padding: 20px; border-radius: 6px; display: flex; justify-content: space-between; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .test-info { flex: 2; } .test-action { flex: 1; background-color: #f9f9f9; padding: 15px; border-radius: 6px; text-align: center; }
        .badge-pending { background-color: #fdf2e9; color: #e67e22; padding: 5px 10px; border-radius: 20px; font-size: 0.8em; font-weight: bold; margin-bottom: 10px; display: inline-block; }
    </style>
</head>
<body>
    <div class="header-panel">
        <div><h2>Diagnostic Lab - Active Queue</h2><p style="margin:0;">Pending tests ordered by doctors</p></div>
        <a href="consultation.jsp" class="home-btn">Back to Dashboard</a>
    </div>
    <div class="queue-container">
        <%
            try {
                Connection con = DBConnection.getConnection();
                String query = "SELECT c.consultation_id, p.full_name, p.patient_id, c.recommended_tests, c.consultation_date FROM consultations c JOIN patients p ON c.patient_id = p.patient_id WHERE c.recommended_tests != 'General Physical Exam' ORDER BY c.consultation_date DESC";
                PreparedStatement pst = con.prepareStatement(query);
                ResultSet rs = pst.executeQuery();
                while (rs.next()) {
        %>
            <div class="test-card">
                <div class="test-info">
                    <div class="badge-pending">Pending Results</div>
                    <h4><%= rs.getString("full_name") %> (<%= rs.getString("patient_id") %>)</h4>
                    <p><strong>Tests Ordered:</strong> <span style="color: #d35400;"><%= rs.getString("recommended_tests") %></span></p>
                </div>
                <div class="test-action">
                    <p>Upload Report</p>
                    <input type="file" required>
                    <button style="background:#7f8c8d; color:white; padding:8px; border:none; width:100%;">Upload</button>
                </div>
            </div>
        <% } con.close(); } catch(Exception e) {} %>
    </div>
</body>
</html>