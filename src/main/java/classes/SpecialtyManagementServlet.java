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

@WebServlet("/admin/specialties")
public class SpecialtyManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            HttpSession session = request.getSession(false);
            Integer userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            if (userId == null) {
                throw new ServletException("Admin ID not found for the logged-in user.");
            }

            List<Admin.Specialty> specialtyList = new Admin(userId, email).getAllSpecialties();
            request.setAttribute("specialtyList", specialtyList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/specialties.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error fetching specialties.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request.getSession(false))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Integer userId = (Integer) session.getAttribute("user_id");
        String email = (String) session.getAttribute("email");

        if (userId == null) {
            throw new ServletException("Admin ID not found for the logged-in user.");
        }

        Admin admin = new Admin(userId, email);

        try { // New try block for specialty management operations
            switch (action) {
                case "add":
                    admin.createSpecialty(request.getParameter("specialtyName"));
                    break;
                case "update":
                    int specialtyIdUpdate = Integer.parseInt(request.getParameter("specialtyId"));
                    String newSpecialtyName = request.getParameter("newSpecialtyName");
                    admin.updateSpecialty(specialtyIdUpdate, newSpecialtyName);
                    break;
                case "delete":
                    int specialtyIdDelete = Integer.parseInt(request.getParameter("specialtyId"));
                    admin.deleteSpecialty(specialtyIdDelete);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error during specialty management operation.", e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid specialty ID format.", e);
        } catch (Exception e) {
            throw new ServletException("An unexpected error occurred during specialty management.", e);
        }
        response.sendRedirect(request.getContextPath() + "/admin/specialties");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}