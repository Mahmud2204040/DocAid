
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
import java.sql.CallableStatement;

@WebServlet("/patient/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String appointmentDate = request.getParameter("appointmentDate");
            String appointmentTime = request.getParameter("appointmentTime");
            int patientId = getPatientIdFromUserId(session, (Integer) session.getAttribute("user_id"));

            if (patientId == -1) {
                // Handle case where patient profile doesn't exist
                session.setAttribute("bookingError", "Please complete your profile before booking an appointment.");
                response.sendRedirect(request.getContextPath() + "/patient/update-profile");
                return;
            }

            try (Connection con = DbConnector.getConnection()) {
                // Final availability check using the stored procedure
                try (CallableStatement cst = con.prepareCall("{CALL CheckDoctorAvailability(?, ?, ?)}")) {
                    cst.setInt(1, doctorId);
                    cst.setDate(2, java.sql.Date.valueOf(appointmentDate));
                    cst.setTime(3, java.sql.Time.valueOf(appointmentTime + ":00"));
                    try (ResultSet rs = cst.executeQuery()) {
                        if (rs.next()) {
                            String status = rs.getString("status");
                            if (!"AVAILABLE".equals(status)) {
                                session.setAttribute("bookingError", "The selected time slot is no longer available. Please choose another time.");
                                response.sendRedirect(request.getContextPath() + "/patient/doctor-profile?id=" + doctorId);
                                return;
                            }
                        }
                    }
                }

                // If available, proceed with booking
                String sql = "INSERT INTO Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) VALUES (?, ?, ?, ?, 'Scheduled')";
                try (PreparedStatement pst = con.prepareStatement(sql)) {
                    pst.setInt(1, patientId);
                    pst.setInt(2, doctorId);
                    pst.setDate(3, java.sql.Date.valueOf(appointmentDate));
                    pst.setTime(4, java.sql.Time.valueOf(appointmentTime + ":00"));
                    pst.executeUpdate();
                }
            }

            session.setAttribute("bookingSuccess", "Appointment booked successfully!");
            response.sendRedirect(request.getContextPath() + "/patient/appointments");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid doctor ID.");
        } catch (SQLException e) {
            throw new ServletException("Database error while booking appointment.", e);
        }
    }

    private int getPatientIdFromUserId(HttpSession session, int userId) throws SQLException {
        try (Connection con = DbConnector.getConnection()) {
            String sql = "SELECT patient_id FROM Patient WHERE user_id = ?";
            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, userId);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("patient_id");
                    }
                }
            }
        }
        return -1;
    }
}
