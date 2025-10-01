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

@WebServlet("/admin/reviews")
public class ReviewModerationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            if (userId == null) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }

            List<Admin.PendingReview> reviewList = new Admin(userId, email).getPendingReviews();
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

        Integer userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        boolean success = false;
        String message = "";

        try {
            if (userId == null) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }
            Admin admin = new Admin(userId, (String) session.getAttribute("email"));

            if ("approve".equals(action)) {
                success = admin.approveReview(reviewId);
                message = success ? "Review approved successfully." : "Failed to approve review.";
            } else if ("delete".equals(action)) {
                success = admin.deleteReview(reviewId);
                message = success ? "Review deleted successfully." : "Failed to delete review.";
            }
            
            session.setAttribute("message", message);
            session.setAttribute("messageClass", success ? "alert-success" : "alert-danger");

        } catch (SQLException e) {
            session.setAttribute("message", "Database Error: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        } catch (Exception e) {
            session.setAttribute("message", "An unexpected error occurred: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}