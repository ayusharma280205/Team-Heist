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
            PreparedStatement pst = con.prepareStatement("SELECT * FROM patients WHERE aadhaar_no=? AND username=? AND password=?");
            pst.setString(1, request.getParameter("aadhaar"));
            pst.setString(2, request.getParameter("username"));
            pst.setString(3, request.getParameter("password"));
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                request.getSession().setAttribute("aadhaarNo", rs.getString("aadhaar_no"));
                response.sendRedirect("patient_dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp?error=1");
            }
            con.close();
        } catch (Exception e) { response.sendRedirect("index.jsp?error=server"); }
    }
}