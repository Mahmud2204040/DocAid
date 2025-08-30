package classes;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet to handle fetching and displaying a doctor's profile information.
 */
@WebServlet("/doctor/profile")
public class DoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. Session & Authentication Check
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2. Authorization Check
        String role = (String) session.getAttribute("user_role");
        if (!"Doctor".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        Doctor doctorProfile = new Doctor();

        // --- DEBUGGING --- 
        System.out.println("[DoctorProfileServlet] Attempting to load profile for user_id from session: " + userId);

        // 2. Database Logic (moved from JSP)
        // This query is corrected to match the current schema
        String sql = "SELECT d.*, s.specialty_name, h.hospital_name, u.email, uc.contact_no " +
                     "FROM Doctor d " +
                     "JOIN Users u ON d.user_id = u.user_id " +
                     "LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id " +
                     "LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id " +
                     "LEFT JOIN User_Contact uc ON u.user_id = uc.user_id " +
                     "WHERE d.user_id = ?;";

        try (Connection conn = DbConnector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            // --- DEBUGGING --- 
            System.out.println("[DoctorProfileServlet] Executing query to find doctor profile.");

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // --- DEBUGGING --- 
                    System.out.println("[DoctorProfileServlet] SUCCESS: Doctor record found in database.");

                    // Populate the Doctor bean
                    doctorProfile.setId(userId);
                    doctorProfile.setDoctorId(rs.getInt("doctor_id"));
                    doctorProfile.setFirstName(rs.getString("first_name"));
                    doctorProfile.setLastName(rs.getString("last_name"));
                    doctorProfile.setGender(rs.getString("gender"));
                    doctorProfile.setLicenseNumber(rs.getString("license_number"));
                    doctorProfile.setExpYears(rs.getInt("exp_years"));
                    doctorProfile.setBio(rs.getString("bio"));
                    doctorProfile.setFee(rs.getBigDecimal("fee"));
                    doctorProfile.setAddress(rs.getString("address"));
                    doctorProfile.setPhone(rs.getString("contact_no"));
                                        doctorProfile.setSpecialty(rs.getString("specialty_name"));
                    doctorProfile.setHospitalName(rs.getString("hospital_name"));
                    doctorProfile.setRating(rs.getDouble("rating"));
                    doctorProfile.setReviewCount(rs.getInt("review_count"));
                    // You would also set hospital name, etc.
                    // request.setAttribute("hospitalName", rs.getString("hospital_name"));
                } else {
                    // Handle case where no doctor profile exists for the user ID
                    // --- DEBUGGING --- 
                    System.out.println("[DoctorProfileServlet] FAILED: No doctor record found for user ID: " + userId);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching doctor profile.", e);
        }

        // 3. Set attribute and forward to the JSP view
        request.setAttribute("doctorProfile", doctorProfile);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/index.jsp");
        dispatcher.forward(request, response);
    }
}
