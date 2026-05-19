package com.railway;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterPatientServlet")
public class RegisterPatientServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get form data submitted by the Doctor
        String fullName = request.getParameter("fullName");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String aadhaar = request.getParameter("aadhaar");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 2. Automatically generate a unique Patient ID (e.g., PT-4829)
        Random rand = new Random();
        String patientId = "PT-" + (1000 + rand.nextInt(9000));
        
        try {
            Connection con = DBConnection.getConnection();
            
            // 3. Insert into the MySQL patients table
            String query = "INSERT INTO patients (patient_id, full_name, gender, aadhaar_no, username, password, date_of_birth) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, patientId);
            pst.setString(2, fullName);
            pst.setString(3, gender);
            pst.setString(4, aadhaar);
            pst.setString(5, username);
            pst.setString(6, password);
            pst.setString(7, dob);
            
            int result = pst.executeUpdate();
            con.close();
            
            if (result > 0) {
                // Success: Send back to dashboard with the generated Patient ID so the doctor can copy it
                response.sendRedirect("consultation.jsp?status=reg_success&newId=" + patientId);
            } else {
                response.sendRedirect("consultation.jsp?status=reg_failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("consultation.jsp?status=reg_error");
        }
    }
}