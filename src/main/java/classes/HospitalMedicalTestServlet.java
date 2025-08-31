package classes;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/hospital/medical-tests")
public class HospitalMedicalTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object hospitalIdAttr = session.getAttribute("hospital_id");
        if (hospitalIdAttr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User session is missing 'hospital_id'. Please ensure the login process sets this attribute.");
            return;
        }

        try {
            int hospitalId = (Integer) hospitalIdAttr;
            int userId = (Integer) session.getAttribute("user_id");
            String email = (String) session.getAttribute("email");

            Hospital hospital = new Hospital(hospitalId, userId, email);
            List<Hospital.MedicalTestRecord> tests = hospital.getMedicalTests();

            request.setAttribute("testList", tests);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/HOSPITAL/medical_tests.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error while fetching medical tests.", e);
        } catch (Exception e) {
            throw new ServletException("An error occurred. Please ensure you are logged in correctly.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"Hospital".equals(session.getAttribute("user_role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int hospitalId = (Integer) session.getAttribute("hospital_id");
            String action = request.getParameter("action");

            Hospital hospital = new Hospital();
            hospital.setHospitalId(hospitalId);

            boolean success = false;
            String message = "";

            if ("delete".equals(action)) {
                int testId = Integer.parseInt(request.getParameter("test_id"));
                success = hospital.deleteMedicalTest(testId);
                message = success ? "Medical test deleted successfully!" : "Failed to delete medical test.";
            } else {
                String testName = request.getParameter("test_name");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String testIdStr = request.getParameter("test_id");

                if (testIdStr != null && !testIdStr.isEmpty()) {
                    // This is an update (edit)
                    int testId = Integer.parseInt(testIdStr);
                    boolean isActive = "on".equals(request.getParameter("is_active"));
                    success = hospital.updateMedicalTest(testId, testName, description, price, isActive);
                    message = success ? "Medical test updated successfully!" : "Failed to update medical test.";
                } else {
                    // This is a create (add)
                    success = hospital.createMedicalTest(testName, description, price);
                    message = success ? "Medical test added successfully!" : "Failed to add medical test.";
                }
            }
            session.setAttribute("message", message);
            session.setAttribute("messageClass", success ? "alert-success" : "alert-danger");

        } catch (SQLException e) {
            session.setAttribute("message", "Database error: " + e.getMessage());
            session.setAttribute("messageClass", "alert-danger");
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid price or ID format.");
            session.setAttribute("messageClass", "alert-danger");
        }
        response.sendRedirect(request.getContextPath() + "/hospital/medical-tests");
    }
}
