package classes;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet to handle fetching and updating a doctor's profile.
 */
@WebServlet("/doctor/update-profile")
public class DoctorUpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // The doGet method is responsible for displaying the form with current data
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        Doctor doctorProfile = new Doctor();

        String sql = "SELECT d.*, uc.contact_no FROM Doctor d LEFT JOIN User_Contact uc ON d.user_id = uc.user_id WHERE d.user_id = ?;";

        try (Connection conn = DbConnector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    doctorProfile.setFirstName(rs.getString("first_name"));
                    doctorProfile.setLastName(rs.getString("last_name"));
                    doctorProfile.setGender(rs.getString("gender"));
                    doctorProfile.setBio(rs.getString("bio"));
                    doctorProfile.setFee(rs.getBigDecimal("fee"));
                    doctorProfile.setAddress(rs.getString("address"));
                    doctorProfile.setPhone(rs.getString("contact_no"));
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching profile for update.", e);
        }

        request.setAttribute("doctorProfile", doctorProfile);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/update_profile.jsp");
        dispatcher.forward(request, response);
    }

    // The doPost method handles the form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("user_role");
        if (!"Doctor".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }
        Integer userId = (Integer) session.getAttribute("user_id");

        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String bio = request.getParameter("bio");
        BigDecimal fee = new BigDecimal(request.getParameter("fee"));
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        Connection conn = null;
        try {
            conn = DbConnector.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update Doctor table
            String sqlDoctor = "UPDATE Doctor SET first_name=?, last_name=?, gender=?, bio=?, fee=?, address=? WHERE user_id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlDoctor)) {
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, gender);
                pstmt.setString(4, bio);
                pstmt.setBigDecimal(5, fee);
                pstmt.setString(6, address);
                pstmt.setInt(7, userId);
                pstmt.executeUpdate();
            }

            // 2. Update User_Contact table (UPSERT logic)
            String sqlContact = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, 'Primary') " +
                                "ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no);";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlContact)) {
                pstmt.setInt(1, userId);
                pstmt.setString(2, phone);
                pstmt.executeUpdate();
            }

            conn.commit(); // Commit transaction
            session.setAttribute("message", "Profile updated successfully!");
            session.setAttribute("messageClass", "alert-success");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            session.setAttribute("message", "Error updating profile: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }

        response.sendRedirect(request.getContextPath() + "/doctor/profile");
    }
}
