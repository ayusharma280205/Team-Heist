package com.railway;
import java.io.IOException;
import java.sql.*;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterPatientServlet")
public class RegisterPatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pId = "PT-" + (1000 + new Random().nextInt(9000));
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO patients (patient_id, full_name, age, gender, contact_number, aadhaar_no, username, password, date_of_birth, blood_group) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, pId);
            pst.setString(2, request.getParameter("fullName"));
            pst.setInt(3, Integer.parseInt(request.getParameter("age")));
            pst.setString(4, request.getParameter("gender"));
            pst.setString(5, request.getParameter("contact"));
            pst.setString(6, request.getParameter("aadhaar"));
            pst.setString(7, request.getParameter("username"));
            pst.setString(8, request.getParameter("password"));
            pst.setString(9, request.getParameter("dob"));
            pst.setString(10, request.getParameter("bloodGroup"));
            
            if (pst.executeUpdate() > 0) response.sendRedirect("consultation.jsp?status=reg_success&newId=" + pId);
            else response.sendRedirect("consultation.jsp?status=reg_failed");
            con.close();
        } catch (Exception e) { response.sendRedirect("consultation.jsp?status=reg_error"); }
    }
}