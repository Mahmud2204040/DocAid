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
import java.util.List;

/**
 * Servlet to handle viewing and managing appointments for a logged-in doctor.
 */
@WebServlet("/doctor/appointments")
public class DoctorAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        List<AppointmentDetails> appointments = new ArrayList<>();
        int totalAppointments = 0, pendingAppointments = 0, approvedAppointments = 0, cancelledAppointments = 0;

        try (Connection conn = DbConnector.getConnection()) {
            // First, get the doctor_id from the user_id
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

            if (doctorId != -1) {
                // Now, get the appointments for that doctor_id
                String getAppointmentsSql = "SELECT a.appointment_id, a.appointment_date, a.appointment_time, a.appointment_status, " +
                                            "p.first_name, p.last_name " +
                                            "FROM Appointment a JOIN Patient p ON a.patient_id = p.patient_id " +
                                            "WHERE a.doctor_id = ? ORDER BY a.appointment_date DESC, a.appointment_time ASC";
                try (PreparedStatement pstmt = conn.prepareStatement(getAppointmentsSql)) {
                    pstmt.setInt(1, doctorId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            String status = rs.getString("appointment_status");
                            appointments.add(new AppointmentDetails(
                                rs.getInt("appointment_id"),
                                rs.getString("first_name") + " " + rs.getString("last_name"),
                                "", // specialty - not needed for this view
                                "", // department - not needed for this view
                                rs.getTime("appointment_time").toString(),
                                rs.getDate("appointment_date").toString(),
                                status
                            ));
                            
                            totalAppointments++;
                            if ("Scheduled".equalsIgnoreCase(status)) pendingAppointments++;
                            if ("Confirmed".equalsIgnoreCase(status)) approvedAppointments++;
                            if ("Cancelled".equalsIgnoreCase(status)) cancelledAppointments++;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Database error fetching appointments.", e);
        }

        request.setAttribute("appointments", appointments);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("pendingAppointments", pendingAppointments);
        request.setAttribute("approvedAppointments", approvedAppointments);
        request.setAttribute("cancelledAppointments", cancelledAppointments);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/DOCTOR/doctor_view_appointment.jsp");
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

        String action = request.getParameter("action");
        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String newStatus = "";

        if ("confirm".equals(action)) {
            newStatus = "Confirmed";
        } else if ("cancel".equals(action)) {
            newStatus = "Cancelled";
        }

        if (!newStatus.isEmpty()) {
            String sql = "UPDATE Appointment SET appointment_status = ? WHERE appointment_id = ?";
            try (Connection conn = DbConnector.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, newStatus);
                pstmt.setInt(2, appointmentId);
                pstmt.executeUpdate();
            } catch (SQLException e) {
                throw new ServletException("Database error updating appointment status.", e);
            }
        }
        response.sendRedirect(request.getContextPath() + "/doctor/appointments");
    }
}
