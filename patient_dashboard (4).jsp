<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.railway.DBConnection" %>

<%
    // SECURITY CHECK: Kick out unauthenticated users
    if(session.getAttribute("aadhaarNo") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String currentAadhaar = (String) session.getAttribute("aadhaarNo");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Health Timeline - Patient Portal</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #eef2f5; margin: 0; padding: 20px; color: #334155; }
        .top-nav { background-color: #2c3e50; color: white; padding: 15px 30px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .logout-btn { background-color: #e74c3c; color: white; padding: 10px 20px; text-decoration: none; border-radius: 6px; font-weight: bold; }
        .dashboard-container { display: flex; gap: 20px; max-width: 1400px; margin: 0 auto; align-items: flex-start; }
        
        /* Profile Sidebar */
        .profile-card { background: white; width: 320px; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .avatar-circle { width: 100px; height: 100px; background-color: #3498db; color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 2.5em; font-weight: bold; margin: 0 auto 15px auto; }
        .info-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-size: 0.95em; }
        
        /* Timeline Section */
        .timeline-section { flex: 1; background: white; border-radius: 12px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .timeline { border-left: 3px solid #cbd5e1; padding-left: 20px; margin-left: 10px; }
        .record-card { background-color: #f8fafc; border: 1px solid #e2e8f0; padding: 20px; margin-bottom: 25px; border-radius: 8px; position: relative; }
        .record-card::before { content: ''; position: absolute; width: 15px; height: 15px; background-color: #3498db; border-radius: 50%; left: -29px; top: 20px; border: 3px solid white; }
        .date-badge { background-color: #e0f2fe; color: #0284c7; padding: 6px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; display: inline-block; margin-bottom: 15px; }
        
        /* Modals */
        .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index: 1000; }
        .modal-content { background:white; padding:30px; border-radius:12px; width:450px; }
    </style>
</head>
<body>

    <div class="top-nav">
        <h2>Medisence AI</h2>
        <a href="index.jsp" class="logout-btn">Secure Log Out</a>
    </div>

    <div class="dashboard-container">
        <%
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM patients WHERE aadhaar_no = ?");
            ps.setString(1, currentAadhaar);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                String age = (rs.getString("age") == null) ? "N/A" : rs.getString("age");
                String mobile = (rs.getString("contact_number") == null) ? "Not Provided" : rs.getString("contact_number");
                String blood = (rs.getString("blood_group") == null) ? "Unknown" : rs.getString("blood_group");
                String pId = rs.getString("patient_id");
        %>
        <div class="profile-card">
            <div class="avatar-circle"><%= rs.getString("full_name").substring(0,1).toUpperCase() %></div>
            <h3 style="text-align:center; margin:0;"><%= rs.getString("full_name") %></h3>
            <div style="text-align:center; color:#64748b; margin-bottom:20px;">ID: <%= pId %></div>
            <div class="info-row"><strong>Aadhaar</strong><span><%= currentAadhaar %></span></div>
            <div class="info-row"><strong>DOB</strong><span><%= rs.getString("date_of_birth") %></span></div>
            <div class="info-row"><strong>Age</strong><span><%= age %> Yrs</span></div>
            <div class="info-row"><strong>Gender</strong><span><%= rs.getString("gender") %></span></div>
            <div class="info-row"><strong>Mobile</strong><span><%= mobile %></span></div>
            <div class="info-row"><strong>Blood Group</strong><span style="color:red;"><%= blood %></span></div>
            
            <button onclick="openModal('symptomModal')" style="width:100%; margin-top:20px; padding:12px; background:#3498db; color:white; border:none; border-radius:8px; cursor:pointer; font-weight:bold;">Symptom Checker</button>
            <button onclick="openModal('reportModal')" style="width:100%; margin-top:10px; padding:12px; background:#8e44ad; color:white; border:none; border-radius:8px; cursor:pointer; font-weight:bold;">Report Analysis</button>
        </div>

        <div class="timeline-section">
            <h2 style="border-bottom: 2px solid #e2e8f0; padding-bottom: 10px;">Lifetime Medical History</h2>
            <div class="timeline">
                <%
                    PreparedStatement psH = con.prepareStatement("SELECT * FROM consultations WHERE patient_id = ? ORDER BY consultation_date DESC");
                    psH.setString(1, pId);
                    ResultSet rsH = psH.executeQuery();
                    while(rsH.next()) {
                %>
                <div class="record-card">
                    <div class="date-badge"><%= rsH.getTimestamp("consultation_date") %></div>
                    <h4>Clinical Consultation</h4>
                    <p><strong>Symptoms:</strong> <%= rsH.getString("symptoms") %></p>
                    <p><strong>Tests:</strong> <span style="color: #d97706; font-weight:bold;"><%= rsH.getString("recommended_tests") %></span></p>
                </div>
                <% } %>
            </div>
        </div>
        <% con.close(); } %>
    </div>

    <div id="symptomModal" class="modal-overlay">
        <div class="modal-content">
            <h3>AI Symptom Checker</h3>
            
            <% if("symptom".equals(request.getParameter("showModal")) && session.getAttribute("aiResult") != null) { %>
                <div style="background:#f1f5f9; padding:15px; margin-bottom:15px; border-radius:8px; border-left:4px solid #3498db; font-size:0.9em; line-height: 1.5;">
                    <%= session.getAttribute("aiResult") %>
                </div>
                <% session.removeAttribute("aiResult"); %>
            <% } %>

            <form action="SymptomCheckerServlet" method="post">
                <textarea name="userSymptoms" style="width:100%; height:80px; padding:10px; box-sizing:border-box; border-radius:6px; border:1px solid #cbd5e1;" placeholder="Enter symptoms..." required></textarea>
                <button type="submit" style="width:100%; margin-top:10px; padding:10px; background:#27ae60; color:white; font-weight:bold; border:none; border-radius:6px; cursor:pointer;">Check Results</button>
            </form>
            <button onclick="closeModal('symptomModal')" style="width:100%; margin-top:10px; background:none; border:none; color:#7f8c8d; cursor:pointer; font-weight:bold;">Close</button>
        </div>
    </div>

    <div id="reportModal" class="modal-overlay">
        <div class="modal-content">
            <h3>AI Report Analysis</h3>
            
            <% if("report".equals(request.getParameter("showModal")) && session.getAttribute("aiResult") != null) { %>
                <div style="background:#f1fcf8; padding:15px; margin-bottom:15px; border-radius:8px; border-left:4px solid #20c997; font-size:0.9em; line-height: 1.5;">
                    <%= session.getAttribute("aiResult") %>
                </div>
                <% session.removeAttribute("aiResult"); %>
            <% } %>

            <form action="ReportAnalysisServlet" method="post" enctype="multipart/form-data">
                <label style="font-size:0.9em; font-weight:bold;">Upload Lab Report (PDF, PNG, JPG):</label>
                <input type="file" name="reportFile" accept=".pdf, .jpg, .png" style="width:100%; margin:10px 0; padding:10px; box-sizing:border-box; border:1px solid #cbd5e1; border-radius:6px;" required>
                <button type="submit" style="width:100%; padding:10px; background:#8e44ad; color:white; font-weight:bold; border:none; border-radius:6px; cursor:pointer;">Analyze Report</button>
            </form>
            <button onclick="closeModal('reportModal')" style="width:100%; margin-top:10px; background:none; border:none; color:#7f8c8d; cursor:pointer; font-weight:bold;">Close</button>
        </div>
    </div>

    <script>
        function openModal(id) { document.getElementById(id).style.display = 'flex'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        
        // Smart URL parameter checking to keep the correct modal open after the page reloads
        const urlParams = new URLSearchParams(window.location.search);
        const modalType = urlParams.get('showModal');
        
        if(modalType === 'symptom') {
            openModal('symptomModal');
        } else if(modalType === 'report') {
            openModal('reportModal');
        }
    </script>
</body>
</html>