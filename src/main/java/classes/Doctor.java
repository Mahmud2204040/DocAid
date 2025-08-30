package classes;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Doctor extends User {

    private int doctorId;
    private String firstName;
    private String lastName;
    private String displayName;
    private String gender;
    private String licenseNumber;
    private int expYears;
    private String bio;
    private BigDecimal fee;
    private String address;
    private String phone;
    private double latitude;
    private double longitude;
    private Integer specialtyId;
    private String specialtyName;
    private Integer hospitalId;
    private String hospitalName;
    private double rating;
    private int reviewCount;
   
    private double distance;
    private boolean availableToday;
    private String nextAvailableSlot;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private static final Logger logger = Logger.getLogger(Doctor.class.getName());

    public Doctor() {
        super();
    }

    // Getters and Setters
    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }
    public int getExpYears() { return expYears; }
    public void setExpYears(int expYears) { this.expYears = expYears; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }
    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }
    public Integer getSpecialtyId() { return specialtyId; }
    public void setSpecialtyId(Integer specialtyId) { this.specialtyId = specialtyId; }
    public String getSpecialtyName() { return specialtyName; }
    public void setSpecialtyName(String specialtyName) { this.specialtyName = specialtyName; }
    public Integer getHospitalId() { return hospitalId; }
    public void setHospitalId(Integer hospitalId) { this.hospitalId = hospitalId; }
    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    
    public void setSpecialty(String specialtyName) { this.specialtyName = specialtyName; }

    public String getSpecialty() { return this.specialtyName; } // Added to match JSP expression language

    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public void setDistance(double distance) { this.distance = distance; }

    // Inner DTO classes
    public static class Review {
        private String patientName, comment, reviewDate;
        private int rating;
        public String getPatientName() { return patientName; }
        public void setPatientName(String patientName) { this.patientName = patientName; }
        public int getRating() { return rating; }
        public void setRating(int rating) { this.rating = rating; }
        public String getComment() { return comment; }
        public void setComment(String comment) { this.comment = comment; }
        public String getReviewDate() { return reviewDate; }
        public void setReviewDate(String reviewDate) { this.reviewDate = reviewDate; }
    }

    public static class AffiliationRequestDetails {
        private int requestId;
        private String hospitalName, requestDate;
        public int getRequestId() { return requestId; }
        public void setRequestId(int id) { this.requestId = id; }
        public String getHospitalName() { return hospitalName; }
        public void setHospitalName(String name) { this.hospitalName = name; }
        public String getRequestDate() { return requestDate; }
        public void setRequestDate(String date) { this.requestDate = date; }
    }

    // Database Methods
    public void saveToDatabase(Connection con) throws SQLException {
        // Step 1: Insert into Doctor table (without phone)
        String query = "INSERT INTO Doctor (user_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, this.getId());
            pstmt.setString(2, this.firstName);
            pstmt.setString(3, this.lastName);
            pstmt.setString(4, this.gender);
            pstmt.setString(5, this.licenseNumber);
            pstmt.setInt(6, this.expYears);
            pstmt.setString(7, this.bio);
            pstmt.setBigDecimal(8, this.fee);
            pstmt.setString(9, this.address);
            pstmt.setDouble(10, this.latitude);
            pstmt.setDouble(11, this.longitude);
            pstmt.setObject(12, this.specialtyId);
            pstmt.setObject(13, this.hospitalId);
            pstmt.executeUpdate();
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    this.doctorId = generatedKeys.getInt(1);
                }
            }
        }

        // Step 2: Insert phone number into User_Contact table if it exists
        if (this.phone != null && !this.phone.trim().isEmpty()) {
            // Using INSERT ... ON DUPLICATE KEY UPDATE to handle existing contacts
            String contactQuery = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, 'Primary') ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no)";
            try (PreparedStatement contactPstmt = con.prepareStatement(contactQuery)) {
                contactPstmt.setInt(1, this.getId());
                contactPstmt.setString(2, this.phone);
                contactPstmt.executeUpdate();
            }
        }
    }

    public List<Review> getReviews(Connection con) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.rating, r.comment, r.review_date, p.first_name, p.last_name FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id WHERE r.doctor_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, this.getDoctorId());
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setPatientName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setReviewDate(rs.getDate("review_date").toString());
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public List<AffiliationRequestDetails> getPendingAffiliationRequests() throws SQLException {
        List<AffiliationRequestDetails> requests = new ArrayList<>();
        String sql = "SELECT ar.request_id, h.hospital_name, ar.created_at FROM AffiliationRequest ar JOIN Hospital h ON ar.hospital_id = h.hospital_id WHERE ar.doctor_id = ? AND ar.request_status = 'Pending' ORDER BY ar.created_at DESC";
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.getDoctorId());
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    AffiliationRequestDetails req = new AffiliationRequestDetails();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setHospitalName(rs.getString("hospital_name"));
                    req.setRequestDate(rs.getTimestamp("created_at").toString());
                    requests.add(req);
                }
            }
        }
        return requests;
    }

    public boolean respondToAffiliationRequest(int requestId, String newStatus) throws SQLException {
        String getRequestSql = "SELECT hospital_id, doctor_id FROM AffiliationRequest WHERE request_id = ? AND request_status = 'Pending'";
        String updateRequestSql = "UPDATE AffiliationRequest SET request_status = ? WHERE request_id = ?";
        String updateDoctorSql = "UPDATE Doctor SET hospital_id = ? WHERE doctor_id = ?";
        String denyOtherRequestsSql = "UPDATE AffiliationRequest SET request_status = 'Denied' WHERE doctor_id = ? AND request_status = 'Pending'";
        
        try (Connection conn = DbConnector.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int hospitalId = -1;
                int doctorId = -1;
                try (PreparedStatement pstmt = conn.prepareStatement(getRequestSql)) {
                    pstmt.setInt(1, requestId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            hospitalId = rs.getInt("hospital_id");
                            doctorId = rs.getInt("doctor_id");
                        } else {
                            throw new SQLException("Request not found or not pending.");
                        }
                    }
                }
                try (PreparedStatement pstmt = conn.prepareStatement(updateRequestSql)) {
                    pstmt.setString(1, newStatus);
                    pstmt.setInt(2, requestId);
                    pstmt.executeUpdate();
                }
                if ("Approved".equalsIgnoreCase(newStatus)) {
                    try (PreparedStatement pstmt = conn.prepareStatement(updateDoctorSql)) {
                        pstmt.setInt(1, hospitalId);
                        pstmt.setInt(2, doctorId);
                        pstmt.executeUpdate();
                    }
                    try (PreparedStatement pstmt = conn.prepareStatement(denyOtherRequestsSql)) {
                        pstmt.setInt(1, doctorId);
                        pstmt.executeUpdate();
                    }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public boolean removeAffiliation() throws SQLException {
        String sql = "UPDATE Doctor SET hospital_id = NULL WHERE doctor_id = ?";
        try (Connection conn = DbConnector.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.getDoctorId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public static Doctor getDoctorById(Connection con, int doctorId, String viewerRole) throws SQLException {
        String contactType;
        if ("Patient".equals(viewerRole)) {
            contactType = "Appointment";
        } else if ("Hospital".equals(viewerRole)) {
            contactType = "Primary";
        } else {
            // Default for other roles or if viewerRole is null
            contactType = "Primary"; 
        }

        String sql = "SELECT d.*, s.specialty_name, h.hospital_name, u.email, uc.contact_no " +
                     "FROM Doctor d " +
                     "JOIN Users u ON d.user_id = u.user_id " +
                     "LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id " +
                     "LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id " +
                     "LEFT JOIN User_Contact uc ON u.user_id = uc.user_id AND uc.contact_type = ? " +
                     "WHERE d.doctor_id = ?;";
        
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, contactType);
            pstmt.setInt(2, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setId(rs.getInt("user_id"));
                    doctor.setFirstName(rs.getString("first_name"));
                    doctor.setLastName(rs.getString("last_name"));
                    doctor.setDisplayName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    doctor.setGender(rs.getString("gender"));
                    doctor.setLicenseNumber(rs.getString("license_number"));
                    doctor.setExpYears(rs.getInt("exp_years"));
                    doctor.setBio(rs.getString("bio"));
                    doctor.setFee(rs.getBigDecimal("fee"));
                    doctor.setAddress(rs.getString("address"));
                    doctor.setPhone(rs.getString("contact_no"));
                    doctor.setSpecialtyName(rs.getString("specialty_name"));
                    doctor.setHospitalName(rs.getString("hospital_name"));
                    doctor.setRating(rs.getDouble("rating"));
                    doctor.setReviewCount(rs.getInt("review_count"));
                    doctor.setEmail(rs.getString("email"));
                    return doctor;
                } else {
                    return null;
                }
            }
        }
    }
}