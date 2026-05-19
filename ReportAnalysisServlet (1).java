package com.railway;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/ReportAnalysisServlet")
@MultipartConfig(maxFileSize = 10485760) // Allows file uploads up to 10MB
public class ReportAnalysisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 🛑 PASTE YOUR API KEY HERE
    private static final String GEMINI_API_KEY = "AIzaSyDC0i28eXr8HCf9wZpknpaN3eJpsIuRgGg";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String aiResult = "AI Engine Offline. Please try again.";

        try {
            Part filePart = request.getPart("reportFile");
            if (filePart == null || filePart.getSize() == 0) {
                throw new Exception("No file was uploaded.");
            }

            String mimeType = filePart.getContentType(); 
            InputStream fileContent = filePart.getInputStream();
            byte[] fileBytes = fileContent.readAllBytes();
            String base64File = Base64.getEncoder().encodeToString(fileBytes);

            // Using the current 'gemini-3-flash' API model for Vision tasks
            String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=" + GEMINI_API_KEY;
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setDoOutput(true);

            String prompt = "You are an expert medical AI. Analyze this clinical laboratory report. Respond EXACTLY in this format: SUMMARY: [brief summary of the report] ABNORMALITIES: [comma separated list of any abnormal values. If none, write 'None detected']. Do not use markdown or extra text.";

            String jsonPayload = "{\"contents\": [{\"parts\": [" +
                                 "{\"text\": \"" + prompt + "\"}," +
                                 "{\"inlineData\": {\"mimeType\": \"" + mimeType + "\", \"data\": \"" + base64File + "\"}}" +
                                 "]}]}";

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
                        String abnormalities = "Requires Manual Review";

                        if(extractedText.contains("SUMMARY:") && extractedText.contains("ABNORMALITIES:")) {
                            String[] parts = extractedText.split("ABNORMALITIES:");
                            summary = parts[0].replace("SUMMARY:", "").trim();
                            abnormalities = parts[1].trim();
                        } else {
                            summary = extractedText;
                        }

                        aiResult = "<strong style='color:#20c997;'>📄 AI Report Scan Complete:</strong><br>" + summary + 
                                   "<br><br><strong style='color:#e74c3c;'>⚠️ Abnormal Findings:</strong><br>" + abnormalities;
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
                System.out.println("🚨 GEMINI VISION API ERROR 🚨 Code: " + code + " | " + errorBuilder.toString());
                aiResult = "<span style='color:red;'>Gemini API Error (HTTP " + code + ")<br>Ensure file is a valid PDF, JPG, or PNG. Check Console.</span>";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            aiResult = "<span style='color:red;'>Error processing file: " + e.getMessage() + "</span>";
        }

        HttpSession session = request.getSession();
        session.setAttribute("aiResult", aiResult);
        // CRITICAL: Redirects to the Report Modal
        response.sendRedirect("patient_dashboard.jsp?showModal=report");
    }
}