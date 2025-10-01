package classes;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.DriverManager;
import java.io.InputStream; // Added import
import java.util.Properties; // Added import

public class DbConnector {

    private static DataSource dataSource;
    private static final Logger LOGGER = Logger.getLogger(DbConnector.class.getName());
    private static Properties dbProperties = new Properties(); // Added Properties object

    static { // Static initializer to load properties
        try (InputStream input = DbConnector.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                LOGGER.log(Level.SEVERE, "Sorry, unable to find db.properties");
            }
            dbProperties.load(input);
            LOGGER.info("✅ db.properties loaded successfully!");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading db.properties", e);
        }
    }

    private static void initializeDataSource() throws NamingException, SQLException {
        if (dataSource == null) {
            try {
                Context initContext = new InitialContext();
                Context envContext = (Context) initContext.lookup("java:comp/env");
                dataSource = (DataSource) envContext.lookup("jdbc/docaid");
                LOGGER.info("✅ JNDI DataSource lookup successful!");
            } catch (NamingException e) {
                LOGGER.log(Level.WARNING, "JNDI lookup failed, falling back to direct JDBC connection: " + e.getMessage());
                // Fallback to direct JDBC connection
                try {
                    String dbDriver = dbProperties.getProperty("db.driver");
                    String dbUrl = dbProperties.getProperty("db.url");
                    String dbUser = dbProperties.getProperty("db.user");
                    String dbPassword = dbProperties.getProperty("db.password");

                    Class.forName(dbDriver);
                    dataSource = new DataSource() {
                        @Override
                        public Connection getConnection() throws SQLException {
                            return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                        }

                        @Override
                        public Connection getConnection(String username, String password) throws SQLException {
                            return DriverManager.getConnection(dbUrl, username, password);
                        }

                        @Override
                        public java.io.PrintWriter getLogWriter() throws SQLException { return null; }
                        @Override
                        public void setLogWriter(java.io.PrintWriter out) throws SQLException {}
                        @Override
                        public void setLoginTimeout(int seconds) throws SQLException {}
                        @Override
                        public int getLoginTimeout() throws SQLException { return 0; }
                        @Override
                        public Logger getParentLogger() throws java.sql.SQLFeatureNotSupportedException { return null; }
                        @Override
                        public <T> T unwrap(Class<T> iface) throws SQLException { return null; }
                        @Override
                        public boolean isWrapperFor(Class<?> iface) throws SQLException { return false; }
                    };
                    LOGGER.info("✅ Direct JDBC DataSource initialized successfully from db.properties!");
                } catch (ClassNotFoundException cnfe) {
                    LOGGER.log(Level.SEVERE, "JDBC Driver not found: " + dbProperties.getProperty("db.driver"), cnfe);
                    throw new SQLException("JDBC Driver not found", cnfe);
                }
            }
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            if (dataSource == null) {
                initializeDataSource();
            }
            Connection con = dataSource.getConnection();
            if (con != null && con.isValid(5)) {
                LOGGER.info("✅ Database connection successful!");
                return con;
            } else {
                throw new SQLException("Failed to get a valid connection from the pool/driver.");
            }
        } catch (NamingException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DataSource due to NamingException", e);
            throw new SQLException("Failed to initialize DataSource", e);
        }
    }
}