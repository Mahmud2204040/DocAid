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

@WebServlet("/hospital/profile")
public class HospitalProfileServlet extends HttpServlet {
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User session is missing 'hospital_id'.");
            return;
        }

        try {
            int hospitalId = (Integer) hospitalIdAttr;
            Hospital hospital = new Hospital();
            hospital.setHospitalId(hospitalId);
            hospital.loadDetails(); // Fetch details from DB

            request.setAttribute("hospital", hospital);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/update_profile.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching hospital profile.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object hospitalIdAttr = session.getAttribute("hospital_id");
        if (hospitalIdAttr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User session is missing 'hospital_id'.");
            return;
        }

        try {
            int hospitalId = (Integer) hospitalIdAttr;
            Hospital hospital = new Hospital();
            hospital.setHospitalId(hospitalId);
            
            // Populate hospital object from form parameters
            hospital.setHospitalName(request.getParameter("hospital_name"));
            hospital.setHospitalBio(request.getParameter("hospital_bio"));
            hospital.setAddress(request.getParameter("address"));
            hospital.setWebsite(request.getParameter("website"));

            if (hospital.updateDetails()) {
                session.setAttribute("message", "Profile updated successfully!");
                session.setAttribute("messageClass", "alert-success");
            } else {
                session.setAttribute("message", "Failed to update profile.");
                session.setAttribute("messageClass", "alert-danger");
            }
            response.sendRedirect(request.getContextPath() + "/hospital/profile");

        } catch (SQLException e) {
            throw new ServletException("Database error while updating hospital profile.", e);
        }
    }
}
