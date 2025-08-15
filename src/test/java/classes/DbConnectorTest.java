package classes;

import java.sql.Connection;
import java.sql.SQLException;
import org.junit.Test;
import static org.junit.Assert.*;

public class DbConnectorTest {

    @Test
    public void testGetConnection_Success() {
        Connection con = null;
        try {
            con = DbConnector.getConnection();
            assertNotNull("Connection should not be null", con);
            assertTrue("Connection should be valid", con.isValid(2));
        } catch (SQLException e) {
            fail("SQLException occurred during connection attempt: " + e.getMessage());
        } catch (Exception e) {
            fail("Unexpected exception occurred: " + e.getMessage());
        } finally {
            if (con != null) {
                try {
                    con.close();
                    System.out.println("Connection closed successfully in test.");
                } catch (SQLException e) {
                    System.err.println("Warning: Failed to close connection in test - " + e.getMessage());
                }
            }
        }
    }

    @Test
    public void testGetConnection_FailureHandling() {
        // Note: This is a placeholder for testing failure scenarios.
        // Since DbConnector loads properties statically, simulating failure without
        // altering the environment is tricky without mocks.
        // Consider using a mocking framework like Mockito to simulate property load failures
        // or invalid credentials in a future iteration.
        System.out.println("Reminder: Implement failure test with mocking if needed.");
    }
}
