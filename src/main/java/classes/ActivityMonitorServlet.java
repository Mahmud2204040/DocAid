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

@WebServlet("/admin/monitoring")
public class ActivityMonitorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Admin.ActiveMonitor> monitorList = Admin.getActiveMonitors();
            request.setAttribute("monitorList", monitorList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/monitoring.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error fetching active monitors.", e);
        }
    }

        @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        boolean success = false;
        String message = "";

        try (Connection conn = DbConnector.getConnection()) {
            // Get the admin_id from the user_id
            int adminId = -1;
            try (PreparedStatement pstmt = conn.prepareStatement("SELECT admin_id FROM Admin WHERE user_id = ?")) {
                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        adminId = rs.getInt("admin_id");
                    }
                }
            }

            if (adminId == -1) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }

            Admin admin = new Admin(adminId, userId, (String) session.getAttribute("email")); // Use fetched adminId

            if ("start".equals(action)) {
                int monitoredUserId = Integer.parseInt(request.getParameter("userId"));
                String reason = request.getParameter("reason");

                // Check if the user to be monitored exists
                if (!Admin.userExists(monitoredUserId)) {
                    session.setAttribute("message", "Error: User ID " + monitoredUserId + " does not exist.");
                    session.setAttribute("messageClass", "alert-danger");
                    response.sendRedirect(request.getContextPath() + "/admin/monitoring");
                    return;
                }

                success = admin.startMonitoring(monitoredUserId, reason);
                message = success ? "Monitoring session started successfully." : "Failed to start monitoring session.";
            } else if ("stop".equals(action)) {
                int monitorId = Integer.parseInt(request.getParameter("monitorId"));
                success = admin.stopMonitoring(monitorId);
                message = success ? "Monitoring session stopped successfully." : "Failed to stop monitoring session.";
            }
            
            session.setAttribute("message", message);
            session.setAttribute("messageClass", success ? "alert-success" : "alert-danger");

        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid User ID or Monitor ID format.");
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        } catch (SQLException e) {
            session.setAttribute("message", "Database Error: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        } catch (Exception e) { // Catch any other unexpected exceptions
            session.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/monitoring");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}