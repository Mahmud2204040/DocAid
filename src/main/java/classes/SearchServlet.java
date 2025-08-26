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
        String query = request.getParameter("q");
        String pageParam = request.getParameter("page");

        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                // Ignore and use default page 1
            }
        }

        try (Connection con = DbConnector.getConnection()) {
            SearchPageDetails.SearchResult result = SearchPageDetails.searchDoctors(con, query, null, null, null, null, null, page, 10);
            request.setAttribute("searchResult", result);
            request.setAttribute("searchQuery", query);
                        request.getRequestDispatcher("/PATIENT/search.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error during doctor search", e);
        }
    }
}
