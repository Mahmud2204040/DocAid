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

@WebServlet("/hospital/dashboard")
public class HospitalDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Basic authentication and authorization checks
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("user_role");
        if (!"Hospital".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            Hospital hospital = new Hospital(userId, email);
            Hospital.DashboardAnalytics analytics = hospital.getDashboardAnalytics();
            
            request.setAttribute("analytics", analytics);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/index.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            // In a real app, log this error properly
            e.printStackTrace();
            throw new ServletException("Database error while fetching hospital dashboard analytics.", e);
        } catch (Exception e) {
            // Catch potential NullPointerException if hospital_id is not in session
            e.printStackTrace();
            throw new ServletException("An error occurred. Please ensure you are logged in correctly.", e);
        }
    }
}
