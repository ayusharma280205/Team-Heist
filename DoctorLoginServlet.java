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

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Grab what the doctor typed into the login form
        String doctorId = request.getParameter("doctorId");
        String securityPin = request.getParameter("securityPin");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // 2. Check the database for a match
            String query = "SELECT * FROM doctors WHERE doctor_id=? AND security_pin=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, doctorId);
            pst.setString(2, securityPin);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // SUCCESS! The credentials match.
                // Save the doctor's info in the session so they stay logged in
                HttpSession session = request.getSession();
                session.setAttribute("doctorId", rs.getString("doctor_id"));
                session.setAttribute("doctorName", rs.getString("full_name"));
                
                // Send them to the dashboard
                response.sendRedirect("consultation.jsp");
            } else {
                // FAILED! Wrong ID or Pin. Send them back to the login page with an error.
                response.sendRedirect("index.jsp?error=1");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=server");
        }
    }
}