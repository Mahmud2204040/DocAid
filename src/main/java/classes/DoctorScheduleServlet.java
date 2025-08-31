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
            int doctorId = getDoctorId(conn, userId);

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
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        try (Connection conn = DbConnector.getConnection()) {
            int doctorId = getDoctorId(conn, userId);
            if (doctorId != -1) {
                String sql = "INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, doctorId);
                    pstmt.setString(2, day);
                    pstmt.setString(3, startTime);
                    pstmt.setString(4, endTime);
                    pstmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error adding schedule slot.", e);
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }

    private int getDoctorId(Connection conn, int userId) throws SQLException {
        int doctorId = -1;
        String getDoctorIdSql = "SELECT doctor_id FROM Doctor WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(getDoctorIdSql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    doctorId = rs.getInt("doctor_id");
                }
            }
        }
        return doctorId;
    }
}
