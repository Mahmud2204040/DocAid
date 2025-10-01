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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("user_role");
        if (!"Admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");
            int adminId = userId;

            if (adminId == -1) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }

            Admin admin = new Admin(adminId, email);
            
            // Fetch dashboard analytics
            Admin.DashboardAnalytics analytics = admin.getDashboardAnalytics();
            request.setAttribute("analytics", analytics);

            // Fetch recent activity
            List<Admin.UserDetails> recentActivityList = admin.getRecentActivity();
            request.setAttribute("recentActivityList", recentActivityList);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/index.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching dashboard analytics.", e);
        }
    }
}