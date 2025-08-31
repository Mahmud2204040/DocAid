package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import classes.Doctor;

public class SearchPageDetails {

    public static SearchResult searchDoctors(Connection con, String query, String sortBy, String filterRating, String filterAvailability, Double userLat, Double userLng, int page, int pageSize) {
        List<Doctor> doctors = new ArrayList<>();
        int totalResults = 0;

        List<Object> params = new ArrayList<>();
        StringBuilder whereClause = new StringBuilder(" WHERE 1=1 ");

        if (query != null && !query.trim().isEmpty()) {
            whereClause.append(" AND (CONCAT(d.first_name, ' ', d.last_name) LIKE ? OR s.specialty_name LIKE ? OR d.address LIKE ?) ");
            String searchPattern = "%" + query + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (filterRating != null && !filterRating.isEmpty()) {
            double rating = Double.parseDouble(filterRating);
            if (rating > 0) {
                whereClause.append(" AND d.rating >= ? ");
                params.add(rating);
            }
        }

        if ("today".equals(filterAvailability)) {
            String today = LocalDate.now().getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.ENGLISH);
            whereClause.append(" AND EXISTS (SELECT 1 FROM Doctor_schedule ds WHERE ds.doctor_id = d.doctor_id AND ds.visiting_day = ?) ");
            params.add(today);
        }

        try {
            // Note: The view name is v_doctor_search, but we use table aliases for clarity in the JOINs
            StringBuilder countSql = new StringBuilder("SELECT COUNT(DISTINCT d.doctor_id) FROM Doctor d LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id ");
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
            sql.append("SELECT d.doctor_id, d.user_id, CONCAT(d.first_name, ' ', d.last_name) as display_name, d.first_name, d.last_name, d.gender, d.license_number, d.exp_years as experience, d.bio, d.fee, d.address, d.latitude, d.longitude, d.rating, d.review_count, s.specialty_name as specialty, s.specialty_id, h.hospital_name, h.hospital_id, h.address as hospital_address, u.email, uc.contact_no AS appointment_contact, u.created_at, u.updated_at ");
            if (userLat != null && userLng != null) {
                sql.append(", (6371 * acos(cos(radians(?)) * cos(radians(d.latitude)) * cos(radians(d.longitude) - radians(?)) + sin(radians(?)) * sin(radians(d.latitude)))) AS distance");
            }
            sql.append(" FROM Doctor d JOIN Users u ON d.user_id = u.user_id LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id LEFT JOIN User_Contact uc ON d.user_id = uc.user_id AND uc.contact_type = 'Appointment' ");
            sql.append(whereClause);

            sql.append(" GROUP BY d.doctor_id ");

            sql.append(" ORDER BY ");
            String orderClause;
            switch (sortBy != null ? sortBy : "") {
                case "distance":
                    if (userLat != null && userLng != null) {
                        orderClause = "distance ASC";
                    } else {
                        orderClause = "d.doctor_id DESC"; // Fallback
                    }
                    break;
                case "rating":
                    orderClause = "d.rating DESC";
                    break;
                case "name":
                    orderClause = "display_name ASC";
                    break;
                default:
                    orderClause = "d.doctor_id DESC"; // Default sort
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
        doctor.setPhone(rs.getString("appointment_contact"));
        doctor.setCreatedAt(rs.getTimestamp("created_at"));
        doctor.setUpdatedAt(rs.getTimestamp("updated_at"));
        doctor.setEmail(rs.getString("email"));
        if (userLat != null && userLng != null && hasColumn(rs, "distance")) {
            doctor.setDistance(rs.getDouble("distance"));
        }
    }
    
    // Helper to check if a column exists in the ResultSet
    private static boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
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
