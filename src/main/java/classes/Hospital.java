package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Hospital extends User {

    private int hospitalId;
    private String hospitalName;
    private String hospitalBio;
    private String address;
    private String website;
    private double latitude;
    private double longitude;

    public Hospital() {
        super();
    }

    public Hospital(int hospitalId, int userId, String email) {
        this.hospitalId = hospitalId;
        this.setId(userId);
        this.setEmail(email);
    }

    // Getters and Setters
    public int getHospitalId() { return hospitalId; }
    public void setHospitalId(int hospitalId) { this.hospitalId = hospitalId; }
    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }
    public String getHospitalBio() { return hospitalBio; }
    public void setHospitalBio(String hospitalBio) { this.hospitalBio = hospitalBio; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    private String primaryContact;
    private String emergencyContact;

    public String getPrimaryContact() { return primaryContact; }
    public void setPrimaryContact(String primaryContact) { this.primaryContact = primaryContact; }
    public String getEmergencyContact() { return emergencyContact; }
    public void setEmergencyContact(String emergencyContact) { this.emergencyContact = emergencyContact; }

    // Inner DTO classes
    public static class DashboardAnalytics {
        public int affiliatedDoctorsCount, upcomingAppointmentsCount, testsAvailableCount;
        public double averageRating;
        public Map<String, Integer> appointmentsByStatus = new HashMap<>();
        public List<PatientFeedback> recentReviews = new ArrayList<>();
        public int getAffiliatedDoctorsCount() { return affiliatedDoctorsCount; }
        public int getUpcomingAppointmentsCount() { return upcomingAppointmentsCount; }
        public int getTestsAvailableCount() { return testsAvailableCount; }
        public double getAverageRating() { return averageRating; }
        public Map<String, Integer> getAppointmentsByStatus() { return appointmentsByStatus; }
        public List<PatientFeedback> getRecentReviews() { return recentReviews; }
    }

    public static class AffiliatedDoctor {
        public int doctorId, reviewCount;
        public String fullName, specialty;
        public double rating;
        public boolean isVerified;
        public int getDoctorId() { return doctorId; }
        public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        public String getSpecialty() { return specialty; }
        public void setSpecialty(String specialty) { this.specialty = specialty; }
        public double getRating() { return rating; }
        public void setRating(double rating) { this.rating = rating; }
        public int getReviewCount() { return reviewCount; }
        public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
        public boolean isVerified() { return isVerified; }
        public void setVerified(boolean isVerified) { this.isVerified = isVerified; }
    }

    public static class PatientFeedback {
        public String doctorName, patientName, comment, reviewDate;
        public int rating;
        public String getDoctorName() { return doctorName; }
        public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
        public String getReviewDate() { return reviewDate; }
        public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    }

    public static class MedicalTestRecord {
        public int testId;
        public String testName, description;
        public double price;
        public boolean isActive;
        public int getTestId() { return testId; }
        public void setTestId(int testId) { this.testId = testId; }
        public String getTestName() { return testName; }
        public void setTestName(String testName) { this.testName = testName; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        public boolean isActive() { return isActive; }
        public void setActive(boolean active) { this.isActive = active; }
    }

    public static class AppointmentDetail {
        public int appointmentId;
        public String patientName, doctorName, appointmentDateTime, status;
        public int getAppointmentId() { return appointmentId; }
        public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public String getDoctorName() { return doctorName; }
        public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
        public String getAppointmentDateTime() { return appointmentDateTime; }
        public void setAppointmentDateTime(String appointmentDateTime) { this.appointmentDateTime = appointmentDateTime; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    public static class AvailableDoctor {
        private int doctorId;
        private String fullName, specialty, currentHospitalName;
        public int getDoctorId() { return doctorId; }
        public void setDoctorId(int id) { this.doctorId = id; }
        public String getFullName() { return fullName; }
        public void setFullName(String name) { this.fullName = name; }
        public String getSpecialty() { return specialty; }
        public void setSpecialty(String s) { this.specialty = s; }
        public String getCurrentHospitalName() { return currentHospitalName; }
        public void setCurrentHospitalName(String name) { this.currentHospitalName = name; }
    }

    // Database Methods
    public DashboardAnalytics getDashboardAnalytics() throws SQLException {
        DashboardAnalytics analytics = new DashboardAnalytics();
        try (Connection conn = DbConnector.getConnection()) {
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*), AVG(rating) FROM Doctor WHERE hospital_id = ?")) {
                pstmt.setInt(1, this.hospitalId);
                try (ResultSet rs = pstmt.executeQuery()) { if (rs.next()) { analytics.affiliatedDoctorsCount = rs.getInt(1); analytics.averageRating = rs.getDouble(2); } }
            }
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM Appointment WHERE appointment_date >= CURDATE() AND doctor_id IN (SELECT doctor_id FROM Doctor WHERE hospital_id = ?)")) {
                pstmt.setInt(1, this.hospitalId);
                try (ResultSet rs = pstmt.executeQuery()) { if (rs.next()) { analytics.upcomingAppointmentsCount = rs.getInt(1); } }
            }
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM Medical_test WHERE hospital_id = ? AND is_active = TRUE")) {
                pstmt.setInt(1, this.hospitalId);
                try (ResultSet rs = pstmt.executeQuery()) { if (rs.next()) { analytics.testsAvailableCount = rs.getInt(1); } }
            }
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT appointment_status, COUNT(*) as count FROM Appointment WHERE doctor_id IN (SELECT doctor_id FROM Doctor WHERE hospital_id = ?) GROUP BY appointment_status")) {
                pstmt.setInt(1, this.hospitalId);
                try (ResultSet rs = pstmt.executeQuery()) { while (rs.next()) { analytics.appointmentsByStatus.put(rs.getString("appointment_status"), rs.getInt("count")); } }
            }
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT CONCAT(d.first_name, ' ', d.last_name) as doctor_name, CONCAT(p.first_name, ' ', p.last_name) as patient_name, r.rating, r.comment, r.review_date FROM Reviews r JOIN Doctor d ON r.doctor_id = d.doctor_id JOIN Patient p ON r.patient_id = p.patient_id WHERE d.hospital_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC LIMIT 5")) {
                pstmt.setInt(1, this.hospitalId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        PatientFeedback review = new PatientFeedback();
                        review.setDoctorName(rs.getString("doctor_name"));
                        review.setPatientName(rs.getString("patient_name"));
                        review.setRating(rs.getInt("rating"));
                        review.setComment(rs.getString("comment"));
                        review.setReviewDate(rs.getDate("review_date").toString());
                        analytics.recentReviews.add(review);
                    }
                }
            }
        }
        return analytics;
    }

    public List<AffiliatedDoctor> getAffiliatedDoctors() throws SQLException {
        List<AffiliatedDoctor> doctors = new ArrayList<>();
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("SELECT doctor_id, display_name, specialty, rating, review_count, is_verified FROM v_doctor_search WHERE hospital_id = ? ORDER BY last_name, first_name")) {
            pstmt.setInt(1, this.hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AffiliatedDoctor doc = new AffiliatedDoctor();
                    doc.setDoctorId(rs.getInt("doctor_id"));
                    doc.setFullName(rs.getString("display_name"));
                    doc.setSpecialty(rs.getString("specialty"));
                    doc.setRating(rs.getDouble("rating"));
                    doc.setReviewCount(rs.getInt("review_count"));
                    doc.setVerified(rs.getBoolean("is_verified"));
                    doctors.add(doc);
                }
            }
        }
        return doctors;
    }

    public List<MedicalTestRecord> getMedicalTests() throws SQLException {
        List<MedicalTestRecord> tests = new ArrayList<>();
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("SELECT test_id, test_name, description, price, is_active FROM Medical_test WHERE hospital_id = ? ORDER BY test_name")) {
            pstmt.setInt(1, this.hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalTestRecord test = new MedicalTestRecord();
                    test.setTestId(rs.getInt("test_id"));
                    test.setTestName(rs.getString("test_name"));
                    test.setDescription(rs.getString("description"));
                    test.setPrice(rs.getDouble("price"));
                    test.setActive(rs.getBoolean("is_active"));
                    tests.add(test);
                }
            }
        }
        return tests;
    }

    public List<AppointmentDetail> getAppointments() throws SQLException {
        List<AppointmentDetail> appointments = new ArrayList<>();
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("SELECT appointment_id, patient_name, doctor_name, appointment_date, appointment_time, appointment_status FROM v_appointment_details WHERE hospital_id = ? ORDER BY appointment_date DESC, appointment_time DESC")) {
            pstmt.setInt(1, this.hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AppointmentDetail appt = new AppointmentDetail();
                    appt.setAppointmentId(rs.getInt("appointment_id"));
                    appt.setPatientName(rs.getString("patient_name"));
                    appt.setDoctorName(rs.getString("doctor_name"));
                    appt.setAppointmentDateTime(rs.getDate("appointment_date").toString() + " " + rs.getTime("appointment_time").toString());
                    appt.setStatus(rs.getString("appointment_status"));
                    appointments.add(appt);
                }
            }
        }
        return appointments;
    }

    public List<PatientFeedback> getFullPatientFeedback() throws SQLException {
        List<PatientFeedback> feedbackList = new ArrayList<>();
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("SELECT CONCAT(d.first_name, ' ', d.last_name) as doctor_name, CONCAT(p.first_name, ' ', p.last_name) as patient_name, r.rating, r.comment, r.review_date FROM Reviews r JOIN Doctor d ON r.doctor_id = d.doctor_id JOIN Patient p ON r.patient_id = p.patient_id WHERE d.hospital_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC")) {
            pstmt.setInt(1, this.hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PatientFeedback review = new PatientFeedback();
                    review.setDoctorName(rs.getString("doctor_name"));
                    review.setPatientName(rs.getString("patient_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setReviewDate(rs.getDate("review_date").toString());
                    feedbackList.add(review);
                }
            }
        }
        return feedbackList;
    }

    public void loadDetails() throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("SELECT hospital_name, hospital_bio, address, website, latitude, longitude FROM Hospital WHERE hospital_id = ?")) {
            pstmt.setInt(1, this.hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    this.setHospitalName(rs.getString("hospital_name"));
                    this.setHospitalBio(rs.getString("hospital_bio"));
                    this.setAddress(rs.getString("address"));
                    this.setWebsite(rs.getString("website"));
                    this.setLatitude(rs.getDouble("latitude"));
                    this.setLongitude(rs.getDouble("longitude"));
                }
            }
        }
    }

    public boolean updateDetails() throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("UPDATE Hospital SET hospital_name = ?, hospital_bio = ?, address = ?, website = ? WHERE hospital_id = ?")) {
            pstmt.setString(1, this.hospitalName);
            pstmt.setString(2, this.hospitalBio);
            pstmt.setString(3, this.address);
            pstmt.setString(4, this.website);
            pstmt.setInt(5, this.hospitalId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean createMedicalTest(String testName, String description, double price) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Medical_test (hospital_id, test_name, price, description, is_active) VALUES (?, ?, ?, ?, TRUE)")) {
            pstmt.setInt(1, this.hospitalId);
            pstmt.setString(2, testName);
            pstmt.setDouble(3, price);
            pstmt.setString(4, description);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateMedicalTest(int testId, String testName, String description, double price) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("UPDATE Medical_test SET test_name = ?, price = ?, description = ? WHERE test_id = ? AND hospital_id = ?")) {
            pstmt.setString(1, testName);
            pstmt.setDouble(2, price);
            pstmt.setString(3, description);
            pstmt.setInt(4, testId);
            pstmt.setInt(5, this.hospitalId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteMedicalTest(int testId) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Medical_test WHERE test_id = ? AND hospital_id = ?")) {
            pstmt.setInt(1, testId);
            pstmt.setInt(2, this.hospitalId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<AvailableDoctor> searchAvailableDoctors(String searchTerm) throws SQLException {
        List<AvailableDoctor> doctors = new ArrayList<>();
        String sql = "SELECT doctor_id, display_name, specialty, hospital_name FROM v_doctor_search WHERE (hospital_id IS NULL OR hospital_id != ?) AND display_name LIKE ?";
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.hospitalId);
            pstmt.setString(2, "%" + searchTerm + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AvailableDoctor doc = new AvailableDoctor();
                    doc.setDoctorId(rs.getInt("doctor_id"));
                    doc.setFullName(rs.getString("display_name"));
                    doc.setSpecialty(rs.getString("specialty"));
                    doc.setCurrentHospitalName(rs.getString("hospital_name"));
                    doctors.add(doc);
                }
            }
        }
        return doctors;
    }

    public String sendAffiliationRequest(int doctorId) throws SQLException {
        String checkSql = "SELECT request_id FROM AffiliationRequest WHERE hospital_id = ? AND doctor_id = ? AND request_status = 'Pending'";
        try (Connection conn = DbConnector.getConnection(); PreparedStatement checkPstmt = conn.prepareStatement(checkSql)) {
            checkPstmt.setInt(1, this.hospitalId);
            checkPstmt.setInt(2, doctorId);
            try (ResultSet rs = checkPstmt.executeQuery()) {
                if (rs.next()) {
                    return "A request is already pending for this doctor.";
                }
            }
            String insertSql = "INSERT INTO AffiliationRequest (hospital_id, doctor_id, request_status) VALUES (?, ?, 'Pending')";
            try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql)) {
                insertPstmt.setInt(1, this.hospitalId);
                insertPstmt.setInt(2, doctorId);
                int rowsAffected = insertPstmt.executeUpdate();
                if (rowsAffected > 0) {
                    return "Affiliation request sent successfully.";
                } else {
                    return "Failed to send affiliation request.";
                }
            }
        }
    }

    public static Hospital getHospitalById(Connection con, int hospitalId) throws SQLException {
        Hospital hospital = null;
        String sql = "SELECT * FROM v_hospital_details WHERE hospital_id = ?";
        
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    hospital = new Hospital();
                    hospital.setHospitalId(rs.getInt("hospital_id"));
                    hospital.setId(rs.getInt("user_id"));
                    hospital.setHospitalName(rs.getString("hospital_name"));
                    hospital.setHospitalBio(rs.getString("hospital_bio"));
                    hospital.setAddress(rs.getString("address"));
                    hospital.setWebsite(rs.getString("website"));
                    hospital.setLatitude(rs.getDouble("latitude"));
                    hospital.setLongitude(rs.getDouble("longitude"));
                    hospital.setEmail(rs.getString("email"));
                    hospital.setPrimaryContact(rs.getString("primary_contact"));
                    hospital.setEmergencyContact(rs.getString("emergency_contact"));
                }
            }
        }
        return hospital;
    }
}