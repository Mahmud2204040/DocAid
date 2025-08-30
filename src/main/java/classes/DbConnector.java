package classes;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConnector {

    private static DataSource dataSource;
    private static final Logger LOGGER = Logger.getLogger(DbConnector.class.getName());

    private static void initializeDataSource() throws NamingException {
        if (dataSource == null) {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/docaid");
            LOGGER.info("✅ JNDI DataSource lookup successful!");
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            if (dataSource == null) {
                initializeDataSource();
            }
            Connection con = dataSource.getConnection();
            if (con != null && con.isValid(5)) {
                LOGGER.info("✅ Database connection from pool successful!");
                return con;
            } else {
                throw new SQLException("Failed to get a valid connection from the pool.");
            }
        } catch (NamingException e) {
            LOGGER.log(Level.SEVERE, "Failed to lookup JNDI DataSource", e);
            throw new SQLException("Failed to lookup JNDI DataSource", e);
        }
    }
}