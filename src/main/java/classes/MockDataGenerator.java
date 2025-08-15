package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;
import java.math.BigDecimal;

public class MockDataGenerator {

    private static final String[] FIRST_NAMES = {"James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda", "William", "Elizabeth"};
    private static final String[] LAST_NAMES = {"Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"};
    private static final String[] GENDERS = {"Male", "Female"};
    private static final String[] SPECIALTIES = {"Cardiology", "Dermatology", "Neurology", "Pediatrics", "Oncology"};
    private static final String[] ADDRESSES = {"123 Main St", "456 Oak Ave", "789 Pine Ln", "321 Elm St", "654 Maple Dr"};

    public static void main(String[] args) {
        try (Connection con = DbConnector.getConnection()) {
            generateDoctors(con, 100);
            System.out.println("Mock data generated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void generateDoctors(Connection con, int count) throws SQLException {
        Random rand = new Random();

        for (int i = 0; i < count; i++) {
            // Create a new user for the doctor
            String email = "doctor" + i + "@example.com";
            String password = MD5.getMd5("password123");
            String userType = "DOCTOR";

            String userSql = "INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?)";
            try (PreparedStatement userPst = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPst.setString(1, email);
                userPst.setString(2, password);
                userPst.setString(3, userType);
                userPst.executeUpdate();

                try (ResultSet generatedKeys = userPst.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);

                        // Create a new doctor
                        String firstName = FIRST_NAMES[rand.nextInt(FIRST_NAMES.length)];
                        String lastName = LAST_NAMES[rand.nextInt(LAST_NAMES.length)];
                        String gender = GENDERS[rand.nextInt(GENDERS.length)];
                        String licenseNumber = "LIC" + (1000 + i);
                        int expYears = rand.nextInt(30) + 1;
                        String bio = "A dedicated and experienced doctor.";
                        BigDecimal fee = new BigDecimal(rand.nextInt(200) + 50);
                        String address = ADDRESSES[rand.nextInt(ADDRESSES.length)];
                        double latitude = 23.7 + (rand.nextDouble() * 0.1);
                        double longitude = 90.3 + (rand.nextDouble() * 0.1);
                        int specialtyId = rand.nextInt(5) + 1; // Assuming specialty IDs are from 1 to 5
                        int hospitalId = rand.nextInt(3) + 1; // Assuming hospital IDs are from 1 to 3

                        String doctorSql = "INSERT INTO Doctor (user_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement doctorPst = con.prepareStatement(doctorSql)) {
                            doctorPst.setInt(1, userId);
                            doctorPst.setString(2, firstName);
                            doctorPst.setString(3, lastName);
                            doctorPst.setString(4, gender);
                            doctorPst.setString(5, licenseNumber);
                            doctorPst.setInt(6, expYears);
                            doctorPst.setString(7, bio);
                            doctorPst.setBigDecimal(8, fee);
                            doctorPst.setString(9, address);
                            doctorPst.setDouble(10, latitude);
                            doctorPst.setDouble(11, longitude);
                            doctorPst.setInt(12, specialtyId);
                            doctorPst.setInt(13, hospitalId);
                            doctorPst.executeUpdate();
                        }
                    }
                }
            }
        }
    }
}
