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

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userTypeFilter = request.getParameter("userType");
        try {
            Integer userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            if (userId == null) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }

            List<Admin.UserDetails> userList = new Admin(userId, email).getAllUsers(userTypeFilter);
            request.setAttribute("userList", userList);
            request.setAttribute("currentUserType", userTypeFilter);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/users.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching user list.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                Integer userIdFromSession = (Integer) session.getAttribute("user_id");
                String email = (String) session.getAttribute("email");

                if (userIdFromSession == null) {
                    throw new ServletException("Admin ID not found for the logged-in user.");
                }

                Admin admin = new Admin(userIdFromSession, email);

                int userId = Integer.parseInt(request.getParameter("userId"));
                admin.deleteUser(userId);
                session.setAttribute("message", "User successfully deleted.");
                session.setAttribute("messageClass", "alert-success");
            } catch (Exception e) {
                session.setAttribute("message", "Error during user deletion.");
                session.setAttribute("messageClass", "alert-danger");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private boolean isAdmin(HttpSession session) {
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}