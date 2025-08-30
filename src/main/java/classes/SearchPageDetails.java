package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import classes.Doctor;

public class SearchPageDetails {

    public static SearchResult searchDoctors(Connection con, String query, String sortBy, String filterRating, String filterAvailability, Double userLat, Double userLng, int page, int pageSize) {
        List<Doctor> doctors = new ArrayList<>();
        int totalResults = 0;

        List<Object> params = new ArrayList<>();
        StringBuilder whereClause = new StringBuilder(" WHERE 1=1 ");

        if (query != null && !query.trim().isEmpty()) {
            whereClause.append(" AND (display_name LIKE ? OR specialty LIKE ? OR address LIKE ?) ");
            String searchPattern = "%" + query + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (filterRating != null && !filterRating.isEmpty()) {
            whereClause.append(" AND rating >= ? ");
            params.add(Double.parseDouble(filterRating));
        }

        

        try {
            StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM v_doctor_search ");
            countSql.append(whereClause);

            try (PreparedStatement countStmt = con.prepareStatement(countSql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    countStmt.setObject(i + 1, params.get(i));
                }
                ResultSet rs = countStmt.executeQuery();
                if (rs.next()) {
                    totalResults = rs.getInt(1);
                }
            }

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT doctor_id, user_id, display_name, first_name, last_name, gender, license_number, experience, bio, fee, address, latitude, longitude, rating, review_count, appointment_contact AS phone, specialty, specialty_id, hospital_name, hospital_id, hospital_address, email, created_at, updated_at ");
            if (userLat != null && userLng != null) {
                sql.append(", (6371 * acos(cos(radians(?)) * cos(radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin(radians(latitude)))) AS distance");
            }
            sql.append(" FROM v_doctor_search ");
            sql.append(whereClause);

            sql.append(" ORDER BY ");
            String orderClause;
            switch (sortBy != null ? sortBy : "") {
                case "distance":
                    if (userLat != null && userLng != null) {
                        orderClause = "distance ASC";
                    } else {
                        orderClause = "doctor_id DESC";
                    }
                    break;
                case "rating":
                    orderClause = "rating DESC";
                    break;
                case "name":
                    orderClause = "display_name ASC";
                    break;
                default:
                    orderClause = "doctor_id DESC";
            }
            sql.append(orderClause);

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
                    Doctor doctor = new Doctor();
                    populateDoctorFromResultSet(doctor, rs, userLat, userLng);
                    doctors.add(doctor);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Database error during doctor search", e);
        }

        int totalPages = (int) Math.ceil((double) totalResults / (double) pageSize);
        return new SearchResult(doctors, totalResults, totalPages, page);
    }

    private static void populateDoctorFromResultSet(Doctor doctor, ResultSet rs, Double userLat, Double userLng) throws SQLException {
        // user_id from Users table (base class)
        doctor.setId(rs.getInt("user_id"));
        // doctor_id from Doctor table (sub class)
        doctor.setDoctorId(rs.getInt("doctor_id"));
        doctor.setDisplayName(rs.getString("display_name"));
        doctor.setFirstName(rs.getString("first_name"));
        doctor.setLastName(rs.getString("last_name"));
        doctor.setGender(rs.getString("gender"));
        doctor.setLicenseNumber(rs.getString("license_number"));
        doctor.setExpYears(rs.getInt("experience"));
        doctor.setBio(rs.getString("bio"));
        doctor.setFee(rs.getBigDecimal("fee"));
        doctor.setAddress(rs.getString("address"));
        doctor.setLatitude(rs.getDouble("latitude"));
        doctor.setLongitude(rs.getDouble("longitude"));
        doctor.setSpecialty(rs.getString("specialty"));
        doctor.setHospitalName(rs.getString("hospital_name"));
        doctor.setSpecialtyId(rs.getObject("specialty_id", Integer.class));
        doctor.setRating(rs.getDouble("rating"));
        doctor.setReviewCount(rs.getInt("review_count"));
        doctor.setPhone(rs.getString("phone"));
        doctor.setCreatedAt(rs.getTimestamp("created_at"));
        doctor.setUpdatedAt(rs.getTimestamp("updated_at"));
        doctor.setEmail(rs.getString("email"));
        if (userLat != null && userLng != null) {
            doctor.setDistance(rs.getDouble("distance"));
        }
    }

    public static class SearchResult {
        private final List<Doctor> doctors;
        private final int totalResults;
        private final int totalPages;
        private final int currentPage;

        public SearchResult(List<Doctor> doctors, int totalResults, int totalPages, int currentPage) {
            this.doctors = doctors;
            this.totalResults = totalResults;
            this.totalPages = totalPages;
            this.currentPage = currentPage;
        }

        public List<Doctor> getDoctors() { return doctors; }
        public int getTotalResults() { return totalResults; }
        public int getTotalPages() { return totalPages; }
        public int getCurrentPage() { return currentPage; }
    }
}
