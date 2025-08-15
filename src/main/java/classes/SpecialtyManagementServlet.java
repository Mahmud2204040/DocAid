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
            List<Admin.Specialty> specialtyList = new Admin(1,1,"dummy").getAllSpecialties();
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

        try {
            switch (action) {
                case "add":
                    new Admin(1,1,"dummy").createSpecialty(request.getParameter("specialtyName"));
                    break;
                case "update":
                    int specialtyIdUpdate = Integer.parseInt(request.getParameter("specialtyId"));
                    String newSpecialtyName = request.getParameter("newSpecialtyName");
                    new Admin(1,1,"dummy").updateSpecialty(specialtyIdUpdate, newSpecialtyName);
                    break;
                case "delete":
                    int specialtyIdDelete = Integer.parseInt(request.getParameter("specialtyId"));
                    new Admin(1,1,"dummy").deleteSpecialty(specialtyIdDelete);
                    break;
            }
        } catch (Exception e) {
            // handle error
        }
        response.sendRedirect(request.getContextPath() + "/admin/specialties");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "Admin".equals(role);
    }
}