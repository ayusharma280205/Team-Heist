package com.railway;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Pointing to the new ai_health_db, using your exact parameters
            String url = "jdbc:mysql://localhost:3306/ai_health_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String user = "root";
            String password = "2002"; // Updated to your password

            con = DriverManager.getConnection(url, user, password);
            System.out.println("AI Health Database connected successfully!");

        } catch (Exception e) {
            System.out.println("AI Health Database connection failed!");
            e.printStackTrace();
        }

        return con;
    }
}