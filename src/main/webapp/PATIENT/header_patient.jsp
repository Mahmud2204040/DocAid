<%@ page import="java.sql.*, classes.DbConnector" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Security: Ensure user is logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer headerPatientIdInt = (Integer) session.getAttribute("user_id");
    Connection headerCon = null;
    PreparedStatement headerPst = null;
    ResultSet headerRs = null;

    String headerPatientName = "N/A";
    String headerPatientInitials = "N/A";
    String headerGender = "N/A";
    String headerPhone = "N/A";
    String headerLocation = "N/A";
    String headerDateOfBirth = "N/A";
    String headerBloodGroup = "N/A";
    String headerEmail = "N/A";

    try {
        headerCon = DbConnector.getConnection();
        String headerSql = "SELECT p.first_name, p.last_name, p.gender, p.date_of_birth, p.blood_type, p.address, u.email, c.contact_no " +
                           "FROM Patient p " +
                           "JOIN Users u ON p.user_id = u.user_id " +
                           "LEFT JOIN User_Contact c ON u.user_id = c.user_id AND c.contact_type = 'Primary' " +
                           "WHERE p.user_id = ?";
        headerPst = headerCon.prepareStatement(headerSql);
        headerPst.setInt(1, headerPatientIdInt);
        headerRs = headerPst.executeQuery();

        if (headerRs.next()) {
            String headerFirstName = headerRs.getString("first_name");
            String headerLastName = headerRs.getString("last_name");
            headerPatientName = headerFirstName + " " + headerLastName;
            headerGender = headerRs.getString("gender");
            headerPhone = headerRs.getString("contact_no");
            headerLocation = headerRs.getString("address");
            headerDateOfBirth = headerRs.getString("date_of_birth");
            headerBloodGroup = headerRs.getString("blood_type");
            headerEmail = headerRs.getString("email");

            if (headerFirstName != null && !headerFirstName.isEmpty() && headerLastName != null && !headerLastName.isEmpty()) {
                headerPatientInitials = "" + headerFirstName.charAt(0) + headerLastName.charAt(0);
            }
        }
    } catch (Exception headerE) {
        headerE.printStackTrace();
    } finally {
        if (headerRs != null) try { headerRs.close(); } catch (SQLException ignore) {}
        if (headerPst != null) try { headerPst.close(); } catch (SQLException ignore) {}
        if (headerCon != null) try { headerCon.close(); } catch (SQLException ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>DocAid - Patient Dashboard</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet"/>
    <link rel="icon" href="favicon.ico" type="image/x-icon"/>

    <style>
        :root {
            --background-color: #f8f9fa;
            --primary-color: #007BFF;
            --secondary-color: #28A745;
            --text-color: #333333;
        }
        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-color);
            padding-top: 56px;
        }
        
        /* CRITICAL: Navbar must have highest z-index */
        .navbar {
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            z-index: 999999 !important;
            position: fixed !important;
            isolation: isolate;
        }
        
        .nav-link {
            font-weight: 500;
            color: var(--text-color) !important;
        }
        .nav-link:hover {
            color: var(--primary-color) !important;
        }
        
        /* HERO SECTION STYLES (keeping your original styles) */
        .hero {
            padding: 60px 0;
            position: relative;
            padding-bottom: 140px;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: radial-gradient(circle, rgba(0,123,255,0.1) 0%, transparent 70%);
            z-index: -1;
        }
        
        .hero .search-container {
            position: absolute;
            bottom: 40px;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 1200px;
            padding: 0 15px;
            z-index: 10;
        }
        
        .hero .input-group {
            border-radius: 50px;
            box-shadow: 0 4px 25px rgba(0, 123, 255, 0.2);
            overflow: hidden;
            background: white;
            border: 2px solid var(--primary-color);
            width: 100%;
        }

        .hero .input-group > .form-control {
            height: 70px;
            padding: 0 30px;
            border: none;
            font-size: 18px;
            background: transparent;
            min-width: 300px;
        }
        
        .hero .input-group > .form-control:focus {
            box-shadow: none;
            border: none;
            outline: none;
        }

        .hero .input-group > .form-control:first-child {
            flex: 1 1 50%;
            border-right: 2px solid #e9ecef;
        }

        .hero .input-group > .form-control:last-child {
            flex: 1 1 50%;
        }

        .hero .input-group-text {
            height: 70px;
            width: 70px;
            border-radius: 50%;
            border: none;
            background: var(--primary-color);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin: 4px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0, 123, 255, 0.3);
            cursor: pointer;
        }

        .hero .input-group-text:hover {
            background: #0056b3;
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.4);
        }
        
        .card {
            transition: transform 0.2s;
            border: none;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-secondary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        .btn-secondary:hover {
            background-color: #218838;
            border-color: #218838;
        }

        /* ===== PATIENT HEADER SPECIFIC STYLES ===== */
        .navbar .btn-outline-primary {
            border-color: var(--primary-color);
            color: var(--primary-color);
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .navbar .btn-outline-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
            transform: translateY(-1px);
        }

        .navbar .btn-outline-danger {
            border-color: #dc3545;
            color: #dc3545;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .navbar .btn-outline-danger:hover {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
            transform: translateY(-1px);
        }

        /* ULTIMATE DROPDOWN SOLUTION */
        /* Create portal container at body level */
        #dropdown-portal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            pointer-events: none;
            z-index: 999999;
        }

        /* Portal dropdown styling */
        .dropdown-menu-portal {
            position: absolute !important;
            z-index: 999999 !important;
            pointer-events: auto !important;
            border: none !important;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15) !important;
            border-radius: 8px !important;
            min-width: 220px !important;
            background: white !important;
            transform: none !important;
            will-change: auto !important;
            backface-visibility: visible !important;
        }

        .dropdown-item {
            padding: 12px 20px !important;
            transition: all 0.2s ease !important;
            font-size: 0.95em !important;
            color: var(--text-color) !important;
            text-decoration: none !important;
            display: block !important;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa !important;
            color: var(--primary-color) !important;
            transform: translateX(5px) !important;
        }

        .dropdown-item i {
            width: 20px !important;
            text-align: center !important;
            margin-right: 10px !important;
        }

        /* Notification badge */
        .badge-notification {
            position: absolute !important;
            top: 5px !important;
            right: 5px !important;
            font-size: 0.6em !important;
            padding: 3px 6px !important;
            z-index: 10 !important;
        }

        /* Hide original dropdown menu */
        .dropdown-menu {
            display: none !important;
        }

        /* Responsive adjustments */
        @media (max-width: 767px) {
            .hero {
                padding-bottom: 160px;
            }
            .hero .search-container {
                bottom: 20px;
                padding: 0 15px;
            }
            .hero .input-group {
                flex-direction: column;
                border-radius: 25px;
            }
            .hero .input-group > .form-control {
                height: 55px;
                border-right: none !important;
                border-bottom: 2px solid #e9ecef;
                min-width: auto;
                font-size: 16px;
            }
            .hero .input-group > .form-control:last-child {
                border-bottom: none;
            }
            .hero .input-group-text {
                height: 55px;
                width: 55px;
                margin: 10px auto;
                font-size: 18px;
            }

            .navbar .btn-outline-primary,
            .navbar .btn-outline-danger {
                margin: 5px 0;
                display: block;
                text-align: center;
            }
            
            .navbar-nav .nav-item {
                text-align: center;
            }

            .dropdown-menu-portal {
                min-width: 180px !important;
            }
        }
    </style>
</head>
<body>
    <!-- Portal container for dropdown -->
    <div id="dropdown-portal"></div>
    
    <!-- Patient Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/PATIENT/">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="DocAid Logo" style="height: 40px;"/>
            </a>
            <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav"
                aria-controls="navbarNav"
                aria-expanded="false"
                aria-label="Toggle navigation"
            >
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/PATIENT/">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/PATIENT/about.jsp">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/PATIENT/#services">Services</a></li>
                    <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                </ul>

                <!-- Patient Actions -->
                <ul class="navbar-nav ms-3">
                    <!-- Find Hospital Button -->
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-primary me-2" href="${pageContext.request.contextPath}/PATIENT/search_page_hospital.jsp" style="border-radius: 20px; padding: 8px 16px; border-width: 2px;">
                            <i class="bi bi-hospital"></i> Find Hospital
                        </a>
                    </li>
                    
                    <!-- Find Doctor Button -->
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-primary me-3" href="${pageContext.request.contextPath}/PATIENT/search.jsp" style="border-radius: 20px; padding: 8px 16px; border-width: 2px;">
                            <i class="bi bi-person-badge"></i> Find Doctor
                        </a>
                    </li>
                    
                    <!-- Notification Bell -->
                    <li class="nav-item">
                        <a class="nav-link position-relative" href="${pageContext.request.contextPath}/PATIENT/notification.jsp" style="padding: 8px 12px;">
                            <i class="bi bi-bell" style="font-size: 1.3em; color: #007BFF;"></i>
                            <span class="badge bg-danger badge-notification rounded-pill">3</span>
                        </a>
                    </li>
                    
                    <!-- Profile Dropdown -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="profileDropdown" role="button" 
                           aria-expanded="false" style="padding: 8px 12px;">
                            <i class="bi bi-person-circle" style="font-size: 1.3em; color: #007BFF;"></i>
                        </a>
                        <!-- Original dropdown menu (hidden by CSS) -->
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/profile">
                                <i class="bi bi-person"></i>My Profile
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/update-profile">
                                <i class="bi bi-pencil-square"></i>Update Profile
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/appointments">
                                <i class="bi bi-calendar-check"></i>View Appointment
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient/past-visits">
                                <i class="bi bi-clock-history"></i>Past Visits
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/PATIENT/notification.jsp">
                                <i class="bi bi-bell"></i>Notification
                            </a></li>
                        </ul>
                    </li>

                    <!-- Sign Out Button -->
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-danger ms-2" href="${pageContext.request.contextPath}/sign_out.jsp" style="border-radius: 20px; padding: 8px 16px; border-width: 2px;">
                            <i class="bi bi-box-arrow-right"></i> Sign Out
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ULTIMATE DROPDOWN SOLUTION SCRIPT -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownToggle = document.getElementById('profileDropdown');
            const originalDropdown = dropdownToggle.nextElementSibling;
            const portalContainer = document.getElementById('dropdown-portal');
            let portalDropdown = null;
            let isOpen = false;

            // Create portal dropdown menu
            function createPortalDropdown() {
                if (portalDropdown) return portalDropdown;

                portalDropdown = document.createElement('div');
                portalDropdown.className = 'dropdown-menu-portal';
                portalDropdown.innerHTML = `
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/profile">
                        <i class="bi bi-person"></i>My Profile
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/update-profile">
                        <i class="bi bi-pencil-square"></i>Update Profile
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/appointments">
                        <i class="bi bi-calendar-check"></i>View Appointment
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/patient/past-visits">
                        <i class="bi bi-clock-history"></i>Past Visits
                    </a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/PATIENT/notification.jsp">
                        <i class="bi bi-bell"></i>Notification
                    </a>
                `;
                
                portalContainer.appendChild(portalDropdown);
                return portalDropdown;
            }

            // Position dropdown relative to trigger
            function positionDropdown() {
                if (!portalDropdown) return;

                const rect = dropdownToggle.getBoundingClientRect();
                const dropdownRect = portalDropdown.getBoundingClientRect();
                
                let top = rect.bottom + 5;
                let left = rect.right - 220; // Align to right edge

                // Adjust if dropdown would go off screen
                if (left < 10) left = 10;
                if (left + 220 > window.innerWidth - 10) {
                    left = window.innerWidth - 230;
                }
                if (top + dropdownRect.height > window.innerHeight - 10) {
                    top = rect.top - dropdownRect.height - 5;
                }

                portalDropdown.style.top = top + 'px';
                portalDropdown.style.left = left + 'px';
            }

            // Show dropdown
            function showDropdown() {
                if (isOpen) return;
                
                createPortalDropdown();
                portalDropdown.style.display = 'block';
                positionDropdown();
                
                // Fade in animation
                portalDropdown.style.opacity = '0';
                portalDropdown.style.transform = 'translateY(-10px)';
                
                requestAnimationFrame(() => {
                    portalDropdown.style.transition = 'opacity 0.2s ease, transform 0.2s ease';
                    portalDropdown.style.opacity = '1';
                    portalDropdown.style.transform = 'translateY(0)';
                });
                
                isOpen = true;
                dropdownToggle.setAttribute('aria-expanded', 'true');
            }

            // Hide dropdown
            function hideDropdown() {
                if (!isOpen || !portalDropdown) return;
                
                portalDropdown.style.opacity = '0';
                portalDropdown.style.transform = 'translateY(-10px)';
                
                setTimeout(() => {
                    if (portalDropdown) {
                        portalDropdown.style.display = 'none';
                    }
                }, 200);
                
                isOpen = false;
                dropdownToggle.setAttribute('aria-expanded', 'false');
            }

            // Toggle dropdown
            function toggleDropdown(e) {
                e.preventDefault();
                e.stopPropagation();
                
                if (isOpen) {
                    hideDropdown();
                } else {
                    showDropdown();
                }
            }

            // Event listeners
            dropdownToggle.addEventListener('click', toggleDropdown);
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                if (isOpen && !dropdownToggle.contains(e.target) && 
                    (!portalDropdown || !portalDropdown.contains(e.target))) {
                    hideDropdown();
                }
            });

            // Close dropdown on escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && isOpen) {
                    hideDropdown();
                }
            });

            // Reposition on window resize
            window.addEventListener('resize', function() {
                if (isOpen) {
                    positionDropdown();
                }
            });

            // Reposition on scroll
            window.addEventListener('scroll', function() {
                if (isOpen) {
                    positionDropdown();
                }
            });

            // Handle dropdown items click
            portalContainer.addEventListener('click', function(e) {
                if (e.target.classList.contains('dropdown-item')) {
                    hideDropdown();
                    // Let the browser navigate normally
                }
            });
        });

        // Backup: Force dropdown to work even if Bootstrap fails
        window.addEventListener('load', function() {
            setTimeout(() => {
                const dropdownToggle = document.getElementById('profileDropdown');
                if (dropdownToggle && !dropdownToggle.hasAttribute('data-dropdown-initialized')) {
                    dropdownToggle.setAttribute('data-dropdown-initialized', 'true');
                    console.log('DocAid: Custom dropdown initialized successfully');
                }
            }, 1000);
        });
    </script>
</body>
</html>
