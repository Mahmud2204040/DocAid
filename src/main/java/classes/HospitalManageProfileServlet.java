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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/hospital/profile")
public class HospitalManageProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(HospitalManageProfileServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        Hospital hospital = new Hospital();
        String primaryContact = "";
        String emergencyContact = "";

        String sql = "SELECT h.*, " +
                     "MAX(CASE WHEN uc.contact_type = 'Primary' THEN uc.contact_no END) AS primary_contact, " +
                     "MAX(CASE WHEN uc.contact_type = 'Emergency' THEN uc.contact_no END) AS emergency_contact " +
                     "FROM Hospital h " +
                     "LEFT JOIN User_Contact uc ON h.hospital_id = uc.user_id " +
                     "WHERE h.hospital_id = ? " +
                     "GROUP BY h.hospital_id";

        try (Connection conn = DbConnector.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    hospital.setHospitalId(rs.getInt("hospital_id"));
                    hospital.setHospitalName(rs.getString("hospital_name"));
                    hospital.setWebsite(rs.getString("website"));
                    hospital.setAddress(rs.getString("address"));
                    hospital.setHospitalBio(rs.getString("hospital_bio"));
                    primaryContact = rs.getString("primary_contact");
                    emergencyContact = rs.getString("emergency_contact");
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching hospital profile for update.", e);
        }

        request.setAttribute("hospital", hospital);
        request.setAttribute("primaryContact", primaryContact != null ? primaryContact : "");
        request.setAttribute("emergencyContact", emergencyContact != null ? emergencyContact : "");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/update_profile.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String hospitalName = request.getParameter("hospital_name");
        String website = request.getParameter("website");
        String address = request.getParameter("address");
        String hospitalBio = request.getParameter("hospital_bio");
        String primaryContact = request.getParameter("primary_contact");
        String emergencyContact = request.getParameter("emergency_contact");
        
        Connection conn = null;
        try {
            conn = DbConnector.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Update Hospital table
            String sqlHospital = "UPDATE Hospital SET hospital_name=?, website=?, address=?, hospital_bio=? WHERE hospital_id=?";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlHospital)) {
                pstmt.setString(1, hospitalName);
                pstmt.setString(2, website);
                pstmt.setString(3, address);
                pstmt.setString(4, hospitalBio);
                pstmt.setInt(5, userId);
                pstmt.executeUpdate();
            }

            // 2. Update User_Contact table for Primary contact
            upsertContact(conn, userId, primaryContact, "Primary");

            // 3. Update User_Contact table for Emergency contact
            upsertContact(conn, userId, emergencyContact, "Emergency");

            conn.commit(); // Commit transaction
            session.setAttribute("message", "Profile updated successfully!");
            session.setAttribute("messageClass", "alert-success");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {}
            logger.log(Level.SEVERE, "Database error updating hospital profile", e);
            session.setAttribute("message", "Error updating profile: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }

        response.sendRedirect(request.getContextPath() + "/hospital/profile");
    }

    private void upsertContact(Connection conn, int userId, String contactNo, String contactType) throws SQLException {
        if (contactNo == null || contactNo.trim().isEmpty()) {
            String sqlDelete = "DELETE FROM User_Contact WHERE user_id = ? AND contact_type = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlDelete)) {
                pstmt.setInt(1, userId);
                pstmt.setString(2, contactType);
                pstmt.executeUpdate();
            }
        } else {
            String sqlUpsert = "INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?) " +
                               "ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no)";
            try (PreparedStatement pstmt = conn.prepareStatement(sqlUpsert)) {
                pstmt.setInt(1, userId);
                pstmt.setString(2, contactNo.trim());
                pstmt.setString(3, contactType);
                pstmt.executeUpdate();
            }
        }
    }
}