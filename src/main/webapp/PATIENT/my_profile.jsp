<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - DocAid Patient Portal</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning-gradient: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            --danger-gradient: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --info-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            
            --bg-primary: #f8fafc;
            --bg-secondary: #ffffff;
            --text-primary: #1a202c;
            --text-secondary: #4a5568;
            --text-muted: #718096;
            --border-color: #e2e8f0;
            --shadow-light: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-medium: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-heavy: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            
            --transition-fast: all 0.2s ease-in-out;
            --transition-medium: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --transition-slow: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Header Styles */
        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 4rem 0 6rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .page-header .container {
            position: relative;
            z-index: 2;
        }

        .profile-hero {
            display: flex;
            align-items: center;
            gap: 2rem;
            animation: fadeInUp 1s ease-out;
        }

        .profile-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 24px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 700;
            border: 4px solid rgba(255, 255, 255, 0.3);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
        }

        .profile-avatar-large::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.3) 50%, rgba(255,255,255,0.1) 100%);
            transform: rotate(45deg) translate(-50%, -50%);
            animation: shine 3s ease-in-out infinite;
        }

        .profile-info h1 {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .profile-subtitle {
            font-size: 1.25rem;
            font-weight: 300;
            opacity: 0.9;
            margin-bottom: 1rem;
        }

        .profile-badges {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .profile-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .header-actions {
            position: absolute;
            bottom: -2rem;
            right: 2rem;
            z-index: 10;
            display: flex;
            gap: 1rem;
        }

        .action-btn {
            background: var(--success-gradient);
            color: white;
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: var(--shadow-medium);
            transition: var(--transition-medium);
        }

        .action-btn:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-heavy);
            color: white;
            text-decoration: none;
        }

        .action-btn.edit {
            background: var(--warning-gradient);
        }

        /* Statistics Section */
        .stats-section {
            margin-top: -3rem;
            position: relative;
            z-index: 10;
        }

        .stat-card {
            background: var(--bg-secondary);
            border-radius: 20px;
            padding: 2rem 1.5rem;
            box-shadow: var(--shadow-medium);
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            position: relative;
            overflow: hidden;
            text-align: center;
            height: 100%;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            transform: scaleX(0);
            transform-origin: left;
            transition: var(--transition-medium);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-heavy);
        }

        .stat-card:hover::before {
            transform: scaleX(1);
        }

        .stat-card.appointments::before { background: var(--primary-gradient); }
        .stat-card.visits::before { background: var(--success-gradient); }
        .stat-card.joined::before { background: var(--info-gradient); }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin: 0 auto 1rem;
        }

        .stat-icon.appointments { background: var(--primary-gradient); }
        .stat-icon.visits { background: var(--success-gradient); }
        .stat-icon.joined { background: var(--info-gradient); }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.875rem;
        }

        /* Profile Details Section */
        .profile-section {
            margin: 4rem 0;
        }

        .profile-card {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .profile-card-header {
            padding: 2rem 2rem 1rem;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid var(--border-color);
        }

        .profile-card-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .profile-card-body {
            padding: 2rem;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .profile-item {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 16px;
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            position: relative;
            overflow: hidden;
        }

        .profile-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary-gradient);
            transform: scaleY(0);
            transform-origin: top;
            transition: var(--transition-medium);
        }

        .profile-item:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }

        .profile-item:hover::before {
            transform: scaleY(1);
        }

        .profile-item-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .profile-item-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: white;
            background: var(--primary-gradient);
        }

        .profile-item-label {
            font-size: 0.875rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin: 0;
        }

        .profile-item-value {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
            word-break: break-word;
        }

        /* Health Summary Section */
        .health-summary {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            overflow: hidden;
            margin-top: 2rem;
        }

        .health-summary-header {
            padding: 2rem 2rem 1rem;
            background: linear-gradient(135deg, #fef3f2 0%, #fee2e2 100%);
            border-bottom: 1px solid var(--border-color);
        }

        .health-summary-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .health-summary-body {
            padding: 2rem;
        }

        .health-items {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .health-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: linear-gradient(135deg, #ffffff 0%, #fefefe 100%);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            transition: var(--transition-fast);
        }

        .health-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-light);
        }

        .health-item-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            color: white;
        }

        .health-item-icon.blood { background: var(--danger-gradient); }
        .health-item-icon.gender { background: var(--secondary-gradient); }
        .health-item-icon.birth { background: var(--warning-gradient); }

        .health-item-content h4 {
            font-size: 0.875rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin: 0 0 0.25rem 0;
        }

        .health-item-content p {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        /* Quick Actions Section */
        .quick-actions-section {
            margin: 2rem 0;
        }

        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .quick-action-card {
            background: var(--bg-secondary);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            text-decoration: none;
            color: inherit;
            position: relative;
            overflow: hidden;
        }

        .quick-action-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            transform: scaleX(0);
            transform-origin: left;
            transition: var(--transition-medium);
        }

        .quick-action-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-heavy);
            text-decoration: none;
            color: inherit;
        }

        .quick-action-card:hover::before {
            transform: scaleX(1);
        }

        .quick-action-card.update::before { background: var(--warning-gradient); }
        .quick-action-card.appointments::before { background: var(--primary-gradient); }
        .quick-action-card.history::before { background: var(--success-gradient); }

        .quick-action-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .quick-action-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: white;
        }

        .quick-action-icon.update { background: var(--warning-gradient); }
        .quick-action-icon.appointments { background: var(--primary-gradient); }
        .quick-action-icon.history { background: var(--success-gradient); }

        .quick-action-content h3 {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0 0 0.25rem 0;
        }

        .quick-action-content p {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin: 0;
            line-height: 1.4;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes shine {
            0%, 100% { transform: rotate(45deg) translate(-200%, -200%); }
            50% { transform: rotate(45deg) translate(200%, 200%); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-hero {
                flex-direction: column;
                text-align: center;
                gap: 1.5rem;
            }
            
            .profile-info h1 {
                font-size: 2.5rem;
            }
            
            .header-actions {
                position: static;
                justify-content: center;
                margin-top: 2rem;
            }
            
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .health-items {
                grid-template-columns: 1fr;
            }
            
            .quick-actions-grid {
                grid-template-columns: 1fr;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 2rem 0 4rem;
            }
            
            .profile-info h1 {
                font-size: 2rem;
            }
            
            .profile-avatar-large {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
            }
            
            .profile-card-body {
                padding: 1.5rem;
            }
            
            .health-summary-body {
                padding: 1.5rem;
            }
        }

        /* Loading Animation */
        .loading-animation {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>

<body>
    <c:set var="patientName" value="${patient.firstName} ${patient.lastName}" />
    <c:set var="initials" value="${fn:substring(patient.firstName, 0, 1)}${fn:substring(patient.lastName, 0, 1)}" />

    <%@ include file="header_patient.jsp" %>

    <!-- Page Header with Profile Hero -->
    <div class="page-header">
        <div class="container">
            <div class="profile-hero">
                <div class="profile-avatar-large">
                    <c:out value="${initials}" />
                </div>
                <div class="profile-info">
                    <h1><c:out value="${patientName}" /></h1>
                    <p class="profile-subtitle">DocAid Patient Portal Member</p>
                    <div class="profile-badges">
                        <span class="profile-badge">
                            <i class="fas fa-shield-alt me-1"></i>
                            Verified Account
                        </span>
                        <span class="profile-badge">
                            <i class="fas fa-heart me-1"></i>
                            Healthcare Member
                        </span>
                    </div>
                </div>
            </div>
            
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/patient/update-profile" class="action-btn edit">
                    <i class="fas fa-edit"></i>
                    Edit Profile
                </a>
                <a href="${pageContext.request.contextPath}/patient/appointments" class="action-btn">
                    <i class="fas fa-calendar"></i>
                    My Appointments
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty sessionScope.updateMessage}">
        <div class="container mt-4">
            <div class="alert alert-${sessionScope.updateStatus == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                ${sessionScope.updateMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="updateMessage" scope="session" />
        <c:remove var="updateStatus" scope="session" />
    </c:if>

    <!-- Statistics Section -->
    <div class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card appointments animate__animated animate__fadeInUp">
                        <div class="stat-icon appointments">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-number"><c:out value="${totalAppointments}" /></div>
                        <div class="stat-label">Total Appointments</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card visits animate__animated animate__fadeInUp animate__delay-1s">
                        <div class="stat-icon visits">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-number"><c:out value="${completedVisits}" /></div>
                        <div class="stat-label">Completed Visits</div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Profile Details Section -->
    <div class="profile-section">
        <div class="container">
            <div class="profile-card animate__animated animate__fadeInUp">
                <div class="profile-card-header">
                    <h2 class="profile-card-title">
                        <i class="fas fa-user-circle"></i>
                        Personal Information
                    </h2>
                </div>
                <div class="profile-card-body">
                    <div class="profile-grid">
                        <div class="profile-item animate__animated animate__fadeInLeft">
                            <div class="profile-item-header">
                                <div class="profile-item-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div>
                                    <h3 class="profile-item-label">Full Name</h3>
                                    <p class="profile-item-value"><c:out value="${patientName}" /></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="profile-item animate__animated animate__fadeInRight">
                            <div class="profile-item-header">
                                <div class="profile-item-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div>
                                    <h3 class="profile-item-label">Email Address</h3>
                                    <p class="profile-item-value"><c:out value="${patient.email}" /></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="profile-item animate__animated animate__fadeInLeft">
                            <div class="profile-item-header">
                                <div class="profile-item-icon">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div>
                                    <h3 class="profile-item-label">Phone Number</h3>
                                    <p class="profile-item-value"><c:out value="${patient.phone}" /></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="profile-item animate__animated animate__fadeInRight">
                            <div class="profile-item-header">
                                <div class="profile-item-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div>
                                    <h3 class="profile-item-label">Address</h3>
                                    <p class="profile-item-value"><c:out value="${patient.address}" /></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Health Summary Section -->
    <div class="profile-section">
        <div class="container">
            <div class="health-summary animate__animated animate__fadeInUp">
                <div class="health-summary-header">
                    <h2 class="health-summary-title">
                        <i class="fas fa-heartbeat"></i>
                        Health Information
                    </h2>
                </div>
                <div class="health-summary-body">
                    <div class="health-items">
                        <div class="health-item animate__animated animate__zoomIn">
                            <div class="health-item-icon blood">
                                <i class="fas fa-tint"></i>
                            </div>
                            <div class="health-item-content">
                                <h4>Blood Group</h4>
                                <p><c:out value="${patient.bloodType}" /></p>
                            </div>
                        </div>
                        
                        <div class="health-item animate__animated animate__zoomIn animate__delay-1s">
                            <div class="health-item-icon gender">
                                <i class="fas fa-venus-mars"></i>
                            </div>
                            <div class="health-item-content">
                                <h4>Gender</h4>
                                <p><c:out value="${patient.gender}" /></p>
                            </div>
                        </div>
                        
                        <div class="health-item animate__animated animate__zoomIn animate__delay-2s">
                            <div class="health-item-icon birth">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="health-item-content">
                                <h4>Date of Birth</h4>
                                <p><c:out value="${patient.dateOfBirth}" /></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions Section -->
    <div class="quick-actions-section">
        <div class="container">
            <div class="row mb-4">
                <div class="col-12">
                    <h2 class="text-center mb-4">
                        <i class="fas fa-bolt me-2"></i>
                        Quick Actions
                    </h2>
                </div>
            </div>
            <div class="quick-actions-grid">
                <a href="${pageContext.request.contextPath}/patient/update-profile" class="quick-action-card update animate__animated animate__fadeInUp">
                    <div class="quick-action-header">
                        <div class="quick-action-icon update">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <div class="quick-action-content">
                            <h3>Update Profile</h3>
                            <p>Edit your personal information, contact details, and health data</p>
                        </div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/patient/appointments" class="quick-action-card appointments animate__animated animate__fadeInUp animate__delay-1s">
                    <div class="quick-action-header">
                        <div class="quick-action-icon appointments">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="quick-action-content">
                            <h3>View Appointments</h3>
                            <p>Check your scheduled appointments and manage your healthcare visits</p>
                        </div>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/patient/past-visits" class="quick-action-card history animate__animated animate__fadeInUp animate__delay-2s">
                    <div class="quick-action-header">
                        <div class="quick-action-icon history">
                            <i class="fas fa-history"></i>
                        </div>
                        <div class="quick-action-content">
                            <h3>Visit History</h3>
                            <p>Review your past medical visits and appointment history</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Animate statistics numbers on scroll
        const observerOptions = {
            threshold: 0.3,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const statNumber = entry.target.querySelector('.stat-number');
                    const finalNumber = parseInt(statNumber.textContent) || 0;
                    let currentNumber = 0;
                    
                    if (finalNumber > 0) {
                        const increment = finalNumber / 30;
                        
                        const counter = setInterval(() => {
                            currentNumber += increment;
                            if (currentNumber >= finalNumber) {
                                statNumber.textContent = finalNumber;
                                clearInterval(counter);
                            } else {
                                statNumber.textContent = Math.floor(currentNumber);
                            }
                        }, 50);
                    }
                    
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card').forEach(card => {
            observer.observe(card);
        });

        // Add floating animation to profile avatar
        const profileAvatar = document.querySelector('.profile-avatar-large');
        if (profileAvatar) {
            profileAvatar.style.animation = 'float 6s ease-in-out infinite';
        }

        // Add subtle pulse to quick action cards
        document.querySelectorAll('.quick-action-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.animation = 'pulse 0.6s ease-in-out';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.animation = '';
            });
        });

        // Add loading states for navigation
        document.querySelectorAll('a[href$="_profile.jsp"]').forEach(link => {
            link.addEventListener('click', function(e) {
                const loadingSpinner = document.createElement('span');
                loadingSpinner.className = 'loading-animation ms-2';
                this.appendChild(loadingSpinner);
                
                // Remove spinner after 3 seconds (fallback)
                setTimeout(() => {
                    if (loadingSpinner.parentNode) {
                        loadingSpinner.remove();
                    }
                }, 3000);
            });
        });

        // Add smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Auto-refresh profile data every 10 minutes
        setInterval(() => {
            console.log('Auto-refresh check for profile data...');
            // You can implement actual refresh logic here if needed
        }, 600000); // 10 minutes

        // Add entrance animations with staggered delays
        const animateElements = document.querySelectorAll('.profile-item, .health-item, .quick-action-card');
        animateElements.forEach((element, index) => {
            element.style.animationDelay = `${index * 0.1}s`;
        });

        // Copy email to clipboard functionality
        const emailElement = document.querySelector('.profile-item-value');
        if (emailElement && emailElement.textContent.includes('@')) {
            emailElement.style.cursor = 'pointer';
            emailElement.title = 'Click to copy email';
            
            emailElement.addEventListener('click', async function() {
                try {
                    await navigator.clipboard.writeText(this.textContent);
                    
                    // Show success feedback
                    const originalText = this.textContent;
                    this.textContent = 'Email copied!';
                    this.style.color = '#10b981';
                    
                    setTimeout(() => {
                        this.textContent = originalText;
                        this.style.color = '';
                    }, 2000);
                } catch (err) {
                    console.log('Failed to copy email');
                }
            });
        }

        // Initialize tooltips if available
        if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }
    </script>
</body>
</html>
        }
    </script>
</body>
</html>