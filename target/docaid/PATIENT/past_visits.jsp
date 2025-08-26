<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Past Visits - DocAid Patient Portal</title>
    
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
            --dark-gradient: linear-gradient(135deg, #434343 0%, #000000 100%);
            
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

        /* Statistics Cards */
        .stats-section {
            margin-top: -3rem;
            position: relative;
            z-index: 10;
        }

        .stat-card {
            background: var(--bg-secondary);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: var(--shadow-medium);
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
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

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }

        .stat-icon.primary { background: var(--primary-gradient); }
        .stat-icon.success { background: var(--success-gradient); }
        .stat-icon.warning { background: var(--warning-gradient); }

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

        /* Main Content */
        .main-content {
            padding: 4rem 0;
        }

        .content-card {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        .content-header {
            padding: 2rem 2rem 0;
            border-bottom: 1px solid var(--border-color);
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        }

        .search-filter-section {
            padding: 2rem;
            background: #f8fafc;
            border-bottom: 1px solid var(--border-color);
        }

        .search-box {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--border-color);
            border-radius: 15px;
            font-size: 1rem;
            transition: var(--transition-fast);
            background: white;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }

        .filter-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
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

        /* Visit Cards */
        .visits-container {
            padding: 2rem;
        }

        .visit-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
            transition: var(--transition-medium);
            position: relative;
            overflow: hidden;
        }

        .visit-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--success-gradient);
            transform: scaleY(0);
            transform-origin: top;
            transition: var(--transition-medium);
        }

        .visit-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }

        .visit-card:hover::before {
            transform: scaleY(1);
        }

        .doctor-info {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
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
            margin-right: 1rem;
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

        .visit-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-top: 1rem;
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

        .status-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.5rem 1rem;
            background: var(--success-gradient);
            color: white;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
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
            margin: 0 auto;
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
            
            .header-icon {
                display: none;
            }
            
            .visit-meta {
                grid-template-columns: 1fr;
            }
            
            .filter-buttons {
                justify-content: center;
            }
            
            .stat-number {
                font-size: 2rem;
            }
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 2rem 0 4rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .stat-card,
            .visit-card {
                margin-bottom: 1rem;
            }
        }

        /* Loading Animation */
        .loading-spinner {
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

        /* Scroll to top button */
        .scroll-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 1.25rem;
            cursor: pointer;
            box-shadow: var(--shadow-medium);
            transition: var(--transition-medium);
            opacity: 0;
            visibility: hidden;
            z-index: 1000;
        }

        .scroll-top.visible {
            opacity: 1;
            visibility: visible;
        }

        .scroll-top:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-heavy);
        }
    </style>
</head>

<body>
    <jsp:include page="header_patient.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">Past Visits</h1>
                    <p class="page-subtitle">
                        Complete history of your medical consultations and appointments. 
                        Track your healthcare journey with detailed visit records.
                    </p>
                </div>
            </div>
            <i class="fas fa-history header-icon"></i>
        </div>
    </div>

    <!-- Statistics Section -->
    <div class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="stat-card animate__animated animate__fadeInUp">
                        <div class="stat-icon primary">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-number"><c:out value="${totalVisits}"/></div>
                        <div class="stat-label">Total Visits</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card animate__animated animate__fadeInUp animate__delay-1s">
                        <div class="stat-icon success">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="stat-number" style="font-size: 1.5rem;"><c:out value="${mostVisitedSpecialty}"/></div>
                        <div class="stat-label">Most Visited Specialty</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card animate__animated animate__fadeInUp animate__delay-2s">
                        <div class="stat-icon warning">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-number" style="font-size: 1.2rem;"><c:out value="${lastVisitDate}"/></div>
                        <div class="stat-label">Last Visit</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <div class="content-card">
                <!-- Search and Filter Section -->
                <div class="search-filter-section">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="search-box">
                                <input type="text" class="search-input" id="searchInput" 
                                       placeholder="Search by doctor name or specialty...">
                                <i class="fas fa-search search-icon"></i>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="filter-buttons">
                                <button class="filter-btn active" data-filter="all">All</button>
                                <button class="filter-btn" data-filter="recent">Recent</button>
                                <button class="filter-btn" data-filter="cardiology">Cardiology</button>
                                <button class="filter-btn" data-filter="neurology">Neurology</button>
                                <button class="filter-btn" data-filter="orthopedic">Orthopedic</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Visits Container -->
                <div class="visits-container">
                    <c:if test="${empty pastVisits}">
                        <div class="empty-state">
                            <i class="fas fa-calendar-times empty-icon"></i>
                            <h3 class="empty-title">No Past Visits Found</h3>
                            <p class="empty-subtitle">
                                You haven't completed any appointments yet. Once you complete your first appointment, 
                                it will appear here for your reference.
                            </p>
                        </div>
                    </c:if>
                    <c:if test="${not empty pastVisits}">
                        <div class="row" id="visitsContainer">
                            <c:forEach var="visit" items="${pastVisits}">
                                <div class="col-lg-6 col-xl-4 visit-item" 
                                     data-doctor="${visit.doctorName.toLowerCase()}"
                                     data-specialty="${visit.specialty.toLowerCase()}">
                                    <div class="visit-card animate__animated animate__fadeInUp">
                                        <div class="status-badge">
                                            <i class="fas fa-check-circle me-1"></i>
                                            <c:out value="${visit.status}"/>
                                        </div>
                                        
                                        <div class="doctor-info">
                                            <div class="doctor-avatar">
                                                <c:out value="${visit.doctorInitial}"/>
                                            </div>
                                            <div class="doctor-details">
                                                <h4><c:out value="${visit.doctorName}"/></h4>
                                                <span class="doctor-specialty">
                                                    <i class="fas fa-stethoscope me-1"></i>
                                                    <c:out value="${visit.specialty}"/>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="visit-meta">
                                            <div class="meta-item">
                                                <div class="meta-icon date">
                                                    <i class="fas fa-calendar"></i>
                                                </div>
                                                <div class="meta-text">
                                                    <div class="meta-label">Date</div>
                                                    <div class="meta-value"><c:out value="${visit.appointmentDate}"/></div>
                                                </div>
                                            </div>
                                            <div class="meta-item">
                                                <div class="meta-icon time">
                                                    <i class="fas fa-clock"></i>
                                                </div>
                                                <div class="meta-text">
                                                    <div class="meta-label">Time</div>
                                                    <div class="meta-value"><c:out value="${visit.appointmentTimeFormatted}"/></div>
                                                </div>
                                            </div>
                                        </div>
                                        <c:if test="${visit.status eq 'Completed'}">
                                            <div class="d-grid mt-3">
                                                <c:if test="${visit.hasReviewed}">
                                                    <button class="btn btn-secondary btn-sm" disabled>
                                                        <i class="fas fa-check-circle me-1"></i> You already reviewed
                                                    </button>
                                                </c:if>
                                                <c:if test="${not visit.hasReviewed}">
                                                    <a href="${pageContext.request.contextPath}/PATIENT/give_review.jsp?doctorId=${visit.doctorId}&doctorName=${visit.doctorName}" class="btn btn-primary btn-sm">
                                                        <i class="fas fa-star me-1"></i> Give Review
                                                    </a>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop">
        <i class="fas fa-arrow-up"></i>
    </button>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const visitItems = document.querySelectorAll('.visit-item');
            
            visitItems.forEach(item => {
                const doctorName = item.dataset.doctor;
                const specialty = item.dataset.specialty;
                
                if (doctorName.includes(searchTerm) || specialty.includes(searchTerm)) {
                    item.style.display = 'block';
                    item.classList.add('animate__fadeInUp');
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // Filter functionality
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                const filter = this.dataset.filter;
                const visitItems = document.querySelectorAll('.visit-item');
                
                visitItems.forEach(item => {
                    const specialty = item.dataset.specialty;
                    
                    if (filter === 'all') {
                        item.style.display = 'block';
                    } else if (filter === 'recent') {
                        // Show only first 3 items for recent filter
                        const index = Array.from(visitItems).indexOf(item);
                        item.style.display = index < 3 ? 'block' : 'none';
                    } else {
                        item.style.display = specialty.includes(filter) ? 'block' : 'none';
                    }
                });
            });
        });

        // Scroll to top functionality
        const scrollTopBtn = document.getElementById('scrollTop');
        
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                scrollTopBtn.classList.add('visible');
            } else {
                scrollTopBtn.classList.remove('visible');
            }
        });
        
        scrollTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });

        // Add stagger animation to cards
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate__fadeInUp');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.visit-card').forEach(card => {
            observer.observe(card);
        });

        // Add loading states for interactions
        document.querySelectorAll('.visit-card').forEach(card => {
            card.addEventListener('click', function() {
                // Add a subtle pulse animation on click
                this.style.animation = 'pulse 0.3s ease-in-out';
                setTimeout(() => {
                    this.style.animation = '';
                }, 300);
            });
        });
    </script>
</body>
</html>
