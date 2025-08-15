package classes;

import java.sql.Connection;
import java.sql.SQLException;

public class DbConnectionTest {
    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = DbConnector.getConnection();  // Now throws SQLException
            if (conn != null && !conn.isClosed()) {
                System.out.println("✔ Test Passed: Connection is valid and open.");
            } else {
                System.out.println("✖ Test Failed: Connection is null or closed.");
            }
        } catch (SQLException e) {
            System.out.println("✖ Test Failed: SQL Exception occurred.");
            System.out.println("Error Details: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("✖ Test Failed: Unexpected error.");
            System.out.println("Error Details: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("Connection closed successfully.");
                } catch (SQLException e) {
                    System.out.println("Warning: Failed to close connection - " + e.getMessage());
                }
            }
        }
    }
}
