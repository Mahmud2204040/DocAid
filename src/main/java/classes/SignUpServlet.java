package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> specialties = new ArrayList<>();
        try (Connection con = DbConnector.getConnection()) {
            String sql = "SELECT specialty_id, specialty_name FROM Specialties ORDER BY specialty_name";
            try (PreparedStatement pst = con.prepareStatement(sql);
                 ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> specialty = new HashMap<>();
                    specialty.put("id", rs.getString("specialty_id"));
                    specialty.put("name", rs.getString("specialty_name"));
                    specialties.add(specialty);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching specialties.", e);
        }

        request.setAttribute("specialties", specialties);
        request.getRequestDispatcher("/sign_up.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirectURL = "log.jsp?status=success";
        String errorMessage = "";

        Connection con = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtRole = null;
        ResultSet rs = null;

        String userType = request.getParameter("user_type");

        try {
            con = DbConnector.getConnection();
            if (con == null) {
                throw new SQLException("Failed to establish database connection.");
            }
            con.setAutoCommit(false);

            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                userType == null || userType.trim().isEmpty()) {
                throw new IllegalArgumentException("Email, password, and user type are required.");
            }

            String hashedPassword = MD5.getMd5(password);

            // Step 1: Insert into Users table
            String sqlUser = "INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?)";
            pstmtUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, email);
            pstmtUser.setString(2, hashedPassword);
            pstmtUser.setString(3, userType);
            int userRowsAffected = pstmtUser.executeUpdate();

            if (userRowsAffected == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            // Step 2: Get the generated user_id
            long userId = -1;
            rs = pstmtUser.getGeneratedKeys();
            if (rs.next()) {
                userId = rs.getLong(1);
            } else {
                throw new SQLException("Creating user failed, no ID obtained.");
            }

            // Step 3: Insert into the role-specific table (Doctor, Patient, Hospital)
            String sqlRole = "";

            switch (userType) {
                case "Doctor":
                    sqlRole = "INSERT INTO Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    pstmtRole = con.prepareStatement(sqlRole);
                    pstmtRole.setLong(1, userId);
                    pstmtRole.setString(2, request.getParameter("doctor_first_name"));
                    pstmtRole.setString(3, request.getParameter("doctor_last_name"));
                    pstmtRole.setString(4, request.getParameter("doctor_gender"));
                    pstmtRole.setString(5, request.getParameter("license_number"));

                    String expYearsParam = request.getParameter("exp_years");
                    if (expYearsParam != null && !expYearsParam.isEmpty()) {
                        pstmtRole.setInt(6, Integer.parseInt(expYearsParam));
                    } else {
                        pstmtRole.setNull(6, Types.INTEGER);
                    }

                    pstmtRole.setString(7, request.getParameter("bio"));

                    String feeParam = request.getParameter("fee");
                    if (feeParam != null && !feeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(8, new BigDecimal(feeParam));
                    } else {
                        pstmtRole.setNull(8, Types.DECIMAL);
                    }

                    pstmtRole.setString(9, request.getParameter("doctor_address"));

                    String doctorLatitudeParam = request.getParameter("doctor_latitude");
                    if (doctorLatitudeParam != null && !doctorLatitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(10, new BigDecimal(doctorLatitudeParam));
                    } else {
                        pstmtRole.setNull(10, Types.DECIMAL);
                    }

                    String doctorLongitudeParam = request.getParameter("doctor_longitude");
                    if (doctorLongitudeParam != null && !doctorLongitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(11, new BigDecimal(doctorLongitudeParam));
                    } else {
                        pstmtRole.setNull(11, Types.DECIMAL);
                    }

                    String specialtyName = request.getParameter("specialty_name");
                    Integer specialtyId = null;
                    if (specialtyName != null && !specialtyName.trim().isEmpty()) {
                        String sqlSpecialty = "SELECT specialty_id FROM Specialties WHERE specialty_name = ?";
                        try (PreparedStatement pstmtSpecialty = con.prepareStatement(sqlSpecialty)) {
                            pstmtSpecialty.setString(1, specialtyName);
                            try (ResultSet rsSpecialty = pstmtSpecialty.executeQuery()) {
                                if (rsSpecialty.next()) {
                                    specialtyId = rsSpecialty.getInt("specialty_id");
                                }
                            }
                        }
                    }

                    if (specialtyId != null) {
                        pstmtRole.setInt(12, specialtyId);
                    } else {
                        pstmtRole.setNull(12, Types.INTEGER);
                    }
                    break;

                case "Patient":
                    sqlRole = "INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    pstmtRole = con.prepareStatement(sqlRole);
                    pstmtRole.setLong(1, userId);
                    pstmtRole.setString(2, request.getParameter("patient_first_name"));
                    pstmtRole.setString(3, request.getParameter("patient_last_name"));
                    pstmtRole.setString(4, request.getParameter("patient_gender"));

                    String dobParam = request.getParameter("patient_dob");
                    if (dobParam != null && !dobParam.isEmpty()) {
                        pstmtRole.setDate(5, java.sql.Date.valueOf(dobParam));
                    } else {
                        pstmtRole.setNull(5, Types.DATE);
                    }

                    pstmtRole.setString(6, request.getParameter("blood_type"));
                    pstmtRole.setString(7, request.getParameter("patient_address"));

                    String patientLatitudeParam = request.getParameter("patient_latitude");
                    if (patientLatitudeParam != null && !patientLatitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(8, new BigDecimal(patientLatitudeParam));
                    } else {
                        pstmtRole.setNull(8, Types.DECIMAL);
                    }

                    String patientLongitudeParam = request.getParameter("patient_longitude");
                    if (patientLongitudeParam != null && !patientLongitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(9, new BigDecimal(patientLongitudeParam));
                    } else {
                        pstmtRole.setNull(9, Types.DECIMAL);
                    }
                    break;

                case "Hospital":
                    sqlRole = "INSERT INTO Hospital (hospital_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    pstmtRole = con.prepareStatement(sqlRole);
                    pstmtRole.setLong(1, userId);
                    pstmtRole.setString(2, request.getParameter("hospital_name"));
                    pstmtRole.setString(3, request.getParameter("hospital_bio"));
                    pstmtRole.setString(4, request.getParameter("hospital_address"));
                    pstmtRole.setString(5, request.getParameter("website"));

                    String hospitalLatitudeParam = request.getParameter("hospital_latitude");
                    if (hospitalLatitudeParam != null && !hospitalLatitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(6, new BigDecimal(hospitalLatitudeParam));
                    } else {
                        pstmtRole.setNull(6, Types.DECIMAL);
                    }

                    String hospitalLongitudeParam = request.getParameter("hospital_longitude");
                    if (hospitalLongitudeParam != null && !hospitalLongitudeParam.isEmpty()) {
                        pstmtRole.setBigDecimal(7, new BigDecimal(hospitalLongitudeParam));
                    } else {
                        pstmtRole.setNull(7, Types.DECIMAL);
                    }
                    break;
            }

            if (pstmtRole != null) {
                int roleRowsAffected = pstmtRole.executeUpdate();
                if (roleRowsAffected == 0) {
                    throw new SQLException("Creating " + userType + " details failed, no rows affected.");
                }
            }

            // Step 4: Insert role-specific contacts
            switch (userType) {
                case "Patient":
                    insertContact(con, userId, request.getParameter("patient_primary_contact"), "Primary");
                    break;
                case "Doctor":
                    insertContact(con, userId, request.getParameter("doctor_primary_contact"), "Primary");
                    insertContact(con, userId, request.getParameter("doctor_appointment_contact"), "Appointment");
                    break;
                case "Hospital":
                    insertContact(con, userId, request.getParameter("hospital_primary_contact"), "Primary");
                    insertContact(con, userId, request.getParameter("hospital_emergency_contact"), "Emergency");
                    break;
            }

            con.commit();

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    // Log rollback error
                }
            }
            errorMessage = "Error during registration: " + e.getMessage();
            try {
                redirectURL = "sign_up.jsp?status=error&message=" + java.net.URLEncoder.encode(errorMessage, "UTF-8");
            } catch (java.io.UnsupportedEncodingException ex) {
                // ignore
            }
            e.printStackTrace();
            System.out.println("SIGNUP_ERROR: " + errorMessage);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
            try { if (pstmtUser != null) pstmtUser.close(); } catch (SQLException e) { /* ignored */ }
            try { if (pstmtRole != null) pstmtRole.close(); } catch (SQLException e) { /* ignored */ }
            try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }

            try {
                response.sendRedirect(redirectURL);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void insertContact(Connection conn, long userId, String contactNo, String contactType) throws SQLException {
        if (contactNo != null && !contactNo.trim().isEmpty()) {
            String sql = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setLong(1, userId);
                pstmt.setString(2, contactNo.trim());
                pstmt.setString(3, contactType);
                pstmt.executeUpdate();
            }
        }
    }
}
