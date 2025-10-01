
package classes;

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

@WebServlet("/patient/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(UpdateProfileServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        try (Connection con = DbConnector.getConnection()) {
            Patient patient = new Patient();
            patient.setId(userId);
            try {
                patient.loadFromDatabase(con);
                User user = new User();
                user.loadFromDatabase(con, userId);
                patient.setEmail(user.getEmail());

                try (PreparedStatement pst = con.prepareStatement("SELECT contact_no FROM User_Contact WHERE user_id = ? AND contact_type = 'Primary' LIMIT 1")) {
                    pst.setInt(1, userId);
                    try (ResultSet rs = pst.executeQuery()) {
                        if (rs.next()) {
                            patient.setPhone(rs.getString("contact_no"));
                        }
                    }
                }
            } catch (SQLException e) {
                // It's okay if patient record doesn't exist yet, we can create it on update
                logger.log(Level.INFO, "No existing patient record for user_id: " + userId + ". A new one will be created on update.");
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/PATIENT/update_profile.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in UpdateProfileServlet doGet", e);
            throw new ServletException("Database error", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String bloodGroup = request.getParameter("bloodGroup");

        try (Connection con = DbConnector.getConnection()) {
            con.setAutoCommit(false);

            // Update Users table
            try (PreparedStatement pst = con.prepareStatement("UPDATE Users SET email = ? WHERE user_id = ?")) {
                pst.setString(1, email);
                pst.setInt(2, userId);
                pst.executeUpdate();
            }

            // Upsert Patient table
            try (PreparedStatement pst = con.prepareStatement(
                "INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE first_name = VALUES(first_name), last_name = VALUES(last_name), " +
                "gender = VALUES(gender), date_of_birth = VALUES(date_of_birth), blood_type = VALUES(blood_type), address = VALUES(address)")) {
                pst.setInt(1, userId);
                pst.setString(2, firstName);
                pst.setString(3, lastName);
                pst.setString(4, gender);
                pst.setDate(5, (dob != null && !dob.isEmpty()) ? java.sql.Date.valueOf(dob) : null);
                pst.setString(6, bloodGroup);
                pst.setString(7, address);
                pst.executeUpdate();
            }

            // Upsert User_Contact table for Primary contact
            upsertContact(con, userId, phone, "Primary");

            con.commit();
            session.setAttribute("updateStatus", "success");
            session.setAttribute("updateMessage", "Profile updated successfully!");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error during profile update", e);
            session.setAttribute("updateStatus", "error");
            session.setAttribute("updateMessage", "A database error occurred: " + e.getMessage());
        } finally {
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        }
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
