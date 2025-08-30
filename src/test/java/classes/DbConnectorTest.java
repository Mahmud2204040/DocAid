package classes;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import java.lang.reflect.Field;

@RunWith(MockitoJUnitRunner.class)
public class DbConnectorTest {

    @Mock
    private DataSource mockDataSource;

    @Mock
    private Connection mockConnection;

    @Before
    public void setUp() throws Exception {
        // Use reflection to set the static dataSource field in DbConnector
        Field dataSourceField = DbConnector.class.getDeclaredField("dataSource");
        dataSourceField.setAccessible(true);
        dataSourceField.set(null, mockDataSource);

        when(mockDataSource.getConnection()).thenReturn(mockConnection);
    }

    @Test
    public void testGetConnection_Success() throws SQLException {
        when(mockConnection.isValid(anyInt())).thenReturn(true);
        Connection con = DbConnector.getConnection();
        assertNotNull("Connection should not be null", con);
        verify(mockDataSource).getConnection();
        verify(mockConnection).isValid(anyInt());
    }

    @Test
    public void testGetConnection_Failure() throws SQLException {
        when(mockDataSource.getConnection()).thenThrow(new SQLException("Test Exception"));
        try {
            DbConnector.getConnection();
            fail("SQLException was expected but not thrown");
        } catch (SQLException e) {
            assertEquals("Test Exception", e.getMessage());
        }
    }

    @Test
    public void testGetConnection_InvalidConnection() throws SQLException {
        when(mockConnection.isValid(anyInt())).thenReturn(false);
        try {
            DbConnector.getConnection();
            fail("SQLException was expected but not thrown");
        } catch (SQLException e) {
            assertEquals("Failed to get a valid connection from the pool.", e.getMessage());
        }
    }
}