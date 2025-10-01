package classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Represents a base User in the DocAid system, handling authentication and basic profile data.
 * Extends to role-specific classes (Admin, Doctor, Hospital, Patient) via IsA relationship.
 */
public class User {

    private int id;
    private String email;
    private String password;
    private String role;


    private static final Logger logger = Logger.getLogger(User.class.getName());

    /**
     * Default constructor for creating an empty User instance.
     */
    public User() {
        // Empty constructor
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }



    /**
     * Authenticates the user using email and password credentials.
     * On success, sets ID, role, generates a new auth key, and updates it in the database.
     *
     * @param con Active database connection.
     * @return true if authentication succeeds, false otherwise.
     * @throws SQLException if a database error occurs.
     */
    public boolean authenticateByCredentials(Connection con) throws SQLException {
        String query = "SELECT user_id, user_type, password FROM Users WHERE email = ?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setString(1, this.email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String hashedPassword = MD5.getMd5(this.password);

                    // Temporary logging for debugging
                    System.out.println("--- AUTHENTICATION DEBUG ---");
                    System.out.println("Input Password: " + this.password);
                    System.out.println("Hashed Input:   " + hashedPassword);
                    System.out.println("Stored Password:  " + storedPassword);
                    System.out.println("Passwords Match:  " + storedPassword.equals(hashedPassword));
                    System.out.println("--------------------------");

                    // TODO: Replace MD5 with stronger hash like BCrypt for production
                    if (storedPassword.equals(hashedPassword)) {
                        this.setId(rs.getInt("user_id"));
                        this.setRole(rs.getString("user_type"));

                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error during credential authentication", e);
            throw e;  // Propagate for caller handling
        }
        return false;
    }





    /**
     * Placeholder method to load role-specific details from the database.
     * Can be overridden or extended in subclasses for Patient/Doctor/etc.
     *
     * @param con Active database connection.
     * @throws SQLException if a database error occurs.
     */
    public void loadRoleDetails(Connection con) throws SQLException {
        // Example: Query role-specific table based on this.role
        // Implement based on specific needs (e.g., fetch Patient address)
        logger.info("Loading details for role: " + this.role);
        // TODO: Add queries for role-specific data
    }

    /**
     * Loads User details from the database based on the user's ID.
     *
     * @param con Active database connection.
     * @param userId The ID of the user to load.
     * @throws SQLException if a database error occurs or no record found.
     */
    public void loadFromDatabase(Connection con, int userId) throws SQLException {
        String query = "SELECT email, user_type FROM Users WHERE user_id = ?";
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    this.id = userId;
                    this.email = rs.getString("email");
                    this.role = rs.getString("user_type");
                } else {
                    throw new SQLException("No User record found for user_id: " + userId);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error loading User from database", e);
            throw e;
        }
    }
}
