package classes;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConnector {

    private static final Properties properties = new Properties();
    private static final Logger LOGGER = Logger.getLogger(DbConnector.class.getName());

    static {
        try (InputStream input = DbConnector.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                LOGGER.warning("db.properties not found in classpath");
            } else {
                properties.load(input);
            }
        } catch (IOException ex) {
            LOGGER.log(Level.SEVERE, "Failed to load db.properties", ex);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (properties.isEmpty()) {
            throw new SQLException("Database properties not loaded. Check db.properties file.");
        }

        String driver = properties.getProperty("db.driver");
        String url = properties.getProperty("db.url");
        String user = properties.getProperty("db.user");
        String password = properties.getProperty("db.password");

        if (driver == null || url == null || user == null || password == null) {
            throw new SQLException("Missing required database properties (db.driver, db.url, db.user, db.password)");
        }

        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, user, password);
            if (con != null && con.isValid(5)) {  // Validate connection (timeout in seconds)
                LOGGER.info("✅ Database connection successful!");
                return con;
            } else {
                throw new SQLException("Connection established but invalid");
            }
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database driver not found", e);
            throw new SQLException("Database driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to connect to database", e);
            throw new SQLException("Failed to connect to database: " + e.getMessage(), e);
        }
    }
}
