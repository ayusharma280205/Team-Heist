package com.railway;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM doctors WHERE doctor_id=? AND security_pin=?");
            pst.setString(1, request.getParameter("doctorId"));
            pst.setString(2, request.getParameter("securityPin"));
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                request.getSession().setAttribute("doctorId", rs.getString("doctor_id"));
                response.sendRedirect("consultation.jsp");
            } else {
                response.sendRedirect("index.jsp?error=1");
            }
            con.close();
        } catch (Exception e) { response.sendRedirect("index.jsp?error=server"); }
    }
}