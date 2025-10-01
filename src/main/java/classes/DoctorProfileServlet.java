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

        System.out.println("[DoctorProfileServlet] Loading profile for user_id: " + userId);

        // 3. Single Database Query (FIXED)
        String sql = "SELECT d.*, s.specialty_name, h.hospital_name, u.email, " +
                     "MAX(CASE WHEN uc.contact_type = 'Primary' THEN uc.contact_no END) AS primary_contact, " +
                     "MAX(CASE WHEN uc.contact_type = 'Appointment' THEN uc.contact_no END) AS appointment_contact " +
                     "FROM Doctor d " +
                     "JOIN Users u ON d.doctor_id = u.user_id " +
                     "LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id " +
                     "LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id " +
                     "LEFT JOIN User_Contact uc ON d.doctor_id = uc.user_id " +
                     "WHERE d.doctor_id = ? " +
                     "GROUP BY d.doctor_id";

        try (Connection conn = DbConnector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            System.out.println("[DoctorProfileServlet] Executing query...");

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("[DoctorProfileServlet] Doctor record found!");

                    // Populate the Doctor bean (FIXED - removed duplicate code)
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
                    doctorProfile.setSpecialty(rs.getString("specialty_name"));
                    doctorProfile.setHospitalName(rs.getString("hospital_name"));
                    doctorProfile.setRating(rs.getDouble("rating"));
                    doctorProfile.setReviewCount(rs.getInt("review_count"));
                    doctorProfile.setEmail(rs.getString("email"));

                    // FIXED: Use correct column names
                    String primaryContact = rs.getString("primary_contact");
                    String appointmentContact = rs.getString("appointment_contact");

                    request.setAttribute("primaryContact", primaryContact != null ? primaryContact : "");
                    request.setAttribute("appointmentContact", appointmentContact != null ? appointmentContact : "");

                } else {
                    System.out.println("[DoctorProfileServlet] No doctor record found for user ID: " + userId);
                    request.setAttribute("error", "Doctor profile not found.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error while fetching doctor profile.", e);
        }

        // 4. Set attributes and forward to correct JSP (FIXED)
        request.setAttribute("doctorProfile", doctorProfile);
        request.setAttribute("activePage", "profile");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/index.jsp");
        dispatcher.forward(request, response);
    }
}