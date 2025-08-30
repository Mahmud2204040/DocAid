<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>

<%
    try {
        // Log the sign out attempt
        Integer userId = (Integer) session.getAttribute("user_id");
        String userRole = (String) session.getAttribute("user_role");
        
        if (userId != null) {
            System.out.println("User " + userId + " with role " + userRole + " signing out at " + new java.util.Date());
        }
        
        // Clear all session attributes
        session.removeAttribute("user_id");
        session.removeAttribute("user_role");
        session.removeAttribute("user_email");
        session.removeAttribute("user_name");
        
        // Invalidate the entire session
        session.invalidate();
        
        // Clear authentication cookies if they exist
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("auth".equals(cookie.getName()) || "remember_me".equals(cookie.getName())) {
                    Cookie clearCookie = new Cookie(cookie.getName(), "");
                    clearCookie.setMaxAge(0);
                    clearCookie.setPath(request.getContextPath());
                    clearCookie.setHttpOnly(true);
                    clearCookie.setSecure(request.isSecure());
                    response.addCookie(clearCookie);
                }
            }
        }
        
        // Set cache control headers to prevent back button access
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Redirect to login page with success message
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signing Out - DocAid</title>
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: white;
        }
        
        .logout-container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            padding: 2rem;
            border-radius: 12px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        h2 {
            margin: 0 0 0.5rem 0;
            font-weight: 600;
        }
        
        p {
            margin: 0;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="logout-container">
        <div class="spinner"></div>
        <h2>Signing Out...</h2>
        <p>Please wait while we securely log you out.</p>
    </div>
    
    <script>
        // Fallback redirect in case JSP redirect doesn't work
        setTimeout(function() {
            window.location.href = '<%= request.getContextPath() %>/index.jsp';
        }, 2000);
        
        // Clear any local storage or session storage
        if (typeof(Storage) !== "undefined") {
            localStorage.clear();
            sessionStorage.clear();
        }
        
        // Prevent back button access after logout
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
    </script>
</body>
</html>
