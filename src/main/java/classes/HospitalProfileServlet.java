
package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/patient/hospital_profile")
public class HospitalProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hospitalIdStr = request.getParameter("hospital_id");
        if (hospitalIdStr == null || hospitalIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hospital ID is required.");
            return;
        }

        // Get user role from session
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String viewerRole = (session != null) ? (String) session.getAttribute("user_type") : null;

        try (Connection con = DbConnector.getConnection()) {
            int hospitalId = Integer.parseInt(hospitalIdStr);
            
            Hospital hospital = Hospital.getHospitalById(con, hospitalId);

            if (hospital == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Hospital not found.");
                return;
            }

            // If the viewer is a Doctor, hide the emergency contact
            if ("Doctor".equals(viewerRole)) {
                hospital.setEmergencyContact(null);
            }

            // Fetch medical tests and add to request
            java.util.List<classes.Hospital.MedicalTestRecord> medicalTests = hospital.getMedicalTestsActiveOnly();
            request.setAttribute("medicalTests", medicalTests);
            
            request.setAttribute("hospital", hospital);
            request.getRequestDispatcher("/PATIENT/hospital_profile.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Hospital ID format.");
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching hospital details.", e);
        }
    }
}
