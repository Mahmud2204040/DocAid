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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/hospital/find-doctor")
public class HospitalDoctorSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Hospital.AvailableDoctor> searchResults = new ArrayList<>();
        String searchTerm = request.getParameter("search_term");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            try {
                int hospitalId = (Integer) session.getAttribute("hospital_id");
                Hospital hospital = new Hospital();
                hospital.setHospitalId(hospitalId);
                searchResults = hospital.searchAvailableDoctors(searchTerm.trim());
            } catch (SQLException e) {
                throw new ServletException("Database error while searching for doctors.", e);
            }
        }

        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchTerm", searchTerm);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/find_doctor.jsp");
        dispatcher.forward(request, response);
    }
}
