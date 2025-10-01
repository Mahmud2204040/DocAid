package classes;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/hospital/appointments")
public class HospitalAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            Hospital hospital = new Hospital(userId, email);
            List<Hospital.AppointmentDetail> appointments = hospital.getAppointments();

            request.setAttribute("appointmentList", appointments);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/appointments.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching appointments.", e);
        } catch (Exception e) {
            throw new ServletException("An error occurred. Please ensure you are logged in correctly.", e);
        }
    }
}
