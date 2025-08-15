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

@WebServlet("/search")
public class SearchDoctorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        String sortBy = request.getParameter("sort");
        String filterRating = request.getParameter("rating");
        String filterAvailability = request.getParameter("availability");
        String userLatStr = request.getParameter("lat");
        String userLngStr = request.getParameter("lng");
        String pageParam = request.getParameter("page");

        Double userLat = null;
        Double userLng = null;

        try {
            if (userLatStr != null && !userLatStr.isEmpty()) userLat = Double.parseDouble(userLatStr);
            if (userLngStr != null && !userLngStr.isEmpty()) userLng = Double.parseDouble(userLngStr);
        } catch (NumberFormatException e) {
            // Log error or handle gracefully
            System.err.println("Invalid latitude or longitude format.");
        }

        int page = 1;
        try {
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }
        page = Math.max(1, page);

        try (Connection con = DbConnector.getConnection()) {
            SearchPageDetails.SearchResult result = SearchPageDetails.searchDoctors(
                con, query, sortBy, filterRating, filterAvailability, userLat, userLng, page, 10
            );
            request.setAttribute("searchResult", result);
            request.getRequestDispatcher("/PATIENT/search_page.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error during doctor search", e);
        }
    }
}