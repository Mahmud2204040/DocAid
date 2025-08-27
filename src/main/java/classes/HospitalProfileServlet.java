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
import java.util.List;

@WebServlet("/patient/hospital_profile")
public class HospitalProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String hospitalIdStr = request.getParameter("id");
        if (hospitalIdStr == null || hospitalIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hospital ID is required.");
            return;
        }

        int hospitalId = Integer.parseInt(hospitalIdStr);

        try (Connection con = DbConnector.getConnection()) {
            Hospital hospital = new Hospital();
            hospital.setHospitalId(hospitalId);
            hospital.loadDetails();

            if (hospital.getHospitalName() == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Hospital not found.");
                return;
            }

            List<Hospital.MedicalTestRecord> medicalTests = hospital.getMedicalTests();

            request.setAttribute("hospital", hospital);
            request.setAttribute("medicalTests", medicalTests);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/PATIENT/hospital_profile.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching hospital profile.", e);
        }
    }
}