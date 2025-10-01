package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SearchHospitalDetails {

    public static SearchResult searchHospitals(Connection con, String query, String sortBy, Double userLat, Double userLng, int page, int pageSize) {
        List<Hospital> hospitals = new ArrayList<>();
        int totalResults = 0;

        List<Object> params = new ArrayList<>();
        StringBuilder whereClause = new StringBuilder(" WHERE 1=1 ");

        if (query != null && !query.trim().isEmpty()) {
            whereClause.append(" AND (h.hospital_name LIKE ? OR h.address LIKE ?) ");
            String searchPattern = "%" + query + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        try {
            String countSql = "SELECT COUNT(DISTINCT h.hospital_id) FROM Hospital h" + whereClause.toString();
            try (PreparedStatement countStmt = con.prepareStatement(countSql)) {
                for (int i = 0; i < params.size(); i++) {
                    countStmt.setObject(i + 1, params.get(i));
                }
                ResultSet rs = countStmt.executeQuery();
                if (rs.next()) {
                    totalResults = rs.getInt(1);
                }
            }

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT h.*, u.email, u.user_id");
            if (userLat != null && userLng != null) {
                sql.append(", (6371 * acos(cos(radians(?)) * cos(radians(h.latitude)) * cos(radians(h.longitude) - radians(?)) + sin(radians(?)) * sin(radians(h.latitude)))) AS distance");
            }
            sql.append(" FROM Hospital h ");
            sql.append("JOIN Users u ON h.hospital_id = u.user_id ");
            sql.append(whereClause);

            sql.append(" ORDER BY ");
            if ("distance".equals(sortBy) && userLat != null && userLng != null) {
                sql.append("distance ASC");
            } else {
                sql.append("h.hospital_name ASC"); // Default sort
            }

            sql.append(" LIMIT ? OFFSET ?");

            try (PreparedStatement stmt = con.prepareStatement(sql.toString())) {
                int paramIndex = 1;
                if (userLat != null && userLng != null) {
                    stmt.setDouble(paramIndex++, userLat);
                    stmt.setDouble(paramIndex++, userLng);
                    stmt.setDouble(paramIndex++, userLat);
                }
                for (Object p : params) {
                    stmt.setObject(paramIndex++, p);
                }
                stmt.setInt(paramIndex++, pageSize);
                stmt.setInt(paramIndex++, (page - 1) * pageSize);

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Hospital hospital = new Hospital();
                    populateHospitalFromResultSet(hospital, rs);
                    hospitals.add(hospital);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        int totalPages = (int) Math.ceil((double) totalResults / (double) pageSize);
        return new SearchResult(hospitals, totalResults, totalPages, page);
    }

    private static void populateHospitalFromResultSet(Hospital hospital, ResultSet rs) throws SQLException {
        hospital.setHospitalId(rs.getInt("hospital_id"));
        hospital.setId(rs.getInt("user_id"));
        hospital.setHospitalName(rs.getString("hospital_name"));
        hospital.setHospitalBio(rs.getString("hospital_bio"));
        hospital.setAddress(rs.getString("address"));
        hospital.setWebsite(rs.getString("website"));
        hospital.setLatitude(rs.getDouble("latitude"));
        hospital.setLongitude(rs.getDouble("longitude"));
        hospital.setEmail(rs.getString("email"));
        // Distance may not always be present, handle it carefully
        try {
            if (rs.findColumn("distance") > 0) {
                // You need to add a distance field to your Hospital class
                // hospital.setDistance(rs.getDouble("distance")); 
            }
        } catch (SQLException ignore) {}
    }

    public static class SearchResult {
        private final List<Hospital> hospitals;
        private final int totalResults;
        private final int totalPages;
        private final int currentPage;

        public SearchResult(List<Hospital> hospitals, int totalResults, int totalPages, int currentPage) {
            this.hospitals = hospitals;
            this.totalResults = totalResults;
            this.totalPages = totalPages;
            this.currentPage = currentPage;
        }

        public List<Hospital> getHospitals() { return hospitals; }
        public int getTotalResults() { return totalResults; }
        public int getTotalPages() { return totalPages; }
        public int getCurrentPage() { return currentPage; }
    }
}
