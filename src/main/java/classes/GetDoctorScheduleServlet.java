package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/patient/get-doctor-schedule")
public class GetDoctorScheduleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String doctorIdStr = request.getParameter("doctorId");
        if (doctorIdStr == null || doctorIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Doctor ID is required.");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdStr);

        try (Connection con = DbConnector.getConnection()) {
            List<Map<String, Object>> schedule = getDoctorSchedule(con, doctorId);
            
            // Manual JSON serialization
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < schedule.size(); i++) {
                Map<String, Object> slot = schedule.get(i);
                json.append("{");
                json.append("\"day\":\"").append(slot.get("day")).append("\",");
                json.append("\"startTime\":\"").append(slot.get("startTime")).append("\",");
                json.append("\"endTime\":\"").append(slot.get("endTime")).append("\"");
                json.append("}");
                if (i < schedule.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching doctor schedule.", e);
        }
    }

    private static List<Map<String, Object>> getDoctorSchedule(Connection con, int doctorId) throws SQLException {
        List<Map<String, Object>> schedule = new ArrayList<>();
        String sql = "SELECT * FROM Doctor_schedule WHERE doctor_id = ? AND is_available = TRUE ORDER BY FIELD(visiting_day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, doctorId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> slot = new HashMap<>();
                    slot.put("day", rs.getString("visiting_day"));
                    slot.put("startTime", rs.getTime("start_time").toString());
                    slot.put("endTime", rs.getTime("end_time").toString());
                    schedule.add(slot);
                }
            }
        }
        return schedule;
    }
}
