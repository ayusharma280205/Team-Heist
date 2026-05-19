package com.railway;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SymptomCheckerServlet")
public class SymptomCheckerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 🛑 PASTE YOUR API KEY HERE
    private static final String GEMINI_API_KEY = "AIzaSyDC0i28eXr8HCf9wZpknpaN3eJpsIuRgGg";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String input = request.getParameter("userSymptoms");
        String aiResult = "AI Engine Offline. Please try again.";

        try {
            // Using the current 'gemini-3-flash' API model
        	String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=" + GEMINI_API_KEY;
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setDoOutput(true);

            String safeInput = input.replace("\"", "").replace("\n", " ");
            String prompt = "You are an expert AI clinical assistant. Analyze these patient symptoms: " + safeInput + 
                            ". Respond EXACTLY in this format: SUMMARY: [brief clinical analysis] TESTS: [comma separated list of recommended lab tests]. " +
                            "Do not use any quotation marks, markdown, or extra text.";

            String jsonPayload = "{\"contents\": [{\"parts\": [{\"text\": \"" + prompt + "\"}]}]}";

            try(OutputStream os = conn.getOutputStream()) {
                byte[] inputBytes = jsonPayload.getBytes("utf-8");
                os.write(inputBytes, 0, inputBytes.length);
            }

            int code = conn.getResponseCode();
            
            if (code == 200) {
                try(BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder responseBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBuilder.append(responseLine.trim());
                    }

                    String jsonResponse = responseBuilder.toString();
                    String extractedText = "";

                    int textStart = jsonResponse.indexOf("\"text\": \"");
                    if (textStart != -1) {
                        textStart += 9;
                        int textEnd = jsonResponse.indexOf("\"", textStart);
                        extractedText = jsonResponse.substring(textStart, textEnd);
                        
                        extractedText = extractedText.replace("\\n", " ").replace("\\", "").trim();

                        String summary = "Analysis unclear.";
                        String tests = "Consult Physician";

                        if(extractedText.contains("SUMMARY:") && extractedText.contains("TESTS:")) {
                            String[] parts = extractedText.split("TESTS:");
                            summary = parts[0].replace("SUMMARY:", "").trim();
                            tests = parts[1].trim();
                        } else {
                            summary = extractedText;
                        }

                        aiResult = "<strong style='color:#8e44ad;'>✨ Gemini AI Clinical Analysis:</strong><br>" + summary + 
                                   "<br><br><strong style='color:#d97706;'>🧪 Recommended Tests:</strong><br>" + tests;
                    }
                }
            } else {
                StringBuilder errorBuilder = new StringBuilder();
                if (conn.getErrorStream() != null) {
                    try(BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                        String errorLine;
                        while ((errorLine = errorReader.readLine()) != null) {
                            errorBuilder.append(errorLine.trim());
                        }
                    }
                }
                System.out.println("🚨 GEMINI SYMPTOM API ERROR 🚨 Code: " + code + " | " + errorBuilder.toString());
                aiResult = "<span style='color:red;'>Gemini API Error (HTTP " + code + ")<br>Check your Eclipse Console!</span>";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            aiResult = "<span style='color:red;'>Network connection to Google Gemini failed.</span>";
        }

        HttpSession session = request.getSession();
        session.setAttribute("aiResult", aiResult);
        // CRITICAL: Redirects to the Symptom Modal
        response.sendRedirect("patient_dashboard.jsp?showModal=symptom");
    }
}