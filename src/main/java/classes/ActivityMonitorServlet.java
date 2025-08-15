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
            List<Admin.ActiveMonitor> monitorList = new Admin(1,1,"dummy").getActiveMonitors();
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
        
        // This is a placeholder. In a real app, you'd get the admin_id associated with the user_id
        int adminId = 1; 

        String action = request.getParameter("action");

        try {
            if ("start".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String reason = request.getParameter("reason");
                new Admin(adminId,1,"dummy").startMonitoring(userId, reason);
            } else if ("stop".equals(action)) {
                int monitorId = Integer.parseInt(request.getParameter("monitorId"));
                new Admin(adminId,1,"dummy").stopMonitoring(monitorId);
            }
        } catch (Exception e) {
            // handle error
        }

        response.sendRedirect(request.getContextPath() + "/admin/monitoring");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}