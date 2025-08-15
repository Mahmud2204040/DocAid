package classes;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet to generate and display reports.
 */
@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Admin admin = new Admin(1, 1, "admin@dmin.com");
        try {
            Admin.AppointmentReport reportData = new Admin(1,1,"dummy").getAppointmentReport();
            request.setAttribute("reportData", reportData);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/ADMIN/reports.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error generating report.", e);
        }
    }
}
