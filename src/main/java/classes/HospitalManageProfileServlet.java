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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/hospital/profile")
public class HospitalManageProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(HospitalManageProfileServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        
        try (Connection con = DbConnector.getConnection()) {
            // Load hospital profile data
            Hospital hospital = new Hospital();
            hospital.setId(userId);
            hospital.loadFromDatabase(con, userId); // Fixed: Added userId parameter
            
            // Set attributes for JSP
            request.setAttribute("hospital", hospital);
            
            // Placeholder for hospitalStats to prevent NullPointerException in JSP
            // In a real application, you would fetch actual statistics from the database
            // or a service.
            java.util.Map<String, Object> hospitalStats = new java.util.HashMap<>();
            hospitalStats.put("doctorCount", 0); // Replace with actual count
            hospitalStats.put("appointmentCount", 0); // Replace with actual count
            hospitalStats.put("testCount", 0); // Replace with actual count
            hospitalStats.put("averageRating", 0.0); // Replace with actual rating
            request.setAttribute("hospitalStats", hospitalStats);
            
            // Forward to profile JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/profile.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error loading hospital profile", e);
            request.setAttribute("error", "Failed to load profile data");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/error.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String hospitalName = request.getParameter("hospital_name");
        String website = request.getParameter("website");
        String address = request.getParameter("address");
        String hospitalBio = request.getParameter("hospital_bio");
        String contactNo = request.getParameter("contact_no");
        
        try (Connection con = DbConnector.getConnection()) {
            Hospital hospital = new Hospital();
            hospital.setId(userId);
            hospital.loadFromDatabase(con, userId); // Fixed: Added userId parameter
            
            hospital.setHospitalName(hospitalName);
            hospital.setWebsite(website);
            hospital.setAddress(address);
            hospital.setHospitalBio(hospitalBio);
           // hospital.setContact_no(contactNo);
            
            // Fixed: Use the correct update method from Hospital class
            hospital.updateDetails();
            
            session.setAttribute("message", "Profile updated successfully!");
            response.sendRedirect(request.getContextPath() + "/hospital/profile");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error updating hospital profile", e);
            session.setAttribute("error", "Failed to update profile");
            response.sendRedirect(request.getContextPath() + "/hospital/profile");
        }
    }
}