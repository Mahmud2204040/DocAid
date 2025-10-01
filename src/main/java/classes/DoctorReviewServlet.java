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
import java.util.List;

/**
 * Servlet to fetch and display a doctor's reviews.
 */
@WebServlet("/doctor/reviews")
public class DoctorReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        Doctor doctor = new Doctor();
        doctor.setId(userId);
        doctor.setDoctorId(userId); // In the new schema, doctor_id is the same as user_id.

        try (Connection conn = DbConnector.getConnection()) {
            // Now, fetch the reviews for this doctor
            List<Doctor.Review> reviewList = doctor.getReviews(conn);
            request.setAttribute("reviewList", reviewList);

        } catch (SQLException e) {
            throw new ServletException("Database error fetching reviews.", e);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/view_review.jsp");
        dispatcher.forward(request, response);
    }
}
