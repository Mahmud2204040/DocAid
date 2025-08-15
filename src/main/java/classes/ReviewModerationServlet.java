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

@WebServlet("/admin/reviews")
public class ReviewModerationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Admin.PendingReview> reviewList = new Admin(1,1,"dummy").getPendingReviews();
            request.setAttribute("reviewList", reviewList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/reviews.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error fetching reviews.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // We need the admin's ID for logging the approval
        // This requires a query, or it should be stored in the session upon login.
        // For now, we will omit fetching the specific admin_id for simplicity.
        int adminId = 1; // Placeholder adminId

        String action = request.getParameter("action");
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));

        try {
            if ("approve".equals(action)) {
                new Admin(adminId,1,"dummy").approveReview(reviewId);
            } else if ("delete".equals(action)) {
                new Admin(adminId,1,"dummy").deleteReview(reviewId);
            }
        } catch (SQLException e) {
            // handle exception
        }
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}