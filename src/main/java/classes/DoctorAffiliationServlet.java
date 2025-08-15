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

@WebServlet("/doctor/affiliation")
public class DoctorAffiliationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles displaying the page with pending requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Doctor".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            Doctor doctor = new Doctor();
            doctor.setId(userId);

            // We need the doctor_id to fetch requests
            try (Connection conn = DbConnector.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("SELECT doctor_id FROM Doctor WHERE user_id = ?")) {
                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        doctor.setDoctorId(rs.getInt("doctor_id"));
                    }
                }
            }

            List<Doctor.AffiliationRequestDetails> requests = doctor.getPendingAffiliationRequests();
            request.setAttribute("requestList", requests);

        } catch (SQLException e) {
            throw new ServletException("Database error fetching affiliation requests.", e);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/affiliation_requests.jsp");
        dispatcher.forward(request, response);
    }

    // Handles all actions: approve, deny, remove
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Doctor".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirectPage = "/doctor/affiliation"; // Default redirect

        try {
            int userId = (Integer) session.getAttribute("user_id");
            Doctor doctor = new Doctor();
            doctor.setId(userId);
            
            // Get doctor_id for operations
            try (Connection conn = DbConnector.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement("SELECT doctor_id FROM Doctor WHERE user_id = ?")) {
                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        doctor.setDoctorId(rs.getInt("doctor_id"));
                    }
                }
            }

            boolean success = false;
            String message = "";

            if ("respond".equals(action)) {
                int requestId = Integer.parseInt(request.getParameter("request_id"));
                String responseStatus = request.getParameter("response"); // "Approved" or "Denied"
                success = doctor.respondToAffiliationRequest(requestId, responseStatus);
                message = "Request has been " + responseStatus.toLowerCase() + ".";
            } else if ("remove".equals(action)) {
                success = doctor.removeAffiliation();
                message = "Hospital affiliation removed successfully.";
                redirectPage = "/doctor/profile"; // Redirect to profile after removal
            }

            session.setAttribute("message", message);
            session.setAttribute("messageClass", success ? "alert-success" : "alert-danger");

        } catch (SQLException e) {
            session.setAttribute("message", "Database Error: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
        } catch (Exception e) {
            session.setAttribute("message", "An error occurred: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
        }

        response.sendRedirect(request.getContextPath() + redirectPage);
    }
}
