<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - DocAid Patient Portal</title>
    
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

        .page-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out;
        }

        .page-subtitle {
            font-size: 1.25rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 600px;
            animation: fadeInUp 1s ease-out 0.2s both;
        }

        .header-icon {
            position: absolute;
            right: 2rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 8rem;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        .quick-actions {
            position: absolute;
            bottom: -2rem;
            right: 2rem;
            z-index: 10;
        }

        .quick-action-btn {
            background: var(--success-gradient);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: var(--shadow-medium);
            transition: var(--transition-medium);
            animation: pulse 2s ease-in-out infinite;
        }

        .quick-action-btn:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-heavy);
            color: white;
            text-decoration: none;
        }

        /* Statistics Cards */
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

        .stat-card.total::before { background: var(--primary-gradient); }
        .stat-card.scheduled::before { background: var(--warning-gradient); }
        .stat-card.completed::before { background: var(--success-gradient); }
        .stat-card.cancelled::before { background: var(--danger-gradient); }

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

        .stat-icon.total { background: var(--primary-gradient); }
        .stat-icon.scheduled { background: var(--warning-gradient); }
        .stat-icon.completed { background: var(--success-gradient); }
        .stat-icon.cancelled { background: var(--danger-gradient); }

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

        /* Insights Cards */
        .insights-section {
            margin: 4rem 0;
        }

        .insight-card {
            background: var(--bg-secondary);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            height: 100%;
        }

        .insight-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }

        .insight-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .insight-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            color: white;
        }

        .insight-icon.next { background: var(--info-gradient); }
        .insight-icon.favorite { background: var(--secondary-gradient); }

        .insight-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .insight-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .insight-subtitle {
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        /* Appointments Table */
        .appointments-section {
            margin: 2rem 0;
        }

        .appointments-card {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .appointments-header {
            padding: 2rem 2rem 1rem;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid var(--border-color);
        }

        .appointments-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .filter-section {
            padding: 1.5rem 2rem;
            background: #f8fafc;
            border-bottom: 1px solid var(--border-color);
        }

        .filter-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .filter-btn {
            padding: 0.5rem 1rem;
            border: 2px solid var(--border-color);
            background: white;
            border-radius: 25px;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition-fast);
        }

        .filter-btn:hover,
        .filter-btn.active {
            background: var(--primary-gradient);
            border-color: transparent;
            color: white;
            transform: translateY(-2px);
        }

        .appointments-table-container {
            padding: 2rem;
            max-height: 600px;
            overflow-y: auto;
        }

        .appointment-item {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            position: relative;
            overflow: hidden;
        }

        .appointment-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            transform: scaleY(0);
            transform-origin: top;
            transition: var(--transition-medium);
        }

        .appointment-item:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }

        .appointment-item:hover::before {
            transform: scaleY(1);
        }

        .appointment-item.scheduled::before { background: var(--warning-gradient); }
        .appointment-item.completed::before { background: var(--success-gradient); }
        .appointment-item.cancelled::before { background: var(--danger-gradient); }

        .appointment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .doctor-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            background: var(--primary-gradient);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            font-weight: 600;
            position: relative;
            overflow: hidden;
        }

        .doctor-avatar::after {
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

        .doctor-details h4 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .doctor-specialty {
            color: var(--text-secondary);
            font-size: 0.9rem;
            padding: 0.25rem 0.75rem;
            background: #e2e8f0;
            border-radius: 20px;
            display: inline-block;
        }

        .appointment-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-scheduled {
            background: rgba(251, 191, 36, 0.1);
            color: #92400e;
            border: 1px solid #fbbf24;
        }

        .status-completed {
            background: rgba(16, 185, 129, 0.1);
            color: #065f46;
            border: 1px solid #10b981;
        }

        .status-cancelled {
            background: rgba(239, 68, 68, 0.1);
            color: #7f1d1d;
            border: 1px solid #ef4444;
        }

        .appointment-meta {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 1rem;
            align-items: center;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .meta-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }

        .meta-icon.date { background: rgba(102, 126, 234, 0.1); color: #667eea; }
        .meta-icon.time { background: rgba(16, 185, 129, 0.1); color: #10b981; }

        .meta-text {
            flex: 1;
        }

        .meta-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }

        .meta-value {
            font-weight: 600;
            color: var(--text-primary);
        }

        .appointment-actions {
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition-fast);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .btn-cancel {
            background: var(--danger-gradient);
            color: white;
        }

        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            color: white;
        }

        .btn-reschedule {
            background: var(--warning-gradient);
            color: #92400e;
        }

        .btn-reschedule:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(251, 191, 36, 0.3);
            color: #92400e;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-muted);
        }

        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .empty-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }

        .empty-subtitle {
            font-size: 1rem;
            max-width: 400px;
            margin: 0 auto 2rem;
        }

        .empty-action {
            background: var(--primary-gradient);
            color: white;
            padding: 1rem 2rem;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition-medium);
        }

        .empty-action:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-heavy);
            color: white;
            text-decoration: none;
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

        @keyframes float {
            0%, 100% { transform: translateY(-50px) rotate(0deg); }
            50% { transform: translateY(-70px) rotate(5deg); }
        }

        @keyframes shine {
            0%, 100% { transform: rotate(45deg) translate(-200%, -200%); }
            50% { transform: rotate(45deg) translate(200%, 200%); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2.5rem;
            }
            
            .header-icon,
            .quick-actions {
                display: none;
            }
            
            .appointment-meta {
                grid-template-columns: 1fr;
                gap: 0.5rem;
            }
            
            .appointment-actions {
                margin-top: 1rem;
                justify-content: flex-start;
            }
            
            .filter-buttons {
                justify-content: flex-start;
            }
            
            .stat-number {
                font-size: 2rem;
            }
            
            .appointments-table-container {
                padding: 1rem;
            }
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 2rem 0 4rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .doctor-info {
                flex-direction: column;
                text-align: center;
                gap: 0.5rem;
            }
            
            .appointment-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }

        /* Custom scrollbar */
        .appointments-table-container::-webkit-scrollbar {
            width: 6px;
        }

        .appointments-table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        .appointments-table-container::-webkit-scrollbar-thumb {
            background: var(--primary-gradient);
            border-radius: 3px;
        }

        .appointments-table-container::-webkit-scrollbar-thumb:hover {
            background: #667eea;
        }
    </style>
</head>

<body>
    <%@ include file="header_patient.jsp" %>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">My Appointments</h1>
                    <p class="page-subtitle">
                        Manage your healthcare appointments with ease. Book new appointments, 
                        track upcoming visits, and stay connected with your healthcare providers.
                    </p>
                </div>
            </div>
            <i class="fas fa-calendar-alt header-icon"></i>
            <div class="quick-actions">
                <a href="book_appointment.jsp" class="quick-action-btn">
                    <i class="fas fa-plus"></i>
                    Book New Appointment
                </a>
            </div>
        </div>
    </div>

    <c:if test="${not empty sessionScope.bookingSuccess}">
        <div class="container mt-4">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <c:out value="${sessionScope.bookingSuccess}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="bookingSuccess" scope="session" />
    </c:if>

    <!-- Statistics Section -->
    <div class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-6 col-lg-3">
                    <div class="stat-card total animate__animated animate__fadeInUp">
                        <div class="stat-icon total">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-number"><c:out value="${totalAppointments}"/></div>
                        <div class="stat-label">Total Appointments</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card scheduled animate__animated animate__fadeInUp animate__delay-1s">
                        <div class="stat-icon scheduled">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-number"><c:out value="${pendingAppointments}"/></div>
                        <div class="stat-label">Scheduled</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card completed animate__animated animate__fadeInUp animate__delay-2s">
                        <div class="stat-icon completed">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-number"><c:out value="${completedAppointments}"/></div>
                        <div class="stat-label">Completed</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card cancelled animate__animated animate__fadeInUp animate__delay-3s">
                        <div class="stat-icon cancelled">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <div class="stat-number"><c:out value="${cancelledAppointments}"/></div>
                        <div class="stat-label">Cancelled</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Insights Section -->
    <div class="insights-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="insight-card animate__animated animate__fadeInLeft">
                        <div class="insight-header">
                            <div class="insight-icon next">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <h3 class="insight-title">Next Appointment</h3>
                        </div>
                        <div class="insight-value"><c:out value="${nextAppointmentDate}"/></div>
                        <div class="insight-subtitle">Your upcoming scheduled visit</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="insight-card animate__animated animate__fadeInRight">
                        <div class="insight-header">
                            <div class="insight-icon favorite">
                                <i class="fas fa-heart"></i>
                            </div>
                            <h3 class="insight-title">Favorite Doctor</h3>
                        </div>
                        <div class="insight-value"><c:out value="${favoriteDoctor}"/></div>
                        <div class="insight-subtitle">Most visited healthcare provider</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Appointments Section -->
    <div class="appointments-section">
        <div class="container">
            <div class="appointments-card">
                <!-- Appointments Header -->
                <div class="appointments-header">
                    <h2 class="appointments-title">
                        <i class="fas fa-list"></i>
                        Appointment History
                    </h2>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="filter-buttons">
                        <button class="filter-btn active" data-filter="all">All</button>
                        <button class="filter-btn" data-filter="scheduled">Scheduled</button>
                        <button class="filter-btn" data-filter="completed">Completed</button>
                        <button class="filter-btn" data-filter="cancelled">Cancelled</button>
                    </div>
                </div>

                <!-- Appointments List -->
                <div class="appointments-table-container">
                    <c:if test="${empty appointments}">
                        <div class="empty-state">
                            <i class="fas fa-calendar-times empty-icon"></i>
                            <h3 class="empty-title">No Appointments Found</h3>
                            <p class="empty-subtitle">
                                You haven't scheduled any appointments yet. Start your healthcare journey 
                                by booking your first appointment with one of our qualified doctors.
                            </p>
                            <a href="book_appointment.jsp" class="empty-action">
                                <i class="fas fa-plus"></i>
                                Book Your First Appointment
                            </a>
                        </div>
                    </c:if>
                    <c:forEach var="app" items="${appointments}">
                        <div class="appointment-item ${app.status.toLowerCase()}" data-status="${app.status.toLowerCase()}">
                            <div class="appointment-header">
                                <div class="doctor-info">
                                    <div class="doctor-avatar">
                                        <c:out value="${app.doctorInitial}"/>
                                    </div>
                                    <div class="doctor-details">
                                        <h4><c:out value="${app.doctorName}"/></h4>
                                        <span class="doctor-specialty">
                                            <i class="fas fa-stethoscope me-1"></i>
                                            <c:out value="${app.specialty}"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="appointment-status status-${app.status.toLowerCase()}">
                                    <i class="fas fa-${app.status.toLowerCase() == 'scheduled' ? 'clock' : (app.status.toLowerCase() == 'completed' ? 'check-circle' : 'times-circle')}"></i>
                                    <c:out value="${app.status}"/>
                                </div>
                            </div>
                            
                            <div class="appointment-meta">
                                <div class="meta-item">
                                    <div class="meta-icon date">
                                        <i class="fas fa-calendar"></i>
                                    </div>
                                    <div class="meta-text">
                                        <div class="meta-label">Date</div>
                                        <div class="meta-value"><c:out value="${app.appointmentDate}"/></div>
                                    </div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-icon time">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div class="meta-text">
                                        <div class="meta-label">Time</div>
                                        <div class="meta-value"><c:out value="${app.appointmentTime}"/></div>
                                    </div>
                                </div>
                                <div class="appointment-actions">
                                    <c:if test="${app.canReschedule}">
                                        <a href="reschedule_appointment.jsp?id=${app.appointmentId}" class="action-btn btn-reschedule">
                                            <i class="fas fa-calendar-alt"></i>
                                            Reschedule
                                        </a>
                                    </c:if>
                                    <c:if test="${app.canCancel}">
                                        <form style="display:inline;" action="cancel_appointment.jsp" method="post" 
                                              onsubmit="return confirm('⚠️ Are you sure you want to cancel this appointment? This action cannot be undone.');">
                                            <input type="hidden" name="appointment_id" value="${app.appointmentId}">
                                            <button type="submit" class="action-btn btn-cancel">
                                                <i class="fas fa-times"></i>
                                                Cancel
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${!app.canCancel && !app.canReschedule}">
                                        <span class="text-muted">No actions available</span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Filter functionality
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                const filter = this.dataset.filter;
                const appointmentItems = document.querySelectorAll('.appointment-item');
                
                appointmentItems.forEach(item => {
                    const status = item.dataset.status;
                    
                    if (filter === 'all') {
                        item.style.display = 'block';
                        item.classList.add('animate__fadeInUp');
                    } else {
                        if (status === filter) {
                            item.style.display = 'block';
                            item.classList.add('animate__fadeInUp');
                        } else {
                            item.style.display = 'none';
                        }
                    }
                });
            });
        });

        // Enhanced confirmation for cancel actions
        document.querySelectorAll('form[action="cancel_appointment.jsp"]').forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Create custom modal-like confirmation
                const result = confirm(`
🏥 DocAid - Appointment Cancellation

⚠️ You are about to cancel your appointment.

Important Notes:
• This action cannot be undone
• You may be charged a cancellation fee
• Please reschedule as soon as possible

Are you sure you want to proceed?
                `);
                
                if (result) {
                    // Add loading state
                    const submitBtn = this.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Cancelling...';
                    submitBtn.disabled = true;
                    
                    // Submit after short delay for better UX
                    setTimeout(() => {
                        this.submit();
                    }, 1000);
                }
            });
        });

        // Animate stats on scroll
        const observerOptions = {
            threshold: 0.3,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const statNumber = entry.target.querySelector('.stat-number');
                    const finalNumber = parseInt(statNumber.textContent);
                    let currentNumber = 0;
                    
                    const increment = finalNumber / 30; // Animate over 30 frames
                    
                    const counter = setInterval(() => {
                        currentNumber += increment;
                        if (currentNumber >= finalNumber) {
                            statNumber.textContent = finalNumber;
                            clearInterval(counter);
                        } else {
                            statNumber.textContent = Math.floor(currentNumber);
                        }
                    }, 50);
                    
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card').forEach(card => {
            observer.observe(card);
        });

        // Add pulse animation to urgent appointments
        document.querySelectorAll('.appointment-item').forEach(item => {
            const status = item.dataset.status;
            if (status === 'scheduled') {
                const dateElement = item.querySelector('.meta-value');
                const dateText = dateElement.textContent;
                
                try {
                    const appointmentDate = new Date(dateText);
                    const today = new Date();
                    const timeDiff = appointmentDate.getTime() - today.getTime();
                    const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    
                    if (daysDiff <= 1 && daysDiff >= 0) {
                        // Add urgent styling for appointments within 24 hours
                        item.style.borderLeft = '4px solid #ef4444';
                        item.querySelector('.appointment-status').style.animation = 'pulse 2s ease-in-out infinite';
                    }
                } catch (e) {
                    // Handle date parsing errors gracefully
                }
            }
        });

        // Auto-refresh appointments every 5 minutes
        setInterval(() => {
            // You can implement auto-refresh logic here if needed
            console.log('Auto-refresh check...');
        }, 300000); // 5 minutes

        // Smooth scroll for better navigation
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

        // Add loading states for all interactive elements
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (!this.disabled) {
                    this.style.opacity = '0.7';
                    this.style.pointerEvents = 'none';
                    
                    // Reset after 3 seconds (fallback)
                    setTimeout(() => {
                        this.style.opacity = '1';
                        this.style.pointerEvents = 'auto';
                    }, 3000);
                }
            });
        });

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