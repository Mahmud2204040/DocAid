package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/hospital/send-request")
public class AffiliationRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int hospitalId = (Integer) session.getAttribute("hospital_id");
            int doctorId = Integer.parseInt(request.getParameter("doctor_id"));

            Hospital hospital = new Hospital();
            hospital.setHospitalId(hospitalId);

            String resultMessage = hospital.sendAffiliationRequest(doctorId);

            session.setAttribute("message", resultMessage);
            if (resultMessage.contains("successfully")) {
                session.setAttribute("messageClass", "alert-success");
            } else if (resultMessage.contains("pending")) {
                session.setAttribute("messageClass", "alert-warning");
            } else {
                session.setAttribute("messageClass", "alert-danger");
            }

        } catch (SQLException e) {
            session.setAttribute("message", "Database Error: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid Doctor ID.");
            session.setAttribute("messageClass", "alert-danger");
        }

        // Redirect back to the search page, preserving the last search term if possible
        String searchTerm = request.getParameter("search_term");
        String redirectUrl = request.getContextPath() + "/hospital/find-doctor";
        if (searchTerm != null && !searchTerm.isEmpty()) {
            redirectUrl += "?search_term=" + java.net.URLEncoder.encode(searchTerm, "UTF-8");
        }
        response.sendRedirect(redirectUrl);
    }
}
