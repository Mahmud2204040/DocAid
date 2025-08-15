<%@ page import="java.util.logging.Logger" %>
<%@ page import="classes.DbConnector" %>
<%@ page import="classes.User" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.Cookie" %>  <!-- Jakarta for Tomcat 10+ -->
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    private static final Logger logger = Logger.getLogger("login.jsp");
%>

<%
    try {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isBlank() || password.isBlank()) {
            response.sendRedirect("log.jsp?error=2");
            return;
        }

        User user = new User();
        user.setEmail(email.trim());
        user.setPassword(password);

        logger.info("Attempting login for email: " + email);

        try (Connection con = DbConnector.getConnection()) {
            if (con == null) {
                throw new SQLException("Database connection failed");
            }
            if (user.authenticateByCredentials(con)) {
                session.setAttribute("user_id", user.getId());
                session.setAttribute("user_role", user.getRole());
                session.setAttribute("email", user.getEmail()); // Also set email for convenience

                // If user is a Hospital, fetch and set the hospital_id in the session
                if ("Hospital".equalsIgnoreCase(user.getRole())) {
                    try (java.sql.PreparedStatement pstmt = con.prepareStatement("SELECT hospital_id FROM Hospital WHERE user_id = ?")) {
                        pstmt.setInt(1, user.getId());
                        try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                            if (rs.next()) {
                                session.setAttribute("hospital_id", rs.getInt("hospital_id"));
                            } else {
                                // This case should ideally not happen if data is consistent
                                logger.warning("Hospital user logged in but no corresponding hospital_id found for user_id: " + user.getId());
                                response.sendRedirect("log.jsp?error=6"); // Custom error for missing role-specific ID
                                return;
                            }
                        }
                    }
                }

                // Optional: Handle "remember me"
                if (request.getParameter("remember_me") != null) {
                    Cookie ck = new Cookie("auth", user.getAuth_key());
                    ck.setMaxAge(60 * 60 * 24 * 30);  // 30 days
                    ck.setHttpOnly(true);
                    ck.setSecure(request.isSecure());
                    ck.setPath(request.getContextPath());
                    response.addCookie(ck);
                }

                // Redirect based on role to the correct CONTROLLER SERVLET
                String destination = "";
                String role = user.getRole();
                if ("Admin".equalsIgnoreCase(role)) {
                    destination = request.getContextPath() + "/admin/dashboard";
                } else if ("Doctor".equalsIgnoreCase(role)) {
                    destination = request.getContextPath() + "/doctor/profile";
                } else if ("Patient".equalsIgnoreCase(role)) {
                    // Assuming a future patient dashboard servlet
                    destination = request.getContextPath() + "/PATIENT/index.jsp"; // Default for now
                } else if ("Hospital".equalsIgnoreCase(role)) {
                    destination = request.getContextPath() + "/hospital/dashboard";
                } else {
                    // Default fallback
                    destination = request.getContextPath() + "/log.jsp?error=5"; // Unknown role
                }
                response.sendRedirect(destination);
            } else {
                logger.warning("Invalid credentials for email: " + email);
                response.sendRedirect("log.jsp?error=1");
            }
        }
    } catch (SQLException ex) {
        logger.severe("Database error during authentication: " + ex.getMessage());
        response.sendRedirect("log.jsp?error=3");
    } catch (Exception ex) {
        logger.severe("Unexpected authentication error: " + ex.getMessage());
        response.sendRedirect("log.jsp?error=4");
    }
%>
