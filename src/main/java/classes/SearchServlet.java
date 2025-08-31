package classes;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import classes.DbConnector;
import classes.SearchPageDetails;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // --- Retrieve all search, filter, and pagination parameters ---
        String query = request.getParameter("q");
        String sortBy = request.getParameter("sortBy");
        String filterRating = request.getParameter("filterRating");
        String filterAvailability = request.getParameter("filterAvailability");
        String pageParam = request.getParameter("page");

        // --- Safely parse numeric parameters ---
        Double userLat = getDoubleParameter(request, "userLat");
        Double userLng = getDoubleParameter(request, "userLng");

        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // Ignore and use default page 1
            }
        }

        try (Connection con = DbConnector.getConnection()) {
            // --- Call search logic with all parameters ---
            SearchPageDetails.SearchResult result = SearchPageDetails.searchDoctors(
                con, query, sortBy, filterRating, filterAvailability, userLat, userLng, page, 10
            );

            // --- Set attributes for the JSP to render results and preserve filter state ---
            request.setAttribute("searchResult", result);
            request.setAttribute("searchQuery", query);
            // Note: The JSP reads parameters directly from the 'param' object,
            // but setting them as attributes can be useful for more complex scenarios.
            
            request.getRequestDispatcher("/PATIENT/search.jsp").forward(request, response);
            
        } catch (SQLException e) {
            // In a real application, log this error properly
            e.printStackTrace();
            throw new ServletException("Database error during doctor search", e);
        }
    }

    /**
     * Safely retrieves a request parameter and converts it to a Double.
     * @param request The HttpServletRequest object.
     * @param name The name of the parameter.
     * @return The Double value, or null if the parameter is null, empty, or not a valid double.
     */
    private Double getDoubleParameter(HttpServletRequest request, String name) {
        String param = request.getParameter(name);
        if (param == null || param.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(param);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
