package com.railway;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SaveConsultationServlet")
public class SaveConsultationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String symptoms = request.getParameter("symptoms");
        String tests = generateAIRecommendations(symptoms);
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement("INSERT INTO consultations (patient_id, symptoms, recommended_tests) VALUES (?, ?, ?)");
            pst.setString(1, request.getParameter("patientId"));
            pst.setString(2, symptoms);
            pst.setString(3, tests);
            
            if (pst.executeUpdate() > 0) response.sendRedirect("consultation.jsp?status=success");
            else response.sendRedirect("consultation.jsp?status=failed");
            con.close();
        } catch (Exception e) { response.sendRedirect("consultation.jsp?status=error"); }
    }
    
    private String generateAIRecommendations(String s) {
        s = s.toLowerCase(); String t = "";
        if (s.contains("fever") || s.contains("headache")) t += "CBC Blood Test, ";
        if (s.contains("cough") || s.contains("chest")) t += "Chest X-Ray, ";
        if (s.contains("stomach")) t += "Ultrasound, ";
        return t.isEmpty() ? "General Physical Exam" : t.substring(0, t.length() - 2);
    }
}