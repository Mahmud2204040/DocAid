package classes;

import classes.DbConnector;
import classes.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Admin extends User {

    private int adminId;

    // Data Holder Inner Classes
    public static class DashboardAnalytics { 
        private Map<String, Integer> userCounts = new HashMap<>();
        private Map<String, Integer> appointmentStats = new HashMap<>();
        private int pendingReviewsCount;

        public Map<String, Integer> getUserCounts() {
            return userCounts;
        }

        public int getPendingReviewsCount() {
            return pendingReviewsCount;
        }

        public Map<String, Integer> getAppointmentStats() {
            return appointmentStats;
        }
    }

    public static class UserDetails { 
        private int userId;
        private String email, userType, fullName;
        public int getUserId() { return userId; }
        public String getEmail() { return email; }
        public String getUserType() { return userType; }
        public String getFullName() { return fullName; }
        public void setUserId(int id) { this.userId = id; }
        public void setEmail(String s) { this.email = s; }
        public void setUserType(String s) { this.userType = s; }
        public void setFullName(String s) { this.fullName = s; }
    }

    public static class PendingReview {
        private int reviewId, rating;
        private String patientName, doctorName, comment, reviewDate;
        public int getReviewId() { return reviewId; }
        public String getPatientName() { return patientName; }
        public String getDoctorName() { return doctorName; }
        public int getRating() { return rating; }
        public String getComment() { return comment; }
        public String getReviewDate() { return reviewDate; }
        public void setReviewId(int id) { this.reviewId = id; }
        public void setPatientName(String s) { this.patientName = s; }
        public void setDoctorName(String s) { this.doctorName = s; }
        public void setRating(int r) { this.rating = r; }
        public void setComment(String s) { this.comment = s; }
        public void setReviewDate(String s) { this.reviewDate = s; }
    }



    public static class Specialty {
        private int specialtyId;
        private String specialtyName;
        public Specialty(int id, String name) { this.specialtyId = id; this.specialtyName = name; }
        public int getSpecialtyId() { return specialtyId; }
        public String getSpecialtyName() { return specialtyName; }
    }

    public static class AppointmentReport {
        private int totalAppointments, appointmentsThisMonth;
        private Map<String, Integer> appointmentsByMonth = new LinkedHashMap<>();
        public int getTotalAppointments() { return totalAppointments; }
        public int getAppointmentsThisMonth() { return appointmentsThisMonth; }
        public Map<String, Integer> getAppointmentsByMonth() { return appointmentsByMonth; }
        public void setTotalAppointments(int i) { this.totalAppointments = i; }
        public void setAppointmentsThisMonth(int i) { this.appointmentsThisMonth = i; }
        public void setAppointmentsByMonth(Map<String, Integer> map) { this.appointmentsByMonth = map; }
    }

    // Constructor
    public Admin(int adminId, String email) {
        this.adminId = adminId;
        this.setId(adminId);
        this.setEmail(email);
    }

    // Methods
    public DashboardAnalytics getDashboardAnalytics() throws SQLException {
        DashboardAnalytics analytics = new DashboardAnalytics();
        try (Connection conn = DbConnector.getConnection(); Statement stmt = conn.createStatement()) {
            try (ResultSet rs = stmt.executeQuery("SELECT user_type, COUNT(*) AS count FROM Users GROUP BY user_type")) {
                while (rs.next()) analytics.userCounts.put(rs.getString("user_type"), rs.getInt("count"));
            }
            try (ResultSet rs = stmt.executeQuery("SELECT appointment_status, COUNT(*) AS count FROM Appointment GROUP BY appointment_status")) {
                while (rs.next()) analytics.appointmentStats.put(rs.getString("appointment_status"), rs.getInt("count"));
            }
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Reviews WHERE is_moderated = FALSE")) {
                if (rs.next()) analytics.pendingReviewsCount = rs.getInt(1);
            }


        }
        return analytics;
    }

    public List<UserDetails> getRecentActivity() throws SQLException {
        List<UserDetails> recentUsers = new ArrayList<>();
        String sql = "SELECT u.user_id, u.email, u.user_type, " +
                     "CASE " +
                     "    WHEN u.user_type = 'Admin' THEN CONCAT(a.first_name, ' ', a.last_name) " +
                     "    WHEN u.user_type = 'Doctor' THEN CONCAT(d.first_name, ' ', d.last_name) " +
                     "    WHEN u.user_type = 'Patient' THEN CONCAT(p.first_name, ' ', p.last_name) " +
                     "    WHEN u.user_type = 'Hospital' THEN h.hospital_name " +
                     "END as full_name " +
                     "FROM Users u " +
                     "LEFT JOIN Admin a ON u.user_id = a.admin_id " +
                     "LEFT JOIN Doctor d ON u.user_id = d.doctor_id " +
                     "LEFT JOIN Patient p ON u.user_id = p.patient_id " +
                     "LEFT JOIN Hospital h ON u.user_id = h.hospital_id " +
                     "ORDER BY u.user_id DESC LIMIT 5";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                UserDetails user = new UserDetails();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setUserType(rs.getString("user_type"));
                user.setFullName(rs.getString("full_name"));
                recentUsers.add(user);
            }
        }
        return recentUsers;
    }

    public List<UserDetails> getAllUsers(String userTypeFilter) throws SQLException {
        List<UserDetails> users = new ArrayList<>();
        String sql = "SELECT u.user_id, u.email, u.user_type, " +
                     "CASE " +
                     "    WHEN u.user_type = 'Admin' THEN CONCAT(a.first_name, ' ', a.last_name) " +
                     "    WHEN u.user_type = 'Doctor' THEN CONCAT(d.first_name, ' ', d.last_name) " +
                     "    WHEN u.user_type = 'Patient' THEN CONCAT(p.first_name, ' ', p.last_name) " +
                     "    WHEN u.user_type = 'Hospital' THEN h.hospital_name " +
                     "END as full_name " +
                     "FROM Users u " +
                     "LEFT JOIN Admin a ON u.user_id = a.admin_id " +
                     "LEFT JOIN Doctor d ON u.user_id = d.doctor_id " +
                     "LEFT JOIN Patient p ON u.user_id = p.patient_id " +
                     "LEFT JOIN Hospital h ON u.user_id = h.hospital_id";
        if (userTypeFilter != null && !userTypeFilter.trim().isEmpty()) {
            sql += " WHERE u.user_type = ?";
        }
        sql += " ORDER BY u.user_id DESC;";
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (userTypeFilter != null && !userTypeFilter.trim().isEmpty()) {
                pstmt.setString(1, userTypeFilter);
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserDetails user = new UserDetails();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setUserType(rs.getString("user_type"));
                    user.setFullName(rs.getString("full_name"));
                    users.add(user);
                }
            }
        }
        return users;
    }

    public boolean deleteUser(int userId) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Users WHERE user_id = ?")) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<PendingReview> getPendingReviews() throws SQLException {
        List<PendingReview> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                     "CONCAT(d.first_name, ' ', d.last_name) as doctor_name, r.rating, r.comment, r.review_date " +
                     "FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id JOIN Doctor d ON r.doctor_id = d.doctor_id " +
                     "WHERE r.is_moderated = FALSE ORDER BY r.review_date ASC;";
        try (Connection conn = DbConnector.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                PendingReview review = new PendingReview();
                review.setReviewId(rs.getInt("review_id"));
                review.setPatientName(rs.getString("patient_name"));
                review.setDoctorName(rs.getString("doctor_name"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setReviewDate(rs.getDate("review_date").toString());
                reviews.add(review);
            }
        }
        return reviews;
    }

    public boolean approveReview(int reviewId) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("UPDATE Reviews SET is_moderated = TRUE, admin_id = ? WHERE review_id = ?")) {
            pstmt.setInt(1, this.adminId);
            pstmt.setInt(2, reviewId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Reviews WHERE review_id = ?")) {
            pstmt.setInt(1, reviewId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public static boolean userExists(int userId) throws SQLException {
        String sql = "SELECT 1 FROM Users WHERE user_id = ?";
        try (Connection conn = DbConnector.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }



    public List<Specialty> getAllSpecialties() throws SQLException {
        List<Specialty> specialties = new ArrayList<>();
        try (Connection conn = DbConnector.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT specialty_id, specialty_name FROM Specialties ORDER BY specialty_name")) {
            while (rs.next()) {
                specialties.add(new Specialty(rs.getInt("specialty_id"), rs.getString("specialty_name")));
            }
        }
        return specialties;
    }

    public boolean createSpecialty(String specialtyName) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Specialties (specialty_name) VALUES (?)")) {
            pstmt.setString(1, specialtyName);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateSpecialty(int specialtyId, String newName) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("UPDATE Specialties SET specialty_name = ? WHERE specialty_id = ?")) {
            pstmt.setString(1, newName);
            pstmt.setInt(2, specialtyId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSpecialty(int specialtyId) throws SQLException {
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Specialties WHERE specialty_id = ?")) {
            pstmt.setInt(1, specialtyId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    public AppointmentReport getAppointmentReport() throws SQLException {
        AppointmentReport report = new AppointmentReport();
        try (Connection conn = DbConnector.getConnection(); Statement stmt = conn.createStatement()) {
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Appointment")) {
                if (rs.next()) report.setTotalAppointments(rs.getInt(1));
            }
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Appointment WHERE MONTH(appointment_date) = MONTH(CURDATE()) AND YEAR(appointment_date) = YEAR(CURDATE())")) {
                if (rs.next()) report.setAppointmentsThisMonth(rs.getInt(1));
            }
            try (ResultSet rs = stmt.executeQuery("SELECT DATE_FORMAT(appointment_date, '%Y-%m') as month, COUNT(*) as count FROM Appointment GROUP BY month ORDER BY month ASC")) {
                Map<String, Integer> byMonthMap = new LinkedHashMap<>();
                while (rs.next()) byMonthMap.put(rs.getString("month"), rs.getInt("count"));
                report.setAppointmentsByMonth(byMonthMap);
            }
        }
        return report;
    }
}