
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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/patient/appointments")
public class AppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AppointmentServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        List<Map<String, Object>> appointments = new ArrayList<>();
        int totalAppointments = 0;
        int pendingAppointments = 0;
        int completedAppointments = 0;
        int cancelledAppointments = 0;
        String nextAppointmentDate = "No upcoming appointments";
        String favoriteDoctor = "N/A";

        try (Connection con = DbConnector.getConnection()) {
            String sql = "SELECT * FROM v_appointment_details WHERE user_id = ? ORDER BY appointment_date DESC, appointment_time DESC";

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, userId);
                try (ResultSet rs = pst.executeQuery()) {
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime nextAppt = null;
                    Map<String, Integer> doctorVisitCount = new HashMap<>();

                    while (rs.next()) {
                        Map<String, Object> row = new HashMap<>();
                        row.put("appointmentId", rs.getInt("appointment_id"));
                        String doctorName = rs.getString("doctor_name");
                        row.put("doctorName", doctorName);
                        row.put("specialty", rs.getString("specialty_name"));
                        row.put("appointmentDate", rs.getString("appointment_date"));
                        row.put("appointmentTime", rs.getString("appointment_time"));
                        String status = rs.getString("appointment_status");
                        row.put("status", status);

                        // Calculate canCancel and canReschedule flags
                        boolean canCancel = false;
                        boolean canReschedule = false;
                        try {
                            LocalDate apptDate = LocalDate.parse(rs.getString("appointment_date"));
                            LocalTime apptTime = LocalTime.parse(rs.getString("appointment_time"));
                            LocalDateTime apptDT = LocalDateTime.of(apptDate, apptTime);
                            canCancel = ("Scheduled".equalsIgnoreCase(status)) && apptDT.isAfter(now.plusDays(1));
                            canReschedule = ("Scheduled".equalsIgnoreCase(status)) && apptDT.isAfter(now.plusHours(24));
                        } catch(Exception ignore) {}
                        row.put("canCancel", canCancel);
                        row.put("canReschedule", canReschedule);

                        // Doctor initial
                        String doctorInitial = (doctorName != null && !doctorName.isEmpty()) ? String.valueOf(doctorName.charAt(0)).toUpperCase() : "D";
                        row.put("doctorInitial", doctorInitial);

                        appointments.add(row);

                        totalAppointments++;
                        if ("Scheduled".equalsIgnoreCase(status)) pendingAppointments++;
                        else if ("Completed".equalsIgnoreCase(status)) completedAppointments++;
                        else if ("Cancelled".equalsIgnoreCase(status)) cancelledAppointments++;

                        doctorVisitCount.put(doctorName, doctorVisitCount.getOrDefault(doctorName, 0) + 1);

                        try {
                            LocalDate apptDate = LocalDate.parse(rs.getString("appointment_date"));
                            LocalTime apptTime = LocalTime.parse(rs.getString("appointment_time"));
                            LocalDateTime apptDT = LocalDateTime.of(apptDate, apptTime);
                            if (apptDT.isAfter(now) && "Scheduled".equalsIgnoreCase(status)) {
                                if (nextAppt == null || apptDT.isBefore(nextAppt)) {
                                    nextAppt = apptDT;
                                }
                            }
                        } catch (Exception ignore) {}
                    }

                    if (nextAppt != null) {
                        nextAppointmentDate = nextAppt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' hh:mm a"));
                    }

                    if (!doctorVisitCount.isEmpty()) {
                        favoriteDoctor = doctorVisitCount.entrySet().stream()
                            .max(Map.Entry.comparingByValue())
                            .get().getKey();
                    }
                }
            }

            request.setAttribute("appointments", appointments);
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("pendingAppointments", pendingAppointments);
            request.setAttribute("completedAppointments", completedAppointments);
            request.setAttribute("cancelledAppointments", cancelledAppointments);
            request.setAttribute("nextAppointmentDate", nextAppointmentDate);
            request.setAttribute("favoriteDoctor", favoriteDoctor);

            request.getRequestDispatcher("/PATIENT/view_appointment.jsp").forward(request, response);

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in AppointmentServlet", e);
            throw new ServletException("Database error", e);
        }
    }
}
