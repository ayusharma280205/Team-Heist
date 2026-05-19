# Team-Heist
AI-driven healthcare platform that predicts diseases from symptoms, analyzes medical reports, maintains lifelong patient health records from birth, and provides smart triage support for faster and more accurate medical decision-making.

# 🏥 AI Healthcare Diagnostics System

AI-powered healthcare diagnostic web application that analyzes patient symptoms and generates smart medical recommendations using Google Gemini AI.

---

## 🚀 Features

- 🤖 AI Symptom Analysis
- 🩺 Medical Test Recommendations
- 💾 Consultation Data Storage
- 📊 Clinical Summary Generation
- 🔒 Secure Java Servlet Backend
- 🗄️ MySQL Database Integration

---

## 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| Java Servlets | Backend |
| JSP | Frontend |
| MySQL | Database |
| Apache Tomcat | Server |
| Gemini AI API | AI Analysis |
| Eclipse IDE | Development |

---

## 📂 Project Structure

```bash
src/
 ├── SymptomCheckerServlet.java
 ├── SaveConsultationServlet.java
 └── DBConnection.java

WebContent/
 ├── patient_dashboard.jsp
 ├── consultation.jsp
 └── css/
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone Repository

```bash
git clone https://github.com/ayusharma280205/Team-Heist.git
```

---

### 2️⃣ Import Project in Eclipse

- Open Eclipse
- File → Import
- Existing Projects into Workspace
- Select Project Folder

---

### 3️⃣ Configure Apache Tomcat

- Add Apache Tomcat Server
- Right Click Project
- Run on Server

---

### 4️⃣ Setup MySQL Database

Run the following SQL query:

```sql
CREATE TABLE consultations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id VARCHAR(50),
    symptoms TEXT,
    recommended_tests TEXT
);
```

---

### 5️⃣ Add Gemini API Key

Inside:

```java
SymptomCheckerServlet.java
```

Replace:

```java
private static final String GEMINI_API_KEY = "YOUR_API_KEY";
```

---

## ▶️ Run Project

After starting Tomcat:

```bash
http://localhost:8080/Team-Heist/
```

---

## 🤖 AI Workflow

1. User enters symptoms  
2. Gemini AI analyzes symptoms  
3. AI generates:
   - Clinical Summary
   - Recommended Tests  
4. Data stored in MySQL database  
5. Results shown on dashboard  

---

## 📌 Example Recommendations

| Symptoms | Recommended Test |
|----------|------------------|
| Fever + Headache | CBC Blood Test |
| Cough + Chest Pain | Chest X-Ray |
| Stomach Pain | Ultrasound |

---

## 👨‍💻 Team Details

### Team Name
**Team Heist**

### Branch
Artificial Intelligence & Data Science

### Year
2nd Year

---

## 🚀 Future Improvements

- AI Disease Prediction
- Medical Report Analyzer
- Voice-based Symptom Detection
- Doctor Dashboard
- AI Triage System

---

## 📄 License

This project is developed for educational and hackathon purposes only.

---

## ⭐ GitHub Repository

[Team-Heist Repository](https://github.com/ayusharma280205/Team-Heist)
