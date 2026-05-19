<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.railway.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Diagnostic Laboratory Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .header-panel { background-color: #2c3e50; color: white; padding: 20px; border-radius: 8px; max-width: 1000px; margin: 0 auto 30px auto; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .header-panel h2 { margin: 0; }
        .home-btn { background-color: #34495e; color: white; padding: 10px 15px; text-decoration: none; border-radius: 4px; font-weight: bold; border: 1px solid #7f8c8d; }
        .home-btn:hover { background-color: #1a252f; }
        
        .queue-container { max-width: 1000px; margin: 0 auto; display: flex; flex-direction: column; gap: 20px; }
        
        .test-card { background: white; border-left: 6px solid #f39c12; padding: 20px; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
        .test-info { flex: 2; }
        .test-action { flex: 1; background-color: #f9f9f9; padding: 15px; border-radius: 6px; border: 1px dashed #ccc; text-align: center; }
        
        .badge-pending { background-color: #fdf2e9; color: #e67e22; padding: 5px 10px; border-radius: 20px; font-size: 0.8em; font-weight: bold; text-transform: uppercase; margin-bottom: 10px; display: inline-block; }
        h4 { margin: 0 0 5px 0; color: #2c3e50; font-size: 1.2em; }
        p { margin: 5px 0; color: #555; font-size: 0.95em; }
        
        input[type="file"] { width: 100%; margin-bottom: 10px; font-size: 0.9em; }
        button { background-color: #27ae60; color: white; border: none; padding: 10px; border-radius: 4px; font-weight: bold; cursor: pointer; width: 100%; }
        button:hover { background-color: #219653; }
    </style>
</head>
<body>

    <div class="header-panel">
        <div>
            <h2>Diagnostic Lab - Active Queue</h2>
            <p style="margin: 5px 0 0 0; color: #bdc3c7;">View pending tests ordered by doctors in real-time</p>
        </div>
        <a href="index.jsp" class="home-btn">Return to Home</a>
    </div>

    <div class="queue-container">

        <%
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            boolean recordsFound = false;

            try {
                con = DBConnection.getConnection();
                
                // SQL query to pull all consultations where specific tests were recommended
                String query = "SELECT c.consultation_id, p.full_name, p.patient_id, c.recommended_tests, c.consultation_date " +
                               "FROM consultations c " +
                               "JOIN patients p ON c.patient_id = p.patient_id " +
                               "WHERE c.recommended_tests != 'General Physical Exam' " +
                               "ORDER BY c.consultation_date DESC";
                               
                pst = con.prepareStatement(query);
                rs = pst.executeQuery();

                while (rs.next()) {
                    recordsFound = true;
        %>
                    <div class="test-card">
                        <div class="test-info">
                            <div class="badge-pending">Pending Results</div>
                            <h4>Patient: <%= rs.getString("full_name") %> (<%= rs.getString("patient_id") %>)</h4>
                            <p><strong>Tests Ordered:</strong> <span style="color: #d35400; font-weight: bold;"><%= rs.getString("recommended_tests") %></span></p>
                            <p><strong>Consultation ID:</strong> #<%= rs.getInt("consultation_id") %></p>
                            <p><strong>Date Ordered:</strong> <%= rs.getTimestamp("consultation_date") %></p>
                        </div>
                        
                        <div class="test-action">
                            <p style="font-weight: bold; margin-top: 0; color: #2c3e50;">Upload Lab Report</p>
                            <form action="#" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="consultationId" value="<%= rs.getInt("consultation_id") %>">
                                <input type="file" required accept=".pdf,.txt">
                                <button type="button" style="background-color: #7f8c8d; cursor: not-allowed;">Upload Report</button>
                            </form>
                        </div>
                    </div>
        <%
                }

                if (!recordsFound) {
        %>
                    <div style="text-align: center; padding: 40px; background: white; border-radius: 8px; color: #7f8c8d;">
                        <h3>🎉 Clear Queue!</h3>
                        <p>No pending diagnostic test requests found in the database.</p>
                    </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color: red; text-align: center;'>Error fetching laboratory queue data.</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            }
        %>

    </div>

</body>
</html>