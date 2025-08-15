package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Represents a Patient in the DocAid system, extending the base User class.
 * Aligns with the Patient table in the database schema.
 */
public class Patient extends User {

    private int patientId;
    private String firstName;
    private String lastName;
    private String gender;
    private Date dateOfBirth;
    private String bloodType;
    private String address;
    private String phone;
    private double latitude;
    private double longitude;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private static final Logger logger = Logger.getLogger(Patient.class.getName());

    /**
     * Default constructor for creating an empty Patient instance.
     */
    public Patient() {
        super();
    }

    // Getters and Setters
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) {
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new IllegalArgumentException("First name cannot be empty");
        }
        this.firstName = firstName;
    }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) {
        if (lastName == null || lastName.trim().isEmpty()) {
            throw new IllegalArgumentException("Last name cannot be empty");
        }
        this.lastName = lastName;
    }

    public String getGender() { return gender; }
    public void setGender(String gender) {
        if (gender == null || (!gender.equals("Male") && !gender.equals("Female") && !gender.equals("Other"))) {
            throw new IllegalArgumentException("Invalid gender; must be 'Male', 'Female', or 'Other'");
        }
        this.gender = gender;
    }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) {
        if (dateOfBirth == null) {
            throw new IllegalArgumentException("Date of birth cannot be null");
        }
        this.dateOfBirth = dateOfBirth;
    }

    public String getBloodType() { return bloodType; }
    public void setBloodType(String bloodType) {
        // Optional in SQL, so allow null
        this.bloodType = bloodType;
    }

    public String getAddress() { return address; }
    public void setAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            throw new IllegalArgumentException("Address cannot be empty");
        }
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    /**
     * Saves the Patient details to the database, linking to the base User's ID.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs.
     */
    public void saveToDatabase(Connection con) throws SQLException {
        String query = "INSERT INTO Patient (user_id, first_name, last_name, gender, date_of_birth, blood_type, address, phone, latitude, longitude) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, this.getId());  // Link to base User ID
            pstmt.setString(2, this.firstName);
            pstmt.setString(3, this.lastName);
            pstmt.setString(4, this.gender);
            pstmt.setDate(5, this.dateOfBirth);
            if (this.bloodType != null) {
                pstmt.setString(6, this.bloodType);
            } else {
                pstmt.setNull(6, java.sql.Types.VARCHAR);
            }
            pstmt.setString(7, this.address);
            pstmt.setString(8, this.phone);
            pstmt.setDouble(9, this.latitude);
            pstmt.setDouble(10, this.longitude);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving Patient to database", e);
            throw e;
        }
    }

    /**
     * Loads Patient details from the database based on the base User's ID.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs or no record found.
     */
    public void loadFromDatabase(Connection con) throws SQLException {
        String query = "SELECT * FROM Patient WHERE user_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, this.getId());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    this.patientId = rs.getInt("patient_id");
                    this.firstName = rs.getString("first_name");
                    this.lastName = rs.getString("last_name");
                    this.gender = rs.getString("gender");
                    this.dateOfBirth = rs.getDate("date_of_birth");
                    this.bloodType = rs.getString("blood_type");
                    this.address = rs.getString("address");
                    this.latitude = rs.getDouble("latitude");
                    this.longitude = rs.getDouble("longitude");
                    this.createdAt = rs.getTimestamp("created_at");
                    this.updatedAt = rs.getTimestamp("updated_at");
                } else {
                    throw new SQLException("No Patient record found for user_id: " + this.getId());
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading Patient from database", e);
            throw e;
        }
    }
}