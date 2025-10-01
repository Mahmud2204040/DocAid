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
import java.sql.SQLException;

@WebServlet("/hospital/doctor-profile")
public class HospitalViewDoctorProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Authorization: only hospitals can access this
        if (session == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }

        String doctorIdStr = request.getParameter("doctor_id");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required.");
            return;
        }

        try (Connection con = DbConnector.getConnection()) {
            int doctorId = Integer.parseInt(doctorIdStr);

            // Fetch doctor details, specifying the viewer role is 'Hospital'
            Doctor doctor = Doctor.getDoctorById(con, doctorId, "Hospital");

            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Doctor not found.");
                return;
            }

            // Fetch reviews for the doctor
            java.util.List<classes.Doctor.Review> reviews = doctor.getReviews(con);
            request.setAttribute("reviews", reviews);

            request.setAttribute("doctor", doctor);
            
            // Reuse the patient's view for the doctor profile
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/doctor_profile.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Doctor ID format.");
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching doctor profile.", e);
        }
    }
}
