
package classes;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/patient/past-visits")
public class PastVisitsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(PastVisitsServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        List<Map<String, Object>> pastVisits = new ArrayList<>();
        int totalVisits = 0;
        String mostVisitedSpecialty = "N/A";
        String lastVisitDate = "N/A";

        try (Connection con = DbConnector.getConnection()) {
            int patientId = userId;
            Set<Integer> reviewedDoctorIds = getReviewedDoctorIds(con, patientId);

            String sql = "SELECT * FROM v_appointment_details WHERE user_id = ? AND appointment_status = 'Completed' ORDER BY appointment_date DESC, appointment_time DESC";

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, userId);
                try (ResultSet rs = pst.executeQuery()) {
                    Map<String, Integer> specialtyCount = new HashMap<>();

                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        int doctorId = rs.getInt("doctor_id");
                        row.put("doctorId", doctorId);
                        String doctorName = rs.getString("doctor_name");
                        row.put("doctorName", doctorName);
                        String specialty = rs.getString("specialty_name");
                        row.put("specialty", specialty);
                        row.put("appointmentDate", rs.getString("appointment_date"));
                        row.put("appointmentTime", rs.getString("appointment_time"));
                        row.put("status", rs.getString("appointment_status"));
                        row.put("hasReviewed", reviewedDoctorIds.contains(doctorId));

                        String doctorInitial = (doctorName != null && !doctorName.isEmpty()) ? String.valueOf(doctorName.charAt(0)).toUpperCase() : "D";
                        row.put("doctorInitial", doctorInitial);

                        try {
                            String timeStr = rs.getString("appointment_time");
                            LocalTime apptTime = LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("HH:mm:ss"));
                            row.put("appointmentTimeFormatted", apptTime.format(DateTimeFormatter.ofPattern("hh:mm a")));
                        } catch (Exception e) {
                            row.put("appointmentTimeFormatted", "N/A");
                        }

                        pastVisits.add(row);

                        specialtyCount.put(specialty, specialtyCount.getOrDefault(specialty, 0) + 1);
                        if (totalVisits == 0) {
                            lastVisitDate = rs.getString("appointment_date");
                        }
                        totalVisits++;
                    }

                    if (!specialtyCount.isEmpty()) {
                        mostVisitedSpecialty = specialtyCount.entrySet().stream()
                            .max(Map.Entry.comparingByValue())
                            .get().getKey();
                    }
                }
            }

            request.setAttribute("pastVisits", pastVisits);
            request.setAttribute("totalVisits", totalVisits);
            request.setAttribute("mostVisitedSpecialty", mostVisitedSpecialty);
            request.setAttribute("lastVisitDate", lastVisitDate);

            request.getRequestDispatcher("/PATIENT/past_visits.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in PastVisitsServlet", e);
            throw new ServletException("Database error", e);
        }
    }



    private Set<Integer> getReviewedDoctorIds(Connection con, int patientId) throws SQLException {
        Set<Integer> reviewedDoctorIds = new HashSet<>();
        String sql = "SELECT doctor_id FROM Reviews WHERE patient_id = ?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, patientId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    reviewedDoctorIds.add(rs.getInt("doctor_id"));
                }
            }
        }
        return reviewedDoctorIds;
    }
}
