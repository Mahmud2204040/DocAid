<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Hospitals - DocAid</title>
    <!-- Local CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search_page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor_card.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            /* Modern Blue Color System */
            --primary-blue: #3B82F6;
            --primary-blue-light: #60A5FA;
            --primary-blue-dark: #1E40AF;
            --accent-cyan: #06B6D4;
            --accent-cyan-light: #22D3EE;
            
            /* Neutral Colors */
            --background: #F8FAFC;
            --surface: #FFFFFF;
            --surface-elevated: #F1F5F9;
            --border: #E2E8F0;
            --border-hover: #CBD5E1;
            
            /* Text Colors */
            --text-primary: #1E293B;
            --text-secondary: #475569;
            --text-muted: #64748B;
            --text-on-primary: #FFFFFF;
            --text-link: #3B82F6;
            
            /* Semantic Colors */
            --success: #10B981;
            --warning: #F59E0B;
            --error: #EF4444;
            --info: #06B6D4;
            
            /* Gradients */
            --primary-gradient: linear-gradient(135deg, #3B82F6 0%, #06B6D4 100%);
            --hero-gradient: linear-gradient(135deg, #1E40AF 0%, #0891B2 100%);
            --subtle-gradient: linear-gradient(135deg, #F8FAFC 0%, #F1F5F9 100%);
            
            /* Spacing & Layout */
            --border-radius-sm: 0.375rem;
            --border-radius-md: 0.5rem;
            --border-radius-lg: 0.75rem;
            --border-radius-xl: 1rem;
            
            /* Shadows */
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            
            /* Animation */
            --transition-fast: 0.15s ease-in-out;
            --transition-normal: 0.2s ease-in-out;
            --transition-slow: 0.3s ease-in-out;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--background);
            color: var(--text-primary);
            line-height: 1.6;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        
        /* Hero Section Styles */
        .hero {
            position: relative;
            height: 70vh;
            min-height: 500px;
            background: url('${pageContext.request.contextPath}/images/hospital_hero_section.jpg') center/cover no-repeat !important;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .hero-overlay {
            position: absolute; inset:0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        .hero-content {
            position: relative; z-index: 2;
            max-width: 800px; padding: 2rem;
        }
        .hero h1, .hero-title {
            font-size: 3.2rem; font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
            line-height: 1.2;
        }
        .hero .lead, .hero-subtitle {
            font-size: 1.4rem; font-weight: 300;
            margin-bottom: 5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        /* Search Bar Styles */
        .search-container {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 2rem;
            margin-top: 7rem; /* Increased from 5rem to 7rem */
        }
        .search-input-group {
            display: flex; align-items: center;
            border-radius: 50px; overflow: hidden;
        }
        .search-input-group .search-input {
            flex: 1; border: none;
            padding: 1rem 1.5rem 1rem 1.5rem; /* Adjusted padding for icon */
            font-size: 1.1rem; outline: none; background: transparent; color: #333;
        }
        .search-input-group {
            position: relative; /* Needed for absolute positioning of the icon */
        }
        .search-icon-inside {
            position: absolute;
            right: 100px; /* Adjust as needed to place it inside the input, before the button */
            top: 50%;
            transform: translateY(-50%);
            color: #666; /* Placeholder color */
            font-size: 1.1rem;
            z-index: 3; /* Ensure it's above the input */
        }
        .search-input-group .search-input::placeholder {
            color: #666;
        }
        .search-btn {
            background: linear-gradient(135deg, #5aaaff 0%, #98c9ff 100%);
            border: none; padding: 1rem 2rem;
            border-radius: 50px; color: white;
            font-weight: 600; cursor: pointer;
            transition: all 0.3s ease; margin: 4px;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(90, 170, 255, 0.4);
        }
        .search-btn i { font-size: 1.2rem; }
        
        
        /* Filter Bar */
        .filter-bar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 1.5rem 0;
            position: sticky;
            top: 76px;
            z-index: 100;
            backdrop-filter: blur(10px);
        }
        
        .results-count {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .results-count .count-number {
            color: var(--primary-blue);
            font-size: 1.125rem;
        }
        
        .filter-actions {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }
        
        .filter-btn {
            background: var(--surface-elevated);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius-md);
            font-weight: 500;
            font-size: 0.875rem;
            transition: all var(--transition-fast);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-btn:hover {
            background: var(--primary-blue);
            border-color: var(--primary-blue);
            color: var(--text-on-primary);
            transform: translateY(-1px);
        }
        
        .filter-btn.active {
            background: var(--primary-blue);
            border-color: var(--primary-blue);
            color: var(--text-on-primary);
        }
        
        /* Doctor Cards */
        .doctor-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--border-radius-xl);
            padding: 2rem;
            margin-bottom: 1.5rem;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }
        
        .doctor-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
            transform: scaleX(0);
            transition: transform var(--transition-normal);
        }
        
        .doctor-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--border-hover);
        }
        
        .doctor-card:hover::before {
            transform: scaleX(1);
        }
        
        .doctor-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--accent-cyan-light);
            box-shadow: var(--shadow-md);
        }
        
        .doctor-info {
            flex: 1;
        }
        
        .doctor-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }
        
        .doctor-specialty {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--primary-blue);
            margin-bottom: 1rem;
        }
        
        .doctor-location {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            font-size: 0.9375rem;
            margin-bottom: 1rem;
        }
        
        .doctor-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .rating-stars {
            color: #F59E0B;
            font-size: 1.125rem;
        }
        
        .rating-text {
            font-weight: 600;
            color: var(--text-primary);
        }
        
        .rating-count {
            color: var(--text-muted);
            font-size: 0.875rem;
        }
        
        .doctor-badges {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }
        
        .badge-modern {
            padding: 0.375rem 1rem;
            border-radius: var(--border-radius-md);
            font-size: 0.8125rem;
            font-weight: 600;
            letter-spacing: 0.025em;
        }
        
        .badge-success {
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        
        .badge-info {
            background: rgba(6, 182, 212, 0.1);
            color: var(--info);
            border: 1px solid rgba(6, 182, 212, 0.2);
        }
        
        /* Card Actions */
        .doctor-actions {
            border-top: 1px solid var(--border);
            padding-top: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .distance-info {
            color: var(--text-secondary);
            font-weight: 500;
        }
        
        .distance-value {
            color: var(--primary-blue);
            font-weight: 700;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
        }
        
        .btn-outline-modern {
            background: transparent;
            border: 2px solid var(--primary-blue);
            color: var(--primary-blue);
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-md);
            font-weight: 600;
            font-size: 0.9375rem;
            transition: all var(--transition-fast);
        }
        
        .btn-outline-modern:hover {
            background: var(--primary-blue);
            color: var(--text-on-primary);
            transform: translateY(-1px);
        }
        
        .btn-accent {
            background: var(--accent-cyan);
            border: none;
            color: var(--text-on-primary);
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius-md);
            font-weight: 600;
            font-size: 0.9375rem;
            transition: all var(--transition-fast);
        }
        
        .btn-accent:hover {
            background: var(--accent-cyan-light);
            color: var(--text-on-primary);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 0;
        }
        
        .empty-state-icon {
            font-size: 4rem;
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }
        
        .empty-state h4 {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }
        
        .empty-state p {
            color: var(--text-muted);
            font-size: 1.125rem;
        }
        
        /* Pagination */
        .pagination {
            margin-top: 3rem;
            justify-content: center;
        }
        
        .page-link {
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all var(--transition-fast);
        }
        
        .page-link:hover {
            background: var(--primary-blue);
            border-color: var(--primary-blue);
            color: var(--text-on-primary);
        }
        
        .page-item.active .page-link {
            background: var(--primary-blue);
            border-color: var(--primary-blue);
            color: var(--text-on-primary);
        }
        
        /* Loading State */
        .loading-container {
            display: none;
            justify-content: center;
            align-items: center;
            padding: 4rem;
        }
        
        .loading-spinner {
            width: 3rem;
            height: 3rem;
            border: 3px solid var(--border);
            border-top: 3px solid var(--primary-blue);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Alert System */
        .alert-modern {
            position: fixed;
            top: 100px;
            right: 2rem;
            z-index: 1100;
            min-width: 300px;
            max-width: 400px;
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-xl);
            backdrop-filter: blur(10px);
        }
        
        .alert-success {
            background: rgba(16, 185, 129, 0.9);
            color: white;
            border: 1px solid var(--success);
        }
        
        .alert-warning {
            background: rgba(245, 158, 11, 0.9);
            color: white;
            border: 1px solid var(--warning);
        }
        
        .alert-error {
            background: rgba(239, 68, 68, 0.9);
            color: white;
            border: 1px solid var(--error);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero { height: 60vh; min-height: 450px; }
            .hero h1 { font-size: 2.2rem; }
            .hero .lead { font-size: 1.1rem; }
            .search-container { margin: 0 1rem 2rem; }
            .search-input-group .search-input { padding: 0.8rem 1rem; font-size: 1rem; }
            .search-btn { padding: 0.8rem 1.5rem; }
        
            .doctor-card {
                padding: 1.5rem;
            }
        
            .doctor-card .d-flex {
                flex-direction: column;
                text-align: center;
            }
        
            .doctor-avatar {
                width: 100px;
                height: 100px;
                margin: 0 auto 1.5rem;
            }
        
            .action-buttons {
                flex-direction: column;
                width: 100%;
            }
        
            .filter-actions {
                flex-wrap: wrap;
                justify-content: center;
            }
        }
        
        @media (max-width: 576px) {
            .hero { height: 55vh; min-height: 400px; }
            .hero h1 { font-size: 1.8rem; }
            .hero .lead { font-size: 1rem; }
        }
        
        /* Footer Styling */
        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            margin-top: 4rem;
        }
        
        .footer-links a {
            color: var(--text-secondary);
            text-decoration: none;
            margin: 0 1rem;
            transition: color var(--transition-fast);
        }
        
        .footer-links a:hover {
            color: var(--primary-blue);
        }
        
        .social-icons img {
            transition: transform var(--transition-fast);
        }
        
        .social-icons img:hover {
            transform: scale(1.1);
        }
        
        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: var(--surface-elevated);
        }
        
        ::-webkit-scrollbar-thumb {
            background: var(--border-hover);
            border-radius: var(--border-radius-sm);
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: var(--text-muted);
        }
    </style>
</head>
<body>
    <%@ include file="header_patient.jsp" %>

    <main>
        <section class="hero">
            <div class="hero-overlay"></div>
            <div class="hero-content">
                <h1 class="hero-title">Find Your Hospital, Instantly</h1>
                <p class="lead hero-subtitle">Explore top-rated hospitals and find the care you need.</p>
                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/search-hospitals" method="get">
                        <div class="search-input-group">
                            <input type="text" name="q" class="search-input"
                                   placeholder="Search for hospitals, or location..."
                                   aria-label="Search hospitals and location" required value="<c:out value='${param.q}'/>">
                            <button class="search-btn" type="submit" aria-label="Search">
                                <i class="bi bi-search" style="margin-right: 0.5rem;"></i> Find Hospital
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <c:if test="${not empty searchResult}">
            <div class="container mt-5">
                <div class="row">
                    <div class="col-md-8">
                        <h2>Search Results for "<c:out value='${param.q}'/>"</h2>
                        <p class="text-muted">Found ${searchResult.totalResults} hospitals.</p>
                
                        <c:if test="${empty searchResult.hospitals}">
                            <div class="alert alert-info" role="alert">
                                No hospitals found matching your search criteria.
                            </div>
                        </c:if>
                        <c:forEach var="hospital" items="${searchResult.hospitals}">
                            <div class="mb-4">
                                <div class="doctor-card py-3">
                                    <div class="d-flex gap-3">
                                        <div class="flex-shrink-0">
                                            <img src="${pageContext.request.contextPath}/images/hospital_icon.jpg" 
                                                 alt="<c:out value='${hospital.hospitalName}'/>" 
                                                 class="doctor-avatar">
                                        </div>
                                        
                                        <div class="doctor-info flex-grow-1">
                                            <div class="row">
                                                <div class="col-12">
                                                    <h3 class="doctor-name mt-2"><c:out value="${hospital.hospitalName}"/></h3>
                                                </div>
                                            </div>
                                            <div class="row mt-1">
                                                <div class="doctor-location">
                                                        <i class="bi bi-geo-alt"></i>
                                                        <span><c:out value="${hospital.address}"/></span>
                                                    </div>
                                                <div class="col-12">
                                                    <p class="website">
                                                        <c:if test="${not empty hospital.website}">
                                                            <i class="bi bi-globe"></i> <a href="<c:out value='${hospital.website}'/>" target="_blank"><c:out value="${hospital.website}"/></a>
                                                        </c:if>
                                                    </p>
                                                    <p class="email">
                                                        <c:if test="${not empty hospital.email}">
                                                            <i class="bi bi-envelope"></i> <c:out value="${hospital.email}"/>
                                                        </c:if>
                                                    </p>
                                                </div>
                                            </div>

                                            <div class="doctor-actions mt-2">
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/patient/hospital_profile?hospital_id=${hospital.hospitalId}" class="btn btn-outline-modern">View Profile & Tests</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
        
                        <c:if test="${searchResult.totalPages > 1}">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${searchResult.currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?q=${param.q}&page=${searchResult.currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${searchResult.totalPages}" var="i">
                                        <li class="page-item ${searchResult.currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?q=${param.q}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${searchResult.currentPage == searchResult.totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?q=${param.q}&page=${searchResult.currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <div class="blog-section">
                            <h4 class="mb-4" style="font-weight: 700; color: var(--text-primary);">From Our Blog</h4>
                            <div class="card mb-4 shadow-sm">
                                <img src="https://www.apexhospitals.com/_next/image?url=https%3A%2F%2Fbed.apexhospitals.com%2Fuploads%2F1_3_8170253275.jpg&w=1920&q=75" class="card-img-top" alt="Blog Image">
                                <div class="card-body">
                                    <h5 class="card-title" style="font-weight: 600;">Expert Tips on How to Find the Best Hospital for Your Needs</h5>
                                    <p class="card-text text-muted">Choosing the right hospital is a crucial decision. Here are some expert tips to help you find the best hospital for your needs...</p>
                                    <a href="https://www.unitedmedicity.com/blog/expert-tips-on-how-to-find-the-best-hospital-for-your-needs/" target="_blank" class="btn btn-primary mt-2">Read More <i class="bi bi-arrow-right"></i></a>
                                </div>
                            </div>
                            <div class="card shadow-sm">
                                <img src="https://apmedicalcenter.com/wp-content/uploads/2024/05/How-to-Choose-the-Right-Multispeciality-Hospital-for-Your-Needs-2.jpg" class="card-img-top" alt="Blog Image">
                                <div class="card-body">
                                    <h5 class="card-title" style="font-weight: 600;">How to Choose the Right Multispeciality Hospital for Your Needs</h5>
                                    <p class="card-text text-muted">Finding the right multispeciality hospital can be a daunting task. This guide will help you make an informed decision...</p>
                                    <a href="https://apmedicalcenter.com/how-to-choose-the-right-multispeciality-hospital-for-your-needs/" target="_blank" class="btn btn-primary mt-2">Read More <i class="bi bi-arrow-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </main>

    <!-- Local JS -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    
</body>
</html>