package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Represents a Medical Test in the DocAid system.
 * Maps to the Medical_test table in the database schema.
 * 
 * @author DocAid Team
 * @version 2.0
 */
public class MedicalTest {
    
    private int testId;
    private int hospitalId;
    private String testName;
    private BigDecimal price;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Extended properties for frontend functionality
    private String category;
    private String duration;
    private String preparation;
    private String reportTime;
    private String equipmentNeeded;
    
    private static final Logger logger = Logger.getLogger(MedicalTest.class.getName());
    
    // Constants for validation
    private static final int MAX_TEST_NAME_LENGTH = 255;
    private static final int MAX_DESCRIPTION_LENGTH = 2000;
    private static final BigDecimal MIN_PRICE = BigDecimal.ZERO;
    private static final BigDecimal MAX_PRICE = new BigDecimal("99999.99");
    
    /**
     * Default constructor for creating an empty MedicalTest instance.
     */
    public MedicalTest() {
        this.price = BigDecimal.ZERO;
        this.isActive = true;
    }
    
    /**
     * Constructor with basic test information.
     */
    public MedicalTest(int hospitalId, String testName, BigDecimal price) {
        this();
        setHospitalId(hospitalId);
        setTestName(testName);
        setPrice(price);
    }
    
    /**
     * Constructor with complete test information.
     */
    public MedicalTest(int hospitalId, String testName, BigDecimal price, String description, boolean isActive) {
        this(hospitalId, testName, price);
        setDescription(description);
        setActive(isActive);
    }
    
    // Getters and Setters with validation
    
    public int getTestId() {
        return testId;
    }
    
    public void setTestId(int testId) {
        this.testId = testId;
    }
    
    public int getHospitalId() {
        return hospitalId;
    }
    
    public void setHospitalId(int hospitalId) {
        if (hospitalId <= 0) {
            throw new IllegalArgumentException("Hospital ID must be a positive integer");
        }
        this.hospitalId = hospitalId;
    }
    
    public String getTestName() {
        return testName;
    }
    
    public void setTestName(String testName) {
        if (testName == null || testName.trim().isEmpty()) {
            throw new IllegalArgumentException("Test name cannot be empty");
        }
        if (testName.length() > MAX_TEST_NAME_LENGTH) {
            throw new IllegalArgumentException("Test name cannot exceed " + MAX_TEST_NAME_LENGTH + " characters");
        }
        this.testName = testName.trim();
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        if (price == null) {
            throw new IllegalArgumentException("Price cannot be null");
        }
        if (price.compareTo(MIN_PRICE) < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        if (price.compareTo(MAX_PRICE) > 0) {
            throw new IllegalArgumentException("Price cannot exceed " + MAX_PRICE);
        }
        this.price = price;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        if (description != null && description.length() > MAX_DESCRIPTION_LENGTH) {
            throw new IllegalArgumentException("Description cannot exceed " + MAX_DESCRIPTION_LENGTH + " characters");
        }
        this.description = description != null ? description.trim() : null;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        this.isActive = active;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    // No setter for createdAt (DB-managed)
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    // No setter for updatedAt (DB-managed)
    
    // Extended properties for frontend functionality
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public String getPreparation() {
        return preparation;
    }
    
    public void setPreparation(String preparation) {
        this.preparation = preparation;
    }
    
    public String getReportTime() {
        return reportTime;
    }
    
    public void setReportTime(String reportTime) {
        this.reportTime = reportTime;
    }
    
    public String getEquipmentNeeded() {
        return equipmentNeeded;
    }
    
    public void setEquipmentNeeded(String equipmentNeeded) {
        this.equipmentNeeded = equipmentNeeded;
    }
    
    // Business Logic Methods
    
    /**
     * Returns formatted price string for display.
     */
    public String getFormattedPrice() {
        if (price == null) return "$0.00";
        NumberFormat formatter = NumberFormat.getCurrencyInstance(Locale.US);
        return formatter.format(price);
    }
    
    /**
     * Returns a shortened description for display purposes.
     */
    public String getShortDescription(int maxLength) {
        if (description == null || description.length() <= maxLength) {
            return description;
        }
        return description.substring(0, maxLength - 3) + "...";
    }
    
    /**
     * Checks if the test is available (active).
     */
    public boolean isAvailable() {
        return isActive;
    }
    
    /**
     * Returns the availability status as a string.
     */
    public String getAvailabilityStatus() {
        return isActive ? "Available" : "Unavailable";
    }
    
    /**
     * Validates all test data before database operations.
     */
    public void validate() throws IllegalArgumentException {
        if (hospitalId <= 0) {
            throw new IllegalArgumentException("Valid hospital ID is required");
        }
        if (testName == null || testName.trim().isEmpty()) {
            throw new IllegalArgumentException("Test name is required");
        }
        if (price == null || price.compareTo(MIN_PRICE) < 0) {
            throw new IllegalArgumentException("Valid price is required");
        }
    }
    
    /**
     * Determines the test category based on test name.
     */
    public String determineCategory() {
        if (testName == null) return "General";
        
        String name = testName.toLowerCase();
        if (name.contains("blood") || name.contains("cbc") || name.contains("hemoglobin")) {
            return "Blood Tests";
        } else if (name.contains("x-ray") || name.contains("ct") || name.contains("mri") || name.contains("ultrasound")) {
            return "Imaging";
        } else if (name.contains("ecg") || name.contains("echo") || name.contains("cardiac")) {
            return "Cardiology";
        } else if (name.contains("biopsy") || name.contains("pap") || name.contains("cytology")) {
            return "Pathology";
        } else if (name.contains("scan") || name.contains("nuclear") || name.contains("pet")) {
            return "Radiology";
        } else if (name.contains("urine") || name.contains("stool") || name.contains("culture")) {
            return "Laboratory";
        } else {
            return "General";
        }
    }
    
    // Database Operations
    
    /**
     * Saves the MedicalTest to the database.
     * Uses INSERT operation.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs.
     */
    public void saveToDatabase(Connection con) throws SQLException {
        validate(); // Validate before saving
        
        String query = "INSERT INTO Medical_test (hospital_id, test_name, price, description, is_active) " +
                       "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, this.hospitalId);
            pstmt.setString(2, this.testName);
            pstmt.setBigDecimal(3, this.price);
            
            if (this.description != null && !this.description.trim().isEmpty()) {
                pstmt.setString(4, this.description);
            } else {
                pstmt.setNull(4, java.sql.Types.LONGVARCHAR);
            }
            
            pstmt.setBoolean(5, this.isActive);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        this.testId = generatedKeys.getInt(1);
                    }
                }
                logger.info("Medical test saved successfully with ID: " + this.testId);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error saving medical test to database", e);
            throw e;
        }
    }
    
    /**
     * Updates existing MedicalTest in the database.
     * Uses UPDATE operation.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs.
     */
    public void updateToDatabase(Connection con) throws SQLException {
        validate(); // Validate before updating
        
        String query = "UPDATE Medical_test SET hospital_id=?, test_name=?, price=?, description=?, is_active=? WHERE test_id=?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, this.hospitalId);
            pstmt.setString(2, this.testName);
            pstmt.setBigDecimal(3, this.price);
            
            if (this.description != null && !this.description.trim().isEmpty()) {
                pstmt.setString(4, this.description);
            } else {
                pstmt.setNull(4, java.sql.Types.LONGVARCHAR);
            }
            
            pstmt.setBoolean(5, this.isActive);
            pstmt.setInt(6, this.testId);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No medical test found to update with ID: " + this.testId);
            }
            logger.info("Medical test updated successfully with ID: " + this.testId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating medical test in database", e);
            throw e;
        }
    }
    
    /**
     * Loads MedicalTest from the database based on test ID.
     *
     * @param con Active database connection.
     * @param testId The test ID to load.
     * @throws SQLException if a database error occurs or no record found.
     */
    public void loadFromDatabase(Connection con, int testId) throws SQLException {
        String query = "SELECT * FROM Medical_test WHERE test_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, testId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    this.testId = rs.getInt("test_id");
                    this.hospitalId = rs.getInt("hospital_id");
                    this.testName = rs.getString("test_name");
                    this.price = rs.getBigDecimal("price");
                    this.description = rs.getString("description");
                    this.isActive = rs.getBoolean("is_active");
                    this.createdAt = rs.getTimestamp("created_at");
                    this.updatedAt = rs.getTimestamp("updated_at");
                    
                    // Set derived category
                    this.category = determineCategory();
                    
                    logger.info("Medical test loaded successfully with ID: " + testId);
                } else {
                    throw new SQLException("No medical test found with ID: " + testId);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading medical test from database", e);
            throw e;
        }
    }
    
    /**
     * Deletes the MedicalTest from the database.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs.
     */
    public void deleteFromDatabase(Connection con) throws SQLException {
        String query = "DELETE FROM Medical_test WHERE test_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, this.testId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No medical test found to delete with ID: " + this.testId);
            }
            logger.info("Medical test deleted successfully with ID: " + this.testId);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting medical test from database", e);
            throw e;
        }
    }
    
    // Static Methods for Database Queries
    
    /**
     * Loads all medical tests from the database.
     *
     * @param con Active database connection.
     * @return List of MedicalTest objects.
     * @throws SQLException if a database error occurs.
     */
    public static List<MedicalTest> getAllMedicalTests(Connection con) throws SQLException {
        List<MedicalTest> tests = new ArrayList<>();
        String query = "SELECT * FROM Medical_test ORDER BY test_name";
        
        try (PreparedStatement pstmt = con.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                MedicalTest test = new MedicalTest();
                test.testId = rs.getInt("test_id");
                test.hospitalId = rs.getInt("hospital_id");
                test.testName = rs.getString("test_name");
                test.price = rs.getBigDecimal("price");
                test.description = rs.getString("description");
                test.isActive = rs.getBoolean("is_active");
                test.createdAt = rs.getTimestamp("created_at");
                test.updatedAt = rs.getTimestamp("updated_at");
                test.category = test.determineCategory();
                tests.add(test);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading all medical tests from database", e);
            throw e;
        }
        
        return tests;
    }
    
    /**
     * Loads all medical tests for a specific hospital.
     *
     * @param con Active database connection.
     * @param hospitalId The hospital ID to filter by.
     * @return List of MedicalTest objects for the hospital.
     * @throws SQLException if a database error occurs.
     */
    public static List<MedicalTest> getMedicalTestsByHospital(Connection con, int hospitalId) throws SQLException {
        List<MedicalTest> tests = new ArrayList<>();
        String query = "SELECT * FROM Medical_test WHERE hospital_id = ? ORDER BY test_name";
        
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalTest test = new MedicalTest();
                    test.testId = rs.getInt("test_id");
                    test.hospitalId = rs.getInt("hospital_id");
                    test.testName = rs.getString("test_name");
                    test.price = rs.getBigDecimal("price");
                    test.description = rs.getString("description");
                    test.isActive = rs.getBoolean("is_active");
                    test.createdAt = rs.getTimestamp("created_at");
                    test.updatedAt = rs.getTimestamp("updated_at");
                    test.category = test.determineCategory();
                    tests.add(test);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading medical tests by hospital from database", e);
            throw e;
        }
        
        return tests;
    }
    
    /**
     * Searches medical tests by name or description.
     *
     * @param con Active database connection.
     * @param searchTerm Search term to match against name or description.
     * @return List of matching MedicalTest objects.
     * @throws SQLException if a database error occurs.
     */
    public static List<MedicalTest> searchMedicalTests(Connection con, String searchTerm) throws SQLException {
        List<MedicalTest> tests = new ArrayList<>();
        String query = "SELECT * FROM Medical_test WHERE test_name LIKE ? OR description LIKE ? ORDER BY test_name";
        
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalTest test = new MedicalTest();
                    test.testId = rs.getInt("test_id");
                    test.hospitalId = rs.getInt("hospital_id");
                    test.testName = rs.getString("test_name");
                    test.price = rs.getBigDecimal("price");
                    test.description = rs.getString("description");
                    test.isActive = rs.getBoolean("is_active");
                    test.createdAt = rs.getTimestamp("created_at");
                    test.updatedAt = rs.getTimestamp("updated_at");
                    test.category = test.determineCategory();
                    tests.add(test);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching medical tests in database", e);
            throw e;
        }
        
        return tests;
    }
    
    /**
     * Gets medical tests by price range.
     *
     * @param con Active database connection.
     * @param minPrice Minimum price.
     * @param maxPrice Maximum price.
     * @return List of MedicalTest objects within the price range.
     * @throws SQLException if a database error occurs.
     */
    public static List<MedicalTest> getMedicalTestsByPriceRange(Connection con, BigDecimal minPrice, BigDecimal maxPrice) throws SQLException {
        List<MedicalTest> tests = new ArrayList<>();
        String query = "SELECT * FROM Medical_test WHERE price >= ? AND price <= ? ORDER BY price";
        
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setBigDecimal(1, minPrice);
            pstmt.setBigDecimal(2, maxPrice);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalTest test = new MedicalTest();
                    test.testId = rs.getInt("test_id");
                    test.hospitalId = rs.getInt("hospital_id");
                    test.testName = rs.getString("test_name");
                    test.price = rs.getBigDecimal("price");
                    test.description = rs.getString("description");
                    test.isActive = rs.getBoolean("is_active");
                    test.createdAt = rs.getTimestamp("created_at");
                    test.updatedAt = rs.getTimestamp("updated_at");
                    test.category = test.determineCategory();
                    tests.add(test);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading medical tests by price range from database", e);
            throw e;
        }
        
        return tests;
    }
    
    /**
     * Gets active medical tests for a specific hospital.
     *
     * @param con Active database connection.
     * @param hospitalId The hospital ID to filter by.
     * @return List of active MedicalTest objects for the hospital.
     * @throws SQLException if a database error occurs.
     */
    public static List<MedicalTest> getActiveMedicalTestsByHospital(Connection con, int hospitalId) throws SQLException {
        List<MedicalTest> tests = new ArrayList<>();
        String query = "SELECT * FROM Medical_test WHERE hospital_id = ? AND is_active = TRUE ORDER BY test_name";
        
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, hospitalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MedicalTest test = new MedicalTest();
                    test.testId = rs.getInt("test_id");
                    test.hospitalId = rs.getInt("hospital_id");
                    test.testName = rs.getString("test_name");
                    test.price = rs.getBigDecimal("price");
                    test.description = rs.getString("description");
                    test.isActive = rs.getBoolean("is_active");
                    test.createdAt = rs.getTimestamp("created_at");
                    test.updatedAt = rs.getTimestamp("updated_at");
                    test.category = test.determineCategory();
                    tests.add(test);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading active medical tests by hospital from database", e);
            throw e;
        }
        
        return tests;
    }
    
    // Utility Methods
    
    @Override
    public String toString() {
        return "MedicalTest{" +
                "testId=" + testId +
                ", hospitalId=" + hospitalId +
                ", testName='" + testName + '\'' +
                ", price=" + price +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                ", category='" + category + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        MedicalTest that = (MedicalTest) obj;
        return testId == that.testId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(testId);
    }
    
    /**
     * Returns a display name for the medical test.
     */
    public String getDisplayName() {
        return testName != null ? testName : "Unknown Test";
    }
    
    /**
     * Checks if the test has complete information.
     */
    public boolean isComplete() {
        return testName != null && !testName.trim().isEmpty() &&
               price != null && price.compareTo(MIN_PRICE) >= 0 &&
               hospitalId > 0;
    }
}
