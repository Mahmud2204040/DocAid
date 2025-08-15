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

@WebServlet("/hospital/feedback")
public class HospitalFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object hospitalIdAttr = session.getAttribute("hospital_id");
        if (hospitalIdAttr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User session is missing 'hospital_id'. Please ensure the login process sets this attribute.");
            return;
        }

        try {
            int hospitalId = (Integer) hospitalIdAttr;
            int userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            Hospital hospital = new Hospital(hospitalId, userId, email);
            List<Hospital.PatientFeedback> feedback = hospital.getFullPatientFeedback();

            request.setAttribute("feedbackList", feedback);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/feedback.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching patient feedback.", e);
        } catch (Exception e) {
            throw new ServletException("An error occurred. Please ensure you are logged in correctly.", e);
        }
    }
}
