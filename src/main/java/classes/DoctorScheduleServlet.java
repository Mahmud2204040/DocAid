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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet to handle managing a doctor's weekly schedule.
 */
@WebServlet("/doctor/schedule")
public class DoctorScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        Map<String, List<String>> scheduleMap = new LinkedHashMap<>();
        String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        for (String day : days) {
            scheduleMap.put(day, new ArrayList<>());
        }

        try (Connection conn = DbConnector.getConnection()) {
            int doctorId = userId;

            if (doctorId != -1) {
                String sql = "SELECT visiting_day, start_time, end_time FROM Doctor_schedule WHERE doctor_id = ? ORDER BY start_time";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, doctorId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            String day = rs.getString("visiting_day");
                            String slot = rs.getTime("start_time").toString() + " - " + rs.getTime("end_time").toString();
                            if (scheduleMap.containsKey(day)) {
                                scheduleMap.get(day).add(slot);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching schedule.", e);
        }

        request.setAttribute("scheduleMap", scheduleMap);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/manage_schedule.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("user_role");
        if (!"Doctor".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You are not authorized to access this page.");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String day = request.getParameter("day");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        try {
            java.time.LocalTime startTime = java.time.LocalTime.parse(startTimeStr);
            java.time.LocalTime endTime = java.time.LocalTime.parse(endTimeStr);

            if (startTime.isAfter(endTime) || startTime.equals(endTime)) {
                session.setAttribute("scheduleError", "Start time must be before end time.");
                response.sendRedirect(request.getContextPath() + "/doctor/schedule");
                return;
            }
        } catch (java.time.format.DateTimeParseException e) {
            session.setAttribute("scheduleError", "Invalid time format. Please use HH:mm.");
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        try (Connection conn = DbConnector.getConnection()) {
            int doctorId = userId;
            if (doctorId != -1) {
                String sql = "INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, doctorId);
                    pstmt.setString(2, day);
                    pstmt.setString(3, startTimeStr);
                    pstmt.setString(4, endTimeStr);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) { // Handle unique constraint violation
                session.setAttribute("scheduleError", "This time slot already exists for the selected day.");
            } else {
                throw new ServletException("Database error adding schedule slot.", e);
            }
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }


}
