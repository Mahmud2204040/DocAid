
package classes;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.math.BigDecimal;
import java.util.concurrent.ThreadLocalRandom;

public class MockDataGenerator {

    private static final String[] BANGLADESHI_FIRST_NAMES = {"Rahim", "Karim", "Fatima", "Ayesha", "Shakib", "Tamim", "Mushfiqur", "Mahmudullah", "Mashrafe", "Rubel"};
    private static final String[] BANGLADESHI_LAST_NAMES = {"Hossain", "Ahmed", "Khan", "Chowdhury", "Islam", "Uddin", "Sarkar", "Ali", "Begum", "Akter"};
    private static final String[] GENDERS = {"Male", "Female"};
    private static final String[] SPECIALTIES = {"Cardiology", "Dermatology", "Neurology", "Gynaecology", "Orthopedics", "Pediatrics", "Oncology", "Psychiatry", "Urology", "ENT"};
    private static final String[] BANGLADESHI_CITIES = {"Dhaka", "Chittagong", "Khulna", "Rajshahi", "Sylhet", "Barisal", "Rangpur", "Mymensingh"};
    private static final String[] DHAKA_AREAS = {"Gulshan", "Banani", "Dhanmondi", "Mirpur", "Uttara", "Mohammadpur", "Badda", "Ramna"};
    private static final String[] HOSPITAL_NAMES = {
        "Square Hospital", "Apollo Hospital", "United Hospital", "Labaid Specialized Hospital", "Popular Diagnostic Centre",
        "Dhaka Medical College Hospital", "Bangabandhu Sheikh Mujib Medical University", "Birdem General Hospital",
        "Holy Family Red Crescent Medical College Hospital", "Kurmitola General Hospital", "Mugda Medical College Hospital",
        "Shaheed Suhrawardy Medical College Hospital", "Sir Salimullah Medical College Hospital", "Ibn Sina Hospital",
        "Green Life Hospital", "Central Hospital", "Anwer Khan Modern Medical College Hospital", "Samorita Hospital",
        "Dhaka Community Medical College & Hospital", "Ad-din Medical College Hospital"
    };
    private static final String[] BLOOD_TYPES = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
    private static final String[] WEEKDAYS = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
    private static final String[] MEDICAL_TESTS = {"Complete Blood Count (CBC)", "Chest X-Ray", "MRI of Brain", "Blood Sugar Test", "Urine Test", "ECG", "Ultrasound", "Endoscopy", "Colonoscopy", "Biopsy"};
    private static final String[] REVIEW_COMMENTS = {
        "Excellent doctor, very knowledgeable and caring.",
        "Good experience, the doctor explained everything clearly.",
        "The waiting time was a bit long, but the consultation was worth it.",
        "I am very satisfied with the treatment.",
        "The doctor was friendly and made me feel comfortable."
    };


    public static void main(String[] args) {
        try (Connection con = DbConnector.getConnection()) {
            clearDatabase(con);
            System.out.println("Generating mock data...");
            generateSpecialties(con);
            generateUsersAndRelatedData(con, 100, 200, 20, 5); // 100 doctors, 200 patients, 20 hospitals, 5 admins
            generateAppointments(con, 500);
            generateReviews(con, 100, 200);
            generateDoctorSchedules(con, 100);
            generateMedicalTests(con, 20);
            generateUserContacts(con, 100, 200, 20);
            generateAffiliationRequests(con, 150, 100, 20);
            System.out.println("Mock data generated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void generateUserContacts(Connection con, int doctorCount, int patientCount, int hospitalCount) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?)";

        List<Integer> patientIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT patient_id FROM Patient")) {
            while (rs.next()) {
                patientIds.add(rs.getInt("patient_id"));
            }
        }

        List<Integer> doctorIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT doctor_id FROM Doctor")) {
            while (rs.next()) {
                doctorIds.add(rs.getInt("doctor_id"));
            }
        }

        List<Integer> hospitalIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT hospital_id FROM Hospital")) {
            while (rs.next()) {
                hospitalIds.add(rs.getInt("hospital_id"));
            }
        }

        try (PreparedStatement pst = con.prepareStatement(sql)) {
            // Patient contacts
            for (int userId : patientIds) {
                pst.setInt(1, userId);
                pst.setString(2, "+88017" + (10000000 + rand.nextInt(90000000)));
                pst.setString(3, "Primary");
                pst.addBatch();
            }

            // Doctor contacts
            for (int userId : doctorIds) {
                pst.setInt(1, userId);
                pst.setString(2, "+88018" + (10000000 + rand.nextInt(90000000)));
                pst.setString(3, "Primary");
                pst.addBatch();

                pst.setInt(1, userId);
                pst.setString(2, "+88019" + (10000000 + rand.nextInt(90000000)));
                pst.setString(3, "Appointment");
                pst.addBatch();
            }

            // Hospital contacts
            for (int userId : hospitalIds) {
                pst.setInt(1, userId);
                pst.setString(2, "+88015" + (10000000 + rand.nextInt(90000000)));
                pst.setString(3, "Primary");
                pst.addBatch();

                pst.setInt(1, userId);
                pst.setString(2, "+88016" + (10000000 + rand.nextInt(90000000)));
                pst.setString(3, "Emergency");
                pst.addBatch();
            }

            pst.executeBatch();
            System.out.println("Generated User Contacts");
        } catch (SQLException e) {
            if (!e.getSQLState().equals("23000")) {
                throw e;
            }
        }
    }

    public static void generateSpecialties(Connection con) throws SQLException {
        String sql = "INSERT INTO Specialties (specialty_name) VALUES (?) ON DUPLICATE KEY UPDATE specialty_name=specialty_name";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            for (String specialty : SPECIALTIES) {
                pst.setString(1, specialty);
                pst.addBatch();
            }
            pst.executeBatch();
            System.out.println("Generated Specialties");
        }
    }

    public static void generateUsersAndRelatedData(Connection con, int doctorCount, int patientCount, int hospitalCount, int adminCount) throws SQLException {
        Random rand = new Random();

        // Generate Admins
        for (int i = 0; i < adminCount; i++) {
            int userId = createUser(con, "admin" + i + "@docaid.com", "Admin");
            String firstName = BANGLADESHI_FIRST_NAMES[rand.nextInt(BANGLADESHI_FIRST_NAMES.length)];
            String lastName = BANGLADESHI_LAST_NAMES[rand.nextInt(BANGLADESHI_LAST_NAMES.length)];
            String sql = "INSERT INTO Admin (admin_id, first_name, last_name) VALUES (?, ?, ?)";
            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, userId);
                pst.setString(2, firstName);
                pst.setString(3, lastName);
                pst.executeUpdate();
            }
        }
        System.out.println("Generated Admins");

        List<String> hospitalNames = new ArrayList<>(List.of(HOSPITAL_NAMES));
        Collections.shuffle(hospitalNames);

        // Generate Hospitals
        for (int i = 0; i < hospitalCount; i++) {
            int userId = createUser(con, "hospital" + i + "@docaid.com", "Hospital");
            String hospitalName = hospitalNames.get(i);
            String address = DHAKA_AREAS[rand.nextInt(DHAKA_AREAS.length)] + ", " + BANGLADESHI_CITIES[0];
            String sql = "INSERT INTO Hospital (hospital_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, userId);
                pst.setString(2, hospitalName);
                pst.setString(3, "A leading hospital in Bangladesh.");
                pst.setString(4, address);
                pst.setString(5, "www." + hospitalName.toLowerCase().replaceAll(" ", "") + ".com");
                pst.setDouble(6, 23.7 + (rand.nextDouble() * 0.1));
                pst.setDouble(7, 90.3 + (rand.nextDouble() * 0.1));
                pst.executeUpdate();
            }
        }
        System.out.println("Generated Hospitals");

        // Get actual hospital IDs
        List<Integer> actualHospitalIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT hospital_id FROM Hospital")) {
            while (rs.next()) {
                actualHospitalIds.add(rs.getInt("hospital_id"));
            }
        }
        if (actualHospitalIds.isEmpty()) {
            System.err.println("No hospitals found, cannot generate doctors with hospital affiliations.");
            return; // Or throw an exception
        }

        // Get specialty IDs
        List<Integer> specialtyIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT specialty_id FROM Specialties")) {
            while (rs.next()) {
                specialtyIds.add(rs.getInt("specialty_id"));
            }
        }

        // Generate Doctors
        for (int i = 0; i < doctorCount; i++) {
            int userId = createUser(con, "doctor" + i + "@docaid.com", "Doctor");
            String firstName = BANGLADESHI_FIRST_NAMES[rand.nextInt(BANGLADESHI_FIRST_NAMES.length)];
            String lastName = BANGLADESHI_LAST_NAMES[rand.nextInt(BANGLADESHI_LAST_NAMES.length)];
            String gender = GENDERS[rand.nextInt(GENDERS.length)];
            String licenseNumber = "BMDC" + (10000 + i);
            int expYears = rand.nextInt(30) + 1;
            String bio = "A dedicated and experienced doctor from Bangladesh.";
            BigDecimal fee = new BigDecimal(rand.nextInt(2000) + 500);
            String address = DHAKA_AREAS[rand.nextInt(DHAKA_AREAS.length)] + ", " + BANGLADESHI_CITIES[0];
            int specialtyId = specialtyIds.get(rand.nextInt(specialtyIds.size()));
            int hospitalId = actualHospitalIds.get(rand.nextInt(actualHospitalIds.size())); // Use actual hospital IDs

            String doctorSql = "INSERT INTO Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pst = con.prepareStatement(doctorSql)) {
                pst.setInt(1, userId);
                pst.setString(2, firstName);
                pst.setString(3, lastName);
                pst.setString(4, gender);
                pst.setString(5, licenseNumber);
                pst.setInt(6, expYears);
                pst.setString(7, bio);
                pst.setBigDecimal(8, fee);
                pst.setString(9, address);
                pst.setDouble(10, 23.7 + (rand.nextDouble() * 0.1));
                pst.setDouble(11, 90.3 + (rand.nextDouble() * 0.1));
                pst.setInt(12, specialtyId);
                pst.setInt(13, hospitalId);
                pst.executeUpdate();
            }
        }
        System.out.println("Generated Doctors");

        // Generate Patients
        for (int i = 0; i < patientCount; i++) {
            int userId = createUser(con, "patient" + i + "@docaid.com", "Patient");
            String firstName = BANGLADESHI_FIRST_NAMES[rand.nextInt(BANGLADESHI_FIRST_NAMES.length)];
            String lastName = BANGLADESHI_LAST_NAMES[rand.nextInt(BANGLADESHI_LAST_NAMES.length)];
            String gender = GENDERS[rand.nextInt(GENDERS.length)];
            long minDay = Date.valueOf("1950-01-01").toLocalDate().toEpochDay();
            long maxDay = Date.valueOf("2005-12-31").toLocalDate().toEpochDay();
            long randomDay = ThreadLocalRandom.current().nextLong(minDay, maxDay);
            Date dob = Date.valueOf(java.time.LocalDate.ofEpochDay(randomDay));
            String bloodType = BLOOD_TYPES[rand.nextInt(BLOOD_TYPES.length)];
            String address = DHAKA_AREAS[rand.nextInt(DHAKA_AREAS.length)] + ", " + BANGLADESHI_CITIES[0];

            String patientSql = "INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pst = con.prepareStatement(patientSql)) {
                pst.setInt(1, userId);
                pst.setString(2, firstName);
                pst.setString(3, lastName);
                pst.setString(4, gender);
                pst.setDate(5, dob);
                pst.setString(6, bloodType);
                pst.setString(7, address);
                pst.setDouble(8, 23.7 + (rand.nextDouble() * 0.1));
                pst.setDouble(9, 90.3 + (rand.nextDouble() * 0.1));
                pst.executeUpdate();
            }
        }
        System.out.println("Generated Patients");
    }

    public static void generateAppointments(Connection con, int count) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) VALUES (?, ?, ?, ?, ?)";

        // Get actual patient IDs
        List<Integer> actualPatientIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT patient_id FROM Patient")) {
            while (rs.next()) {
                actualPatientIds.add(rs.getInt("patient_id"));
            }
        }
        if (actualPatientIds.isEmpty()) {
            System.err.println("No patients found, cannot generate appointments.");
            return;
        }

        // Get actual doctor IDs
        List<Integer> actualDoctorIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT doctor_id FROM Doctor")) {
            while (rs.next()) {
                actualDoctorIds.add(rs.getInt("doctor_id"));
            }
        }
        if (actualDoctorIds.isEmpty()) {
            System.err.println("No doctors found, cannot generate appointments.");
            return;
        }

        try (PreparedStatement pst = con.prepareStatement(sql)) {
            for (int i = 0; i < count; i++) {
                int patientId = actualPatientIds.get(rand.nextInt(actualPatientIds.size())); // Use actual patient IDs
                int doctorId = actualDoctorIds.get(rand.nextInt(actualDoctorIds.size())); // Use actual doctor IDs
                long minDay = Date.valueOf("2024-01-01").toLocalDate().toEpochDay();
                long maxDay = Date.valueOf("2025-12-31").toLocalDate().toEpochDay();
                long randomDay = ThreadLocalRandom.current().nextLong(minDay, maxDay);
                Date appointmentDate = Date.valueOf(java.time.LocalDate.ofEpochDay(randomDay));
                Time appointmentTime = new Time(rand.nextInt(12) + 9, rand.nextBoolean() ? 0 : 30, 0); // 9:00 to 20:30
                String[] statuses = {"Scheduled", "Confirmed", "Completed", "Cancelled"};
                String status = statuses[rand.nextInt(statuses.length)];

                pst.setInt(1, patientId);
                pst.setInt(2, doctorId);
                pst.setDate(3, appointmentDate);
                pst.setTime(4, appointmentTime);
                pst.setString(5, status);
                pst.addBatch();
            }
            pst.executeBatch();
            System.out.println("Generated Appointments");
        }
    }

    public static void generateReviews(Connection con, int doctorCount, int patientCount) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO Reviews (patient_id, doctor_id, rating, comment, review_date) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE rating = VALUES(rating)";

        // Get actual patient IDs
        List<Integer> actualPatientIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT patient_id FROM Patient")) {
            while (rs.next()) {
                actualPatientIds.add(rs.getInt("patient_id"));
            }
        }
        if (actualPatientIds.isEmpty()) {
            System.err.println("No patients found, cannot generate reviews.");
            return;
        }

        // Get actual doctor IDs
        List<Integer> actualDoctorIds = new ArrayList<>();
        try (Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery("SELECT doctor_id FROM Doctor")) {
            while (rs.next()) {
                actualDoctorIds.add(rs.getInt("doctor_id"));
            }
        }
        if (actualDoctorIds.isEmpty()) {
            System.err.println("No doctors found, cannot generate reviews.");
            return;
        }

        try (PreparedStatement pst = con.prepareStatement(sql)) {
            // Loop through actual doctor IDs instead of generating random ones
            for (int doctorId : actualDoctorIds) {
                int reviewCount = rand.nextInt(5) + 1; // 1 to 5 reviews per doctor
                for (int i = 0; i < reviewCount; i++) {
                    int patientId = actualPatientIds.get(rand.nextInt(actualPatientIds.size())); // Use actual patient IDs
                    int rating = rand.nextInt(5) + 1;
                    String comment = REVIEW_COMMENTS[rand.nextInt(REVIEW_COMMENTS.length)];
                    long minDay = Date.valueOf("2024-01-01").toLocalDate().toEpochDay();
                    long maxDay = Date.valueOf("2024-12-31").toLocalDate().toEpochDay();
                    long randomDay = ThreadLocalRandom.current().nextLong(minDay, maxDay);
                    Date reviewDate = Date.valueOf(java.time.LocalDate.ofEpochDay(randomDay));

                    pst.setInt(1, patientId);
                    pst.setInt(2, doctorId);
                    pst.setInt(3, rating);
                    pst.setString(4, comment);
                    pst.setDate(5, reviewDate);
                    pst.addBatch();
                }
            }
            pst.executeBatch();
            System.out.println("Generated Reviews");
        }
    }

    public static void generateDoctorSchedules(Connection con, int doctorCount) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            for (int doctorId = 1; doctorId <= doctorCount; doctorId++) { 
                for (int i = 0; i < 3; i++) { // 3 random schedules per doctor
                    String day = WEEKDAYS[rand.nextInt(WEEKDAYS.length)];
                    Time startTime = new Time(rand.nextInt(4) + 9, 0, 0); // 9:00 - 12:00
                    Time endTime = new Time(rand.nextInt(4) + 17, 0, 0); // 17:00 - 20:00
                    pst.setInt(1, doctorId);
                    pst.setString(2, day);
                    pst.setTime(3, startTime);
                    pst.setTime(4, endTime);
                    pst.addBatch();
                }
            }
            pst.executeBatch();
            System.out.println("Generated Doctor Schedules");
        } catch (SQLException e) {
            // Ignoring duplicate entry errors for schedules
            if (!e.getSQLState().equals("23000")) {
                throw e;
            }
        }
    }

    public static void generateMedicalTests(Connection con, int hospitalCount) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO Medical_test (hospital_id, test_name, price, description) VALUES (?, ?, ?, ?)";
        List<String> allTests = new ArrayList<>(List.of(MEDICAL_TESTS));
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            for (int hospitalId = 1; hospitalId <= hospitalCount; hospitalId++) {
                Collections.shuffle(allTests);
                int testCount = rand.nextInt(6) + 5; // 5 to 10 tests per hospital
                for (int i = 0; i < testCount; i++) {
                    String testName = allTests.get(i);
                    BigDecimal price = new BigDecimal(rand.nextInt(3000) + 500);
                    pst.setInt(1, hospitalId);
                    pst.setString(2, testName);
                    pst.setBigDecimal(3, price);
                    pst.setString(4, "Description for " + testName);
                    pst.addBatch();
                }
            }
            pst.executeBatch();
            System.out.println("Generated Medical Tests");
        } catch (SQLException e) {
            if (!e.getSQLState().equals("23000")) {
                throw e;
            }
        }
    }

    public static void generateAffiliationRequests(Connection con, int count, int doctorCount, int hospitalCount) throws SQLException {
        Random rand = new Random();
        String sql = "INSERT INTO AffiliationRequest (hospital_id, doctor_id, request_status) VALUES (?, ?, ?)";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            for (int i = 0; i < count; i++) {
                int hospitalId = rand.nextInt(hospitalCount) + 1;
                int doctorId = rand.nextInt(doctorCount) + 1;
                String[] statuses = {"Pending", "Approved", "Denied"};
                String status = statuses[rand.nextInt(statuses.length)];

                pst.setInt(1, hospitalId);
                pst.setInt(2, doctorId);
                pst.setString(3, status);
                pst.addBatch();
            }
            pst.executeBatch();
            System.out.println("Generated Affiliation Requests");
        } catch (SQLException e) {
            if (!e.getSQLState().equals("23000")) {
                throw e;
            }
        }
    }

    private static int createUser(Connection con, String email, String userType) throws SQLException {
        String userSql = "INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?)";
        try (PreparedStatement userPst = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
            userPst.setString(1, email);
            userPst.setString(2, MD5.getMd5("password123"));
            userPst.setString(3, userType);
            userPst.executeUpdate();

            try (ResultSet generatedKeys = userPst.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        }
    }

    private static void clearDatabase(Connection con) throws SQLException {
        try (Statement stmt = con.createStatement()) {
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
            stmt.execute("TRUNCATE TABLE AffiliationRequest");
            stmt.execute("TRUNCATE TABLE Medical_test");
            stmt.execute("TRUNCATE TABLE Doctor_schedule");
            stmt.execute("TRUNCATE TABLE Reviews");
            stmt.execute("TRUNCATE TABLE Appointment");
            stmt.execute("TRUNCATE TABLE User_Contact");
            stmt.execute("TRUNCATE TABLE Doctor");
            stmt.execute("TRUNCATE TABLE Patient");
            stmt.execute("TRUNCATE TABLE Admin");
            stmt.execute("TRUNCATE TABLE Hospital");
            stmt.execute("TRUNCATE TABLE Specialties");
            stmt.execute("TRUNCATE TABLE Users");
            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
            System.out.println("Database cleared.");
        }
    }
}
