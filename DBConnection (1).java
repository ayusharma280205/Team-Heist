package com.railway;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/ai_health_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String user = "root";
            String password = "2002"; // Your exact password
            con = DriverManager.getConnection(url, user, password);
        } catch (Exception e) { e.printStackTrace(); }
        return con;
    }
}