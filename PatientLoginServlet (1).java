package com.railway;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PatientLoginServlet")
public class PatientLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM patients WHERE aadhaar_no=? AND username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, request.getParameter("aadhaar"));
            pst.setString(2, request.getParameter("username"));
            pst.setString(3, request.getParameter("password"));
            
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("patientName", rs.getString("full_name"));
                session.setAttribute("aadhaarNo", rs.getString("aadhaar_no"));
                session.setAttribute("dob", rs.getString("date_of_birth"));
                response.sendRedirect("patient_dashboard.jsp");
            } else {
                response.sendRedirect("patient_login.jsp?error=1");
            }
            con.close();
        } catch (Exception e) { response.sendRedirect("patient_login.jsp?error=server"); }
    }
}