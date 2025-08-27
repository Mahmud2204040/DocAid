package classes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnector {
    private static Connection connection;

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                String jdbcUrl = System.getenv("DATABASE_URL");
                if (jdbcUrl == null || jdbcUrl.isEmpty()) {
                    throw new SQLException("DATABASE_URL environment variable not set!");
                }
                if (!jdbcUrl.startsWith("jdbc:")) {
                    jdbcUrl = "jdbc:" + jdbcUrl;
                }

                // Register JDBC driver (optional for modern JDBC drivers)
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Open a connection
                connection = DriverManager.getConnection(jdbcUrl);
            } catch (Exception e) {
                e.printStackTrace();
                throw new SQLException("Failed to connect to the database: " + e.getMessage());
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}