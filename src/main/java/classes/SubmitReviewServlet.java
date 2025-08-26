package classes;

import classes.DbConnector;
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
import java.time.LocalDate;

@WebServlet("/patient/submit-review")
public class SubmitReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int doctorId = -1; // Declare doctorId here
        try {
            doctorId = Integer.parseInt(request.getParameter("doctorId")); // Assign value
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            int userId = (Integer) session.getAttribute("user_id");

            try (Connection con = DbConnector.getConnection()) {
                int patientId = getPatientIdFromUserId(con, userId);

                if (patientId != -1) {
                    String sql = "INSERT INTO Reviews (patient_id, doctor_id, rating, comment, review_date, is_moderated) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement pst = con.prepareStatement(sql)) {
                        pst.setInt(1, patientId);
                        pst.setInt(2, doctorId);
                        pst.setInt(3, rating);
                        pst.setString(4, comment);
                        pst.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
                        pst.setBoolean(6, false); // a new review is not moderated yet
                        pst.executeUpdate();
                    }
                }
            }

            session.setAttribute("reviewSuccess", "Your review has been submitted successfully!");
            response.sendRedirect(request.getContextPath() + "/patient/past-visits");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input.");
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            // Catch specific exception for duplicate review
            session.setAttribute("reviewError", "You have already submitted a review for this doctor. You can only submit one review per doctor.");
            response.sendRedirect(request.getContextPath() + "/PATIENT/give_review.jsp?doctorId=" + doctorId + "&doctorName=" + request.getParameter("doctorName"));
        } catch (SQLException e) {
            throw new ServletException("Database error while submitting review.", e);
        }
    }

    private int getPatientIdFromUserId(Connection con, int userId) throws SQLException {
        String sql = "SELECT patient_id FROM Patient WHERE user_id = ?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("patient_id");
                }
            }
        }
        return -1;
    }
}
