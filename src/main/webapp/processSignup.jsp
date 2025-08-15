<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, classes.DbConnector, classes.MD5, java.util.*, java.math.BigDecimal" %>
<%
    String redirectURL = "login.jsp?status=success";
    String errorMessage = "";
    
    Connection con = null;
    PreparedStatement pstmtUser = null;
    PreparedStatement pstmtRole = null; 
    PreparedStatement pstmtContact = null;
    ResultSet rs = null;

    try {
        con = DbConnector.getConnection();
        if (con == null) {
            throw new SQLException("Failed to establish database connection.");
        }
        con.setAutoCommit(false);

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("user_type");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            userType == null || userType.trim().isEmpty()) {
            throw new IllegalArgumentException("Email, password, and user type are required.");
        }

        String hashedPassword = MD5.getMd5(password);

        String sqlUser = "INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?)";
        pstmtUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
        pstmtUser.setString(1, email);
        pstmtUser.setString(2, hashedPassword);
        pstmtUser.setString(3, userType);
        int userRowsAffected = pstmtUser.executeUpdate();

        if (userRowsAffected == 0) {
            throw new SQLException("Creating user failed, no rows affected.");
        }

        long userId = -1;
        rs = pstmtUser.getGeneratedKeys();
        if (rs.next()) {
            userId = rs.getLong(1);
        } else {
            throw new SQLException("Creating user failed, no ID obtained.");
        }

        String sqlRole = "";
        String sqlContact = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?)";

        switch (userType) {
            case "Admin":
                sqlRole = "INSERT INTO Admin (user_id, first_name, last_name) VALUES (?, ?, ?)";
                pstmtRole = con.prepareStatement(sqlRole);
                pstmtRole.setLong(1, userId);
                pstmtRole.setString(2, request.getParameter("admin_first_name"));
                pstmtRole.setString(3, request.getParameter("admin_last_name"));
                break;

            case "Doctor":
                sqlRole = "INSERT INTO Doctor (user_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmtRole = con.prepareStatement(sqlRole);
                pstmtRole.setLong(1, userId);
                pstmtRole.setString(2, request.getParameter("doctor_first_name"));
                pstmtRole.setString(3, request.getParameter("doctor_last_name"));
                pstmtRole.setString(4, request.getParameter("doctor_gender"));
                pstmtRole.setString(5, request.getParameter("license_number"));

                // Fixed: Safe handling for nullable int fields
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
                pstmtRole.setNull(10, Types.DECIMAL); // Latitude (null if not collected)
                pstmtRole.setNull(11, Types.DECIMAL); // Longitude (null if not collected)

                // Fixed: Specialty lookup and safe setInt/setNull
                String specialtyName = request.getParameter("specialty_name");
                Integer specialtyId = null;
                if (specialtyName != null && !specialtyName.trim().isEmpty()) {
                    // Customize this map based on your database IDs
                    Map<String, Integer> specialtyMap = new HashMap<>();
                    specialtyMap.put("Cardiology", 1);
                    specialtyMap.put("Dermatology", 2);
                    specialtyMap.put("Emergency Medicine", 3);
                    // Add all specialties...
                    specialtyId = specialtyMap.get(specialtyName);
                }
                if (specialtyId != null) {
                    pstmtRole.setInt(12, specialtyId);
                } else {
                    pstmtRole.setNull(12, Types.INTEGER);
                }

                String hospitalIdParam = request.getParameter("hospital_id");
                if (hospitalIdParam != null && !hospitalIdParam.isEmpty()) {
                    pstmtRole.setInt(13, Integer.parseInt(hospitalIdParam));
                } else {
                    pstmtRole.setNull(13, Types.INTEGER);
                }
                break;

            case "Patient":
                sqlRole = "INSERT INTO Patient (user_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
                pstmtRole.setNull(8, Types.DECIMAL); // Latitude
                pstmtRole.setNull(9, Types.DECIMAL); // Longitude

                pstmtContact = con.prepareStatement(sqlContact);
                pstmtContact.setLong(1, userId);
                pstmtContact.setString(2, request.getParameter("contact_no"));
                pstmtContact.setString(3, "Primary");
                pstmtContact.executeUpdate();
                break;

            case "Hospital":
                sqlRole = "INSERT INTO Hospital (user_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?)";
                pstmtRole = con.prepareStatement(sqlRole);
                pstmtRole.setLong(1, userId);
                pstmtRole.setString(2, request.getParameter("hospital_name"));
                pstmtRole.setString(3, request.getParameter("hospital_bio"));
                pstmtRole.setString(4, request.getParameter("hospital_address"));
                pstmtRole.setString(5, request.getParameter("website"));
                pstmtRole.setNull(6, Types.DECIMAL); // Latitude
                pstmtRole.setNull(7, Types.DECIMAL); // Longitude

                pstmtContact = con.prepareStatement(sqlContact);
                pstmtContact.setLong(1, userId);
                pstmtContact.setString(2, request.getParameter("contact_no"));
                pstmtContact.setString(3, "Emergency");
                pstmtContact.executeUpdate();
                break;
        }

        if (pstmtRole != null) {
            int roleRowsAffected = pstmtRole.executeUpdate();
            if (roleRowsAffected == 0) {
                throw new SQLException("Creating " + userType + " details failed, no rows affected.");
            }
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
        redirectURL = "sign_up.jsp?status=error&message=" + java.net.URLEncoder.encode(errorMessage, "UTF-8");
        e.printStackTrace();
        System.out.println("SIGNUP_ERROR: " + errorMessage);
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignored */ }
        try { if (pstmtUser != null) pstmtUser.close(); } catch (SQLException e) { /* ignored */ }
        try { if (pstmtRole != null) pstmtRole.close(); } catch (SQLException e) { /* ignored */ }
        try { if (pstmtContact != null) pstmtContact.close(); } catch (SQLException e) { /* ignored */ }
        try { if (con != null) con.close(); } catch (SQLException e) { /* ignored */ }

        response.sendRedirect(redirectURL);
    }
%>
