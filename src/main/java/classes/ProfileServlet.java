
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

@WebServlet("/patient/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        logger.log(Level.INFO, "ProfileServlet started for user_id: " + userId);

        try (Connection con = DbConnector.getConnection()) {
            // Fetch patient data using the Patient class
            Patient patient = new Patient();
            patient.setId(userId);
            try {
                patient.loadFromDatabase(con);
                logger.log(Level.INFO, "Patient data loaded for user_id: " + userId);
            } catch (SQLException e) {
                logger.log(Level.INFO, "No existing patient record for user_id: " + userId + ". Creating a default patient object.");
                patient.setFirstName("New");
                patient.setLastName("User");
                patient.setAddress("Not specified");
                patient.setBloodType("Not specified");
                patient.setGender("Other");
                patient.setDateOfBirth(new java.sql.Date(System.currentTimeMillis()));
            }

            // Fetch other details not in the Patient object
            User user = new User();
            user.loadFromDatabase(con, userId);
            patient.setEmail(user.getEmail());
            logger.log(Level.INFO, "User email loaded: " + patient.getEmail());

            // Fetch contact number
            try (PreparedStatement pst = con.prepareStatement("SELECT contact_no FROM User_Contact WHERE user_id = ? AND contact_type = 'Primary' LIMIT 1")) {
                pst.setInt(1, userId);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        patient.setPhone(rs.getString("contact_no"));
                        logger.log(Level.INFO, "User phone loaded: " + patient.getPhone());
                    }
                }
            }

            // Fetch appointment statistics
            try (PreparedStatement pst = con.prepareStatement(
                "SELECT COUNT(*) as total, " +
                "SUM(CASE WHEN appointment_status = 'Completed' THEN 1 ELSE 0 END) as completed, " +
                "MAX(appointment_date) as last_visit " +
                "FROM Appointment WHERE patient_id = ?"
            )) {
                pst.setInt(1, userId);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("totalAppointments", rs.getInt("total"));
                        request.setAttribute("completedVisits", rs.getInt("completed"));
                        java.sql.Date lastVisit = rs.getDate("last_visit");
                        request.setAttribute("lastVisitDate", (lastVisit != null) ? lastVisit.toString() : "No visits yet");
                        logger.log(Level.INFO, "Appointment stats loaded.");
                    }
                }
            }

            request.setAttribute("patient", patient);
            logger.log(Level.INFO, "Forwarding to JSP with patient object: " + patient);
            request.getRequestDispatcher("/PATIENT/my_profile.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in ProfileServlet", e);
            throw new ServletException("Database error", e);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error in ProfileServlet", e);
            throw new ServletException("An unexpected error occurred", e);
        }
    }
}
