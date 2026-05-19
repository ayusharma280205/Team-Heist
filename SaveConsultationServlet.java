package com.railway;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SaveConsultationServlet")
public class SaveConsultationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientId = request.getParameter("patientId");
        String symptoms = request.getParameter("symptoms");
        String recommendedTests = generateAITestRecommendations(symptoms);
        
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO consultations (patient_id, symptoms, recommended_tests) VALUES (?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, patientId);
            pst.setString(2, symptoms);
            pst.setString(3, recommendedTests);
            
            if (pst.executeUpdate() > 0) {
                response.sendRedirect("consultation.jsp?status=success");
            } else {
                response.sendRedirect("consultation.jsp?status=failed");
            }
            con.close();
        } catch (Exception e) { response.sendRedirect("consultation.jsp?status=error"); }
    }
    
    private String generateAITestRecommendations(String symptoms) {
        String s = symptoms.toLowerCase();
        String tests = "";
        if (s.contains("fever") || s.contains("headache")) tests += "CBC Blood Test, ";
        if (s.contains("cough") || s.contains("chest")) tests += "Chest X-Ray, ";
        if (s.contains("stomach") || s.contains("pain")) tests += "Ultrasound, ";
        
        return tests.isEmpty() ? "General Physical Exam" : tests.substring(0, tests.length() - 2);
    }
}