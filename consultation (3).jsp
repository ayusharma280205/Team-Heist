<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.railway.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Portal - Smart EHR</title>
    <style>
        /* Modern UI Reset & Variables */
        :root {
            --primary: #20c997;
            --purple: #6f42c1;
            --dark: #2c3e50;
            --gray: #858796;
            --light-bg: #f8f9fa;
            --card-shadow: 0 4px 15px rgba(0,0,0,0.03);
        }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; background-color: var(--light-bg); display: flex; height: 100vh; overflow: hidden; color: var(--dark); }
        
        /* SIDEBAR */
        .sidebar { width: 250px; background: white; border-right: 1px solid #eaecf4; display: flex; flex-direction: column; padding: 20px 0; }
        .brand { font-size: 1.4em; font-weight: bold; color: var(--dark); padding: 0 20px 20px 20px; border-bottom: 1px solid #eaecf4; display: flex; align-items: center; gap: 10px; }
        .brand-icon { background: var(--primary); color: white; padding: 5px 8px; border-radius: 6px; }
        .nav-section { margin-top: 20px; padding: 0 20px; font-size: 0.75em; font-weight: bold; color: #b7b9cc; text-transform: uppercase; letter-spacing: 1px; }
        .nav-list { list-style: none; padding: 0; margin: 10px 0; }
        .nav-item { padding: 12px 20px; color: var(--gray); font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 12px; transition: 0.2s; }
        .nav-item:hover, .nav-item.active { background: #f1fcf8; color: var(--primary); border-right: 4px solid var(--primary); }
        .logout-box { margin-top: auto; padding: 20px; }
        .btn-logout { width: 100%; padding: 10px; background: #eaecf4; border: none; border-radius: 6px; font-weight: bold; color: var(--gray); cursor: pointer; }
        .btn-logout:hover { background: #e2e4ed; color: var(--dark); }

        /* MAIN CONTENT AREA */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        
        /* HEADER */
        .topbar { background: white; height: 70px; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; border-bottom: 1px solid #eaecf4; }
        .topbar-title { font-weight: 600; font-size: 1.1em; margin: 0; }
        .topbar-date { color: var(--gray); font-size: 0.9em; margin-top: 3px; }
        .hipaa-badge { background: #e6f9f3; color: var(--primary); padding: 6px 12px; border-radius: 20px; font-size: 0.85em; font-weight: bold; border: 1px solid #bdf1e1; }

        /* DASHBOARD VIEWS */
        .page-view { padding: 30px; display: none; }
        .page-view.active { display: block; }
        .welcome-text { font-size: 1.8em; margin: 0 0 5px 0; }
        .subtitle { color: var(--gray); margin-bottom: 30px; }

        /* ACTION CARDS ROW */
        .actions-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .action-card { background: white; padding: 25px; border-radius: 12px; box-shadow: var(--card-shadow); border: 1px solid #eaecf4; display: flex; flex-direction: column; }
        .action-icon { font-size: 1.5em; margin-bottom: 15px; }
        .action-title { font-size: 1.2em; font-weight: bold; margin: 0 0 10px 0; }
        .action-desc { color: var(--gray); font-size: 0.9em; line-height: 1.5; flex: 1; margin-bottom: 20px; }
        .btn-action { margin-top: auto; width: 100%; padding: 12px; border-radius: 8px; font-weight: bold; cursor: pointer; border: none; transition: 0.2s; }
        
        .btn-blue { background: #eef2fe; color: #4e73df; } .btn-blue:hover { background: #4e73df; color: white; }
        .btn-green { background: #e6f9f3; color: var(--primary); } .btn-green:hover { background: var(--primary); color: white; }
        .btn-purple { background: #f3eefe; color: var(--purple); } .btn-purple:hover { background: var(--purple); color: white; }

        /* FORM STYLES */
        .form-container { background: white; padding: 30px; border-radius: 12px; box-shadow: var(--card-shadow); max-width: 750px; margin: 0 auto; border-top: 4px solid var(--primary); }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: 600; font-size: 0.9em; margin-bottom: 5px; color: var(--dark); }
        input, select { width: 100%; padding: 10px; border: 1px solid #d1d3e2; border-radius: 6px; box-sizing: border-box; font-family: inherit; }
        .btn-submit { width: 100%; padding: 12px; background: var(--primary); color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 1em; margin-top: 10px; }
        .btn-submit:hover { background: #17a67d; }
        .back-link { display: inline-block; margin-bottom: 20px; color: var(--primary); cursor: pointer; font-weight: bold; }
        
        .alert { padding: 15px; border-radius: 6px; margin-bottom: 20px; font-weight: bold; text-align: center; }
        .alert-success { background: #d4edda; color: #155724; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="brand"><span class="brand-icon">M</span> MediSense AI</div>
        <div class="nav-section">Main</div>
        <ul class="nav-list">
            <li class="nav-item active" id="nav-dashboard" onclick="switchTab('dashboard')">📊 Dashboard</li>
            <li class="nav-item" id="nav-search-patient" onclick="switchTab('search-patient')">👥 Patient Records</li>
            <li class="nav-item" onclick="window.location.href='lab_dashboard.jsp'">🧪 Lab Queue</li>
        </ul>
        <div class="nav-section">Tools</div>
        <ul class="nav-list">
            <li class="nav-item" id="nav-ai-report" onclick="switchTab('ai-report')">🧠 AI Diagnostics</li>
            <li class="nav-item" id="nav-log-consult" onclick="switchTab('log-consult')">🩺 Log Consultation</li>
            <li class="nav-item" id="nav-register-patient" onclick="switchTab('register-patient')">📝 Register Patient</li>
        </ul>
        <div class="logout-box">
            <button class="btn-logout" onclick="window.location.href='index.jsp'">Log Out</button>
        </div>
    </div>

    <div class="main-content">
        <div class="topbar">
            <div>
                <h2 class="topbar-title">Doctor Dashboard</h2>
                <div class="topbar-date" id="currentDate">Overview — Today</div>
            </div>
            <div class="hipaa-badge">🔒 HIPAA Compliant</div>
        </div>

        <% if(request.getParameter("status") != null) { %>
            <div style="padding: 20px 30px 0 30px;">
                <div class="alert alert-success">Action Completed Successfully! <% if(request.getParameter("newId") != null) { %> New ID: <%= request.getParameter("newId") %> <% } %></div>
            </div>
        <% } %>

        <div id="view-dashboard" class="page-view active">
            <h1 class="welcome-text">Good morning, Doctor 👋</h1>
            <p class="subtitle">Here's your clinical overview and quick-access tools for today.</p>
            
            <div class="actions-grid">
                <div class="action-card">
                    <div class="action-icon">📄</div><h3 class="action-title">AI Report Analysis</h3>
                    <p class="action-desc">Upload and analyze patient lab reports using AI. Get instant summaries and highlighted abnormal values.</p>
                    <button class="btn-action btn-blue" onclick="switchTab('ai-report')">Open Report Analyzer →</button>
                </div>
                <div class="action-card">
                    <div class="action-icon">🩺</div><h3 class="action-title">Patient Consultation</h3>
                    <p class="action-desc">Log patient symptoms manually and generate automated algorithmic diagnostic test recommendations.</p>
                    <button class="btn-action btn-green" onclick="switchTab('log-consult')">Open Consultation →</button>
                </div>
                <div class="action-card">
                    <div class="action-icon">👥</div><h3 class="action-title">Patient Management</h3>
                    <p class="action-desc">Create lifetime EHR profiles for new patients. Register demographics to grant patient portal access.</p>
                    <button class="btn-action btn-purple" onclick="switchTab('register-patient')">Register New Patient →</button>
                </div>
            </div>
        </div>

        <div id="view-search-patient" class="page-view">
            <span class="back-link" onclick="switchTab('dashboard')">← Back to Dashboard</span>
            <div class="form-container" style="border-top-color: #f39c12;">
                <h2>Access Patient Records</h2>
                <p style="color:var(--gray); margin-bottom:20px;">Enter patient details to verify identity and update specific test requirements.</p>
                
                <form action="consultation.jsp" method="get">
                    <input type="hidden" name="activeTab" value="search-patient">
                    
                    <div class="form-group">
                        <label>Patient Aadhaar Number:</label>
                        <input type="text" name="searchAadhaar" pattern="\d{12}" value="<%= request.getParameter("searchAadhaar") != null ? request.getParameter("searchAadhaar") : "" %>" placeholder="12-digit UID" required>
                    </div>
                    <div class="form-group">
                        <label>Patient User ID / EHR ID:</label>
                        <input type="text" name="searchPatientId" value="<%= request.getParameter("searchPatientId") != null ? request.getParameter("searchPatientId") : "" %>" placeholder="e.g., PT-1045 or Username" required>
                    </div>
                    <button type="submit" class="btn-submit" style="background:#f39c12;">Fetch Medical History</button>
                </form>

                <%
                    String sAadhaar = request.getParameter("searchAadhaar");
                    String sId = request.getParameter("searchPatientId");
                    
                    if(sAadhaar != null && sId != null) {
                        Connection con = null;
                        PreparedStatement pst = null;
                        ResultSet rs = null;
                        try {
                            con = DBConnection.getConnection();
                            String query = "SELECT * FROM patients WHERE aadhaar_no = ? AND (patient_id = ? OR username = ?)";
                            pst = con.prepareStatement(query);
                            pst.setString(1, sAadhaar);
                            pst.setString(2, sId);
                            pst.setString(3, sId);
                            rs = pst.executeQuery();
                            
                            if(rs.next()) {
                                String pRealId = rs.getString("patient_id");
                                String pAge = rs.getString("age") != null ? rs.getString("age") : "N/A";
                                String pBlood = rs.getString("blood_group") != null ? rs.getString("blood_group") : "Unknown";
                %>
                                <div style="margin-top: 30px; padding-top: 20px; border-top: 2px dashed #eaecf4;">
                                    <h3 style="color: var(--dark); margin-bottom: 15px;">📋 Patient Demographics</h3>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 25px; font-size: 0.95em;">
                                        <div><strong>Full Name:</strong> <%= rs.getString("full_name") %></div>
                                        <div><strong>EHR System ID:</strong> <%= pRealId %></div>
                                        <div><strong>Age / Gender:</strong> <%= pAge %> Yrs / <%= rs.getString("gender") %></div>
                                        <div><strong>Blood Group:</strong> <span style="color: #e74c3c; font-weight: bold;"><%= pBlood %></span></div>
                                    </div>

                                    <h3 style="color: var(--dark); margin-bottom: 15px;">📜 Clinical History Log</h3>
                                    <div style="border-left: 3px solid #cbd5e1; padding-left: 20px; margin-left: 10px;">
                                    <%
                                        PreparedStatement pstH = con.prepareStatement("SELECT * FROM consultations WHERE patient_id = ? ORDER BY consultation_date DESC");
                                        pstH.setString(1, pRealId);
                                        ResultSet rsH = pstH.executeQuery();
                                        boolean hasHistory = false;
                                        
                                        while(rsH.next()) {
                                            hasHistory = true;
                                    %>
                                            <div style="background: white; border: 1px solid #eaecf4; padding: 15px; border-radius: 8px; margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.01);">
                                                <span style="font-size: 0.8em; color: #4e73df; font-weight: bold; background: #eef2fe; padding: 3px 8px; border-radius: 10px;"><%= rsH.getTimestamp("consultation_date") %></span>
                                                <p style="margin: 10px 0 5px 0; font-size: 0.95em;"><strong>Observed Symptoms:</strong> <%= rsH.getString("symptoms") %></p>
                                                <p style="margin: 0; font-size: 0.95em;"><strong>Prescribed Diagnostic Routine:</strong> <span style="color: #d97706; font-weight: bold;"><%= rsH.getString("recommended_tests") %></span></p>
                                            </div>
                                    <%
                                        }
                                        if(!hasHistory) {
                                    %>
                                            <p style="color: var(--gray); font-style: italic; font-size: 0.95em;">No recorded consultation entries found matching this medical profile.</p>
                                    <%
                                        }
                                        rsH.close(); pstH.close();
                                    %>
                                    </div>
                                </div>
                <%
                            } else {
                %>
                                <div style="margin-top: 25px; color: #e74c3c; font-weight: bold; text-align: center; font-size: 0.95em;">
                                    ❌ Verification Failed: No patient profile matches the provided credentials.
                                </div>
                <%
                            }
                        } catch(Exception e) { e.printStackTrace(); } 
                        finally {
                            if(rs != null) rs.close(); if(pst != null) pst.close(); if(con != null) con.close();
                        }
                    }
                %>
            </div>
        </div>

        <div id="view-ai-report" class="page-view">
            <span class="back-link" onclick="switchTab('dashboard')">← Back to Dashboard</span>
            <div class="form-container" style="border-top-color: #4e73df;">
                <h2>AI Report Diagnostics</h2>
                <form action="#" method="post" enctype="multipart/form-data">
                    <div class="form-group"><label>Select Clinical File (PDF/TXT):</label><input type="file" required></div>
                    <button type="button" class="btn-submit" style="background:#4e73df;">Extract Symptoms with AI</button>
                </form>
            </div>
        </div>

        <div id="view-log-consult" class="page-view">
            <span class="back-link" onclick="switchTab('dashboard')">← Back to Dashboard</span>
            <div class="form-container" style="border-top-color: var(--primary);">
                <h2>Manual Consultation Entry</h2>
                <form action="SaveConsultationServlet" method="post">
                    <div class="form-group"><label>Patient ID:</label><input type="text" name="patientId" placeholder="e.g., PT-1045" required></div>
                    <div class="form-group"><label>Observed Symptoms:</label><input type="text" name="symptoms" placeholder="e.g., High fever, severe cough" required></div>
                    <button type="submit" class="btn-submit">Save & Generate Lab Tests</button>
                </form>
            </div>
        </div>

        <div id="view-register-patient" class="page-view">
            <span class="back-link" onclick="switchTab('dashboard')">← Back to Dashboard</span>
            <div class="form-container" style="border-top-color: var(--purple);">
                <h2>Create Lifetime EHR Profile</h2>
                <form action="RegisterPatientServlet" method="post">
                    <div class="form-group"><label>Full Name:</label><input type="text" name="fullName" required></div>
                    <div style="display:flex; gap:15px;">
                        <div class="form-group" style="flex:1;"><label>Age:</label><input type="number" name="age" required></div>
                        <div class="form-group" style="flex:2;"><label>Mobile No:</label><input type="text" name="contact" required></div>
                    </div>
                    <div class="form-group"><label>Date of Birth:</label><input type="date" name="dob" required></div>
                    <div style="display:flex; gap:15px;">
                        <div class="form-group" style="flex:1;"><label>Gender:</label><select name="gender"><option>Male</option><option>Female</option></select></div>
                        <div class="form-group" style="flex:1;"><label>Blood Group:</label><select name="bloodGroup"><option>A+</option><option>B+</option><option>O+</option><option>O-</option><option>AB+</option></select></div>
                    </div>
                    <div class="form-group"><label>Aadhaar UID:</label><input type="text" name="aadhaar" pattern="\d{12}" required></div>
                    <div class="form-group"><label>Portal Username:</label><input type="text" name="username" required></div>
                    <div class="form-group"><label>Portal Password:</label><input type="password" name="password" required></div>
                    <button type="submit" class="btn-submit" style="background:var(--purple);">Create Patient Profile</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' };
        document.getElementById('currentDate').innerText = "Overview — " + new Date().toLocaleDateString('en-US', options);

        function switchTab(tabId) {
            document.querySelectorAll('.page-view').forEach(page => page.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
            
            document.getElementById('view-' + tabId).classList.add('active');
            const activeNav = document.getElementById('nav-' + tabId);
            if(activeNav) activeNav.classList.add('active');
        }

        // State controller preservation rule on browser form reload execution loops
        <% if("search-patient".equals(request.getParameter("activeTab"))) { %>
            switchTab('search-patient');
        <% } %>
    </script>
</body>
</html>