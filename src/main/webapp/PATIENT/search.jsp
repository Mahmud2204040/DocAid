
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Doctors - DocAid</title>
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
            background: url('${pageContext.request.contextPath}/images/search_hero_section.png') center/cover no-repeat !important;
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
            font-size: 1rem;
            margin-bottom: 1rem;
        }
        
        .doctor-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.2rem;
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
            margin-bottom: 0rem;
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
                <h1 class="hero-title">Find Your Doctor, Instantly</h1>
                <p class="lead hero-subtitle">Explore top-rated specialists and book your appointment today.</p>
                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/search" method="get">
                        <div class="search-input-group">
                            <input type="text" name="q" class="search-input"
                                   placeholder="Search for doctors, specialties, or location..."
                                   aria-label="Search doctors and location" required value="<c:out value='${param.q}'/>">
                            <button class="search-btn" type="submit" aria-label="Search">
                                <i class="bi bi-search" style="margin-right: 0.5rem;"></i> Find Care
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <c:if test="${not empty searchResult}">
            <form action="${pageContext.request.contextPath}/search" method="get" id="filterForm">
                <input type="hidden" name="q" value="<c:out value='${searchQuery}'/>"/>
                <input type="hidden" id="userLat" name="userLat" value="<c:out value='${param.userLat}'/>"/>
                <input type="hidden" id="userLng" name="userLng" value="<c:out value='${param.userLng}'/>"/>

                <div class="filter-bar">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-lg-4 col-md-12 mb-3 mb-lg-0">
                                <span class="results-count">
                                    <span class="count-number">${searchResult.totalResults}</span> doctors found
                                </span>
                            </div>
                            <div class="col-lg-8 col-md-12">
                                <div class="filter-actions justify-content-lg-end">
                                    <div class="form-check form-switch me-3">
                                        <input class="form-check-input" type="checkbox" role="switch" id="filterAvailability" name="filterAvailability" value="today" ${'today' eq param.filterAvailability ? 'checked' : ''}>
                                        <label class="form-check-label" for="filterAvailability">Available Today?</label>
                                    </div>
                                    <div class="input-group me-3" style="width: auto;">
                                        <label class="input-group-text" for="filterRating"><i class="bi bi-star-half"></i></label>
                                        <select class="form-select" id="filterRating" name="filterRating">
                                            <option value="0" ${empty param.filterRating or param.filterRating == '0' ? 'selected' : ''}>Any Rating</option>
                                            <option value="4" ${param.filterRating == '4' ? 'selected' : ''}>4 Stars & Up</option>
                                            <option value="3" ${param.filterRating == '3' ? 'selected' : ''}>3 Stars & Up</option>
                                        </select>
                                    </div>
                                    <div class="input-group" style="width: auto;">
                                        <label class="input-group-text" for="sortBy"><i class="bi bi-sort-down"></i></label>
                                        <select class="form-select" name="sortBy" id="sortBy">
                                            <option value="default" ${empty param.sortBy or param.sortBy == 'default' ? 'selected' : ''}>Relevance</option>
                                            <option value="rating" ${param.sortBy == 'rating' ? 'selected' : ''}>Rating</option>
                                            <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Name</option>
                                            <option value="distance" ${param.sortBy == 'distance' ? 'selected' : ''}>Distance</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container mt-4">
                    <div class="row">
                        <div class="col-md-8">
                            <c:if test="${empty searchResult.doctors}">
                                <div class="empty-state">
                                    <div class="empty-state-icon"><i class="bi bi-search"></i></div>
                                    <h4>No Doctors Found</h4>
                                    <p>Try adjusting your search query or filters.</p>
                                </div>
                            </c:if>

                            <c:forEach var="doctor" items="${searchResult.doctors}">
                                <div class="mb-4">
                                    <%@ include file="_doctor_card.jsp" %>
                                </div>
                            </c:forEach>
            
                            <c:if test="${searchResult.totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${searchResult.currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="changePage(${searchResult.currentPage - 1}); return false;">&laquo;</a>
                                        </li>
                                        <c:forEach begin="1" end="${searchResult.totalPages}" var="i">
                                            <li class="page-item ${searchResult.currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="#" onclick="changePage(${i}); return false;">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${searchResult.currentPage == searchResult.totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="#" onclick="changePage(${searchResult.currentPage + 1}); return false;">&raquo;</a>
                                        </li>
                                    </ul>
                                </nav>
                                <input type="hidden" name="page" id="page" value="${searchResult.currentPage}">
                            </c:if>
                        </div>
                        <div class="col-md-4">
                            <div class="blog-section">
                                <h4 class="mb-4" style="font-weight: 700; color: var(--text-primary);">From Our Blog</h4>
                                <div class="card mb-4 shadow-sm">
                                    <img src="https://www.mayoclinichealthsystem.org/-/media/national-files/images/hometown-health/2022/looking-at-screen-cranberry-sweater.jpg?sc_lang=en&hash=537EDAC1CC98E19CC45F858D7C0F3FCB" class="card-img-top" alt="Blog Image">
                                    <div class="card-body">
                                        <h5 class="card-title" style="font-weight: 600;">A Guide to Medical Specialities</h5>
                                        <p class="card-text text-muted">Choosing a medical specialty is a big decision. This guide will help you understand the different options...</p>
                                        <a href="https://www.oxfordscholastica.com/blog/medicine-articles/a-guide-to-medical-specialities/" target="_blank" class="btn btn-primary mt-2">Read More <i class="bi bi-arrow-right"></i></a>
                                    </div>
                                </div>
                                <div class="card mb-4 shadow-sm">
                                    <img src="https://plus.unsplash.com/premium_photo-1658506671316-0b293df7c72b?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZG9jdG9yfGVufDB8fDB8fHww" class="card-img-top" alt="Blog Image">
                                    <div class="card-body">
                                        <h5 class="card-title" style="font-weight: 600;">Primary Care vs. Specialist: What's the Difference?</h5>
                                        <p class="card-text text-muted">Understand the difference between a primary care physician and a specialist, and when you should see each...</p>
                                        <a href="https://www.san.health/blog/primary-care-vs-specialist-whats-the-difference-and-why-it-matters" target="_blank" class="btn btn-primary mt-2">Read More <i class="bi bi-arrow-right"></i></a>
                                    </div>
                                </div>
                                <div class="card shadow-sm">
                                    <img src="https://blog.practo.com/wp-content/uploads/2023/04/wa-webinar-5-13-1220x600.png" class="card-img-top" alt="Blog Image">
                                    <div class="card-body">
                                        <h5 class="card-title" style="font-weight: 600;">How to Choose Your Doctor</h5>
                                        <p class="card-text text-muted">Choosing a doctor is a big decision. Here are some tips to help you choose the right doctor for you...</p>
                                        <a href="https://blog.practo.com/how-to-choose-your-doctor-listicle-medical-team-practo/" target="_blank" class="btn btn-primary mt-2">Read More <i class="bi bi-arrow-right"></i></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </c:if>
    </main>

    <!-- Local JS -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Run on page load
        document.addEventListener("DOMContentLoaded", function() {
            // Get user location if not already set
            const latInput = document.getElementById('userLat');
            if (!latInput.value && navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    latInput.value = position.coords.latitude;
                    document.getElementById('userLng').value = position.coords.longitude;
                }, function() {
                    // Handle error or denial
                    console.log("Geolocation permission denied or failed.");
                });
            }

            // Add event listeners to filters
            document.getElementById('sortBy').addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
            document.getElementById('filterRating').addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
            document.getElementById('filterAvailability').addEventListener('change', function() {
                document.getElementById('filterForm').submit();
            });
        });

        // Handle pagination click
        function changePage(page) {
            document.getElementById('page').value = page;
            document.getElementById('filterForm').submit();
        }
    </script>
    <%@ include file="_booking_modal.jsp" %>
</body>
</html>