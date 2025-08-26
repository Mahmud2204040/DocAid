package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import classes.DbConnector;

@WebServlet("/api/doctor-schedule")
public class GetDoctorScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String doctorIdStr = request.getParameter("id");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required.");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdStr);

        try (Connection con = DbConnector.getConnection()) {
            List<Map<String, Object>> schedule = DoctorService.getDoctorSchedule(con, doctorId);
            String scheduleJson = DoctorService.scheduleToJson(schedule);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(scheduleJson);
            out.flush();

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching doctor schedule.", e);
        }
    }
}