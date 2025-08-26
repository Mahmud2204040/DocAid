package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DoctorService {

    public static List<Map<String, Object>> getDoctorSchedule(Connection con, int doctorId) throws SQLException {
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

    public static String scheduleToJson(List<Map<String, Object>> schedule) {
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
        return json.toString();
    }
}
