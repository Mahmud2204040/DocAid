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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import classes.DbConnector;
import classes.Doctor;

@WebServlet("/patient/doctor-profile")
public class PatientViewDoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required.");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdStr);

        try (Connection con = DbConnector.getConnection()) {
            // 1. Fetch Doctor Details from the view
            Doctor doctor = getDoctorFromView(con, doctorId);
            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found.");
                return;
            }

            // 2. Fetch Doctor Reviews
            List<Map<String, Object>> reviews = getDoctorReviews(con, doctorId);

            // 3. Fetch Doctor Schedule
            List<Map<String, Object>> schedule = DoctorService.getDoctorSchedule(con, doctorId);

            request.setAttribute("doctor", doctor);
            request.setAttribute("reviews", reviews);
            request.setAttribute("schedule", schedule);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/PATIENT/doctor_profile.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching doctor profile.", e);
        }
    }

    private Doctor getDoctorFromView(Connection con, int doctorId) throws SQLException {
        String sql = "SELECT * FROM v_doctor_search WHERE doctor_id = ?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, doctorId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setId(rs.getInt("user_id"));
                    doctor.setDisplayName(rs.getString("display_name"));
                    doctor.setFirstName(rs.getString("first_name"));
                    doctor.setLastName(rs.getString("last_name"));
                    doctor.setGender(rs.getString("gender"));
                    doctor.setLicenseNumber(rs.getString("license_number"));
                    doctor.setExpYears(rs.getInt("experience"));
                    doctor.setBio(rs.getString("bio"));
                    doctor.setFee(rs.getBigDecimal("fee"));
                    doctor.setAddress(rs.getString("address"));
                    doctor.setPhone(rs.getString("appointment_contact"));
                    doctor.setSpecialtyName(rs.getString("specialty"));
                                                            doctor.setHospitalName(rs.getString("hospital_name"));
                    doctor.setRating(rs.getDouble("rating"));
                    doctor.setReviewCount(rs.getInt("review_count"));
                    doctor.setEmail(rs.getString("email"));
                    return doctor;
                }
            }
        }
        return null;
    }

    private List<Map<String, Object>> getDoctorReviews(Connection con, int doctorId) throws SQLException {
        List<Map<String, Object>> reviews = new ArrayList<>();
        String sql = "SELECT r.*, p.first_name, p.last_name FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id WHERE r.doctor_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, doctorId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("patientName", rs.getString("first_name") + " " + rs.getString("last_name"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("comment", rs.getString("comment"));
                    review.put("reviewDate", rs.getDate("review_date"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    
}
