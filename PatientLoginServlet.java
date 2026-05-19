package com.railway;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PatientLoginServlet")
public class PatientLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String aadhaar = request.getParameter("aadhaar");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT * FROM patients WHERE aadhaar_no = ? AND username = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, aadhaar);
            pst.setString(2, username);
            pst.setString(3, password);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // Login Success!
                HttpSession session = request.getSession();
                session.setAttribute("patientName", rs.getString("full_name"));
                session.setAttribute("aadhaarNo", rs.getString("aadhaar_no"));
                session.setAttribute("dob", rs.getString("date_of_birth"));
                
                response.sendRedirect("patient_dashboard.jsp");
            } else {
                // Login Failed!
                response.sendRedirect("patient_login.jsp?error=1");
            }
            
            con.close(); 
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patient_login.jsp?error=server");
        }
    }
}