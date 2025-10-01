<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${hospital.hospitalName}"/> - DocAid</title>
    
    <!-- Bootstrap 5 & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    
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
            --info-gradient: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            
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
            padding: 3rem 0 5rem;
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

        /* Main Content */
        .main-content {
            margin-top: -3rem;
            position: relative;
            z-index: 10;
        }

        /* Card Styles */
        .content-card {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-light);
            border: 1px solid var(--border-color);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: var(--transition-medium);
        }

        .content-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-medium);
        }

        /* Hospital Profile Card */
        .hospital-profile-card {
            padding: 2rem;
            text-align: center;
        }

        .hospital-avatar {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            object-fit: cover;
            object-position: center;
            box-shadow: var(--shadow-medium);
            margin-bottom: 1.5rem;
            border: 4px solid white;
            position: relative;
            overflow: hidden;
        }

        .hospital-avatar::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.1) 50%, rgba(255,255,255,0) 100%);
            transform: rotate(45deg);
            animation: shine 3s ease-in-out infinite;
        }

        .hospital-name {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        /* Details Card */
        .details-card {
            padding: 2rem;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1rem;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -4px;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary-gradient);
            border-radius: 2px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 0.75rem;
            border-radius: 12px;
            background: rgba(102, 126, 234, 0.05);
            transition: var(--transition-fast);
        }

        .detail-item:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateX(4px);
        }

        .detail-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            color: white;
        }

        .detail-icon.location { background: var(--primary-gradient); }
        .detail-icon.website { background: var(--success-gradient); }
        .detail-icon.email { background: var(--warning-gradient); }
        .detail-icon.phone { background: linear-gradient(135deg, #2af598 0%, #009efd 100%); }

        .detail-text {
            flex: 1;
        }

        .detail-label {
            font-weight: 600;
            color: var(--text-primary);
        }

        .detail-value {
            color: var(--text-secondary);
            margin-top: 0.25rem;
        }

        .detail-value a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: var(--transition-fast);
        }

        .detail-value a:hover {
            color: #667eea;
            text-decoration: underline;
        }

        /* Tests Table */
        .tests-card {
            padding: 2rem;
        }

        .custom-table {
            margin-bottom: 0;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow-light);
        }

        .custom-table thead {
            background: var(--primary-gradient);
            color: white;
        }

        .custom-table thead th {
            border: none;
            padding: 1rem;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .custom-table tbody tr {
            transition: var(--transition-fast);
        }

        .custom-table tbody tr:hover {
            background: rgba(102, 126, 234, 0.05);
            transform: scale(1.01);
        }

        .custom-table tbody td {
            padding: 1rem;
            border: none;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .test-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .price-badge {
            background: var(--success-gradient);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
            display: inline-block;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
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
        @keyframes shine {
            0%, 100% { transform: rotate(45deg) translate(-200%, -200%); }
            50% { transform: rotate(45deg) translate(200%, 200%); }
        }

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

        /* Responsive Design */
        @media (max-width: 768px) {
            .hospital-avatar {
                width: 150px;
                height: 150px;
            }
            
            .hospital-name {
                font-size: 1.5rem;
            }
            
            .detail-item {
                flex-direction: column;
                text-align: center;
            }
            
            .detail-icon {
                margin-right: 0;
                margin-bottom: 0.5rem;
            }
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 2rem 0 3rem;
            }
            
            .main-content {
                margin-top: -2rem;
            }
            
            .content-card {
                margin-bottom: 1rem;
            }
            
            .hospital-profile-card,
            .details-card,
            .tests-card {
                padding: 1.5rem;
            }
        }

        /* Loading states */
        .loading-shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
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
    <%@ include file="header_patient.jsp" %>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="display-4 fw-bold mb-3">Hospital Profile</h1>
                    <p class="lead opacity-90">
                        Comprehensive information about healthcare facilities and services
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <div class="row g-4">
                <!-- Hospital Profile Card -->
                <div class="col-lg-4">
                    <div class="content-card animate__animated animate__fadeInLeft">
                        <div class="hospital-profile-card">
                            <img src="${pageContext.request.contextPath}/images/hospital_icon.jpg" 
                                 alt="<c:out value='${hospital.hospitalName}'/>" 
                                 class="hospital-avatar">
                            <h2 class="hospital-name"><c:out value="${hospital.hospitalName}"/></h2>
                        </div>
                    </div>
                </div>

                <!-- Details Card -->
                <div class="col-lg-8">
                    <div class="content-card animate__animated animate__fadeInRight">
                        <div class="details-card">
                            <h3 class="section-title">About</h3>
                            <p class="mb-4 text-secondary"><c:out value="${hospital.hospitalBio}"/></p>
                            
                            <h4 class="section-title">Contact Information</h4>
                            
                            <div class="detail-item">
                                <div class="detail-icon location">
                                    <i class="bi bi-geo-alt"></i>
                                </div>
                                <div class="detail-text">
                                    <div class="detail-label">Address</div>
                                    <div class="detail-value"><c:out value="${hospital.address}"/></div>
                                </div>
                            </div>

                            <c:if test="${not empty hospital.website}">
                                <div class="detail-item">
                                    <div class="detail-icon website">
                                        <i class="bi bi-globe"></i>
                                    </div>
                                    <div class="detail-text">
                                        <div class="detail-label">Website</div>
                                        <div class="detail-value">
                                            <a href="<c:out value='${hospital.website}'/>" target="_blank" rel="noopener noreferrer">
                                                <c:out value="${hospital.website}"/>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty hospital.email}">
                                <div class="detail-item">
                                    <div class="detail-icon email">
                                        <i class="bi bi-envelope"></i>
                                    </div>
                                    <div class="detail-text">
                                        <div class="detail-label">Email</div>
                                        <div class="detail-value">
                                            <a href="mailto:<c:out value='${hospital.email}'/>">
                                                <c:out value="${hospital.email}"/>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty hospital.primaryContact}">
                                <div class="detail-item">
                                    <div class="detail-icon phone">
                                        <i class="bi bi-telephone"></i>
                                    </div>
                                    <div class="detail-text">
                                        <div class="detail-label">Primary Contact</div>
                                        <div class="detail-value"><c:out value="${hospital.primaryContact}"/></div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty hospital.emergencyContact}">
                                <div class="detail-item">
                                    <div class="detail-icon phone">
                                        <i class="bi bi-telephone-fill"></i>
                                    </div>
                                    <div class="detail-text">
                                        <div class="detail-label">Emergency Contact</div>
                                        <div class="detail-value"><c:out value="${hospital.emergencyContact}"/></div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Medical Tests Section -->
            <div class="row mt-4">
                <div class="col">
                    <div class="content-card animate__animated animate__fadeInUp">
                        <div class="tests-card">
                            <h3 class="section-title">Medical Tests</h3>
                            
                            <c:if test="${empty medicalTests}">
                                <div class="empty-state">
                                    <i class="bi bi-file-medical empty-icon"></i>
                                    <h4 class="empty-title">No Medical Tests Available</h4>
                                    <p class="empty-subtitle">
                                        This hospital hasn't listed any medical tests yet. 
                                        Please contact them directly for more information.
                                    </p>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty medicalTests}">
                                <div class="table-responsive">
                                    <table class="table custom-table">
                                        <thead>
                                            <tr>
                                                <th scope="col">Test Name</th>
                                                <th scope="col">Description</th>
                                                <th scope="col">Price</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="test" items="${medicalTests}" varStatus="status">
                                                <tr class="animate__animated animate__fadeInUp" data-delay="${status.index}">
                                                    <td class="test-name"><c:out value="${test.testName}"/></td>
                                                    <td><c:out value="${test.description}"/></td>
                                                    <td>
                                                        <span class="price-badge">
                                                            <c:out value="${test.price}"/>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scroll to Top Button -->
    <button class="scroll-top" id="scrollTop">
        <i class="bi bi-arrow-up"></i>
    </button>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
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

    // Add loading animation to images
    document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('img');
        images.forEach(img => {
            if (!img.complete) {
                img.classList.add('loading-shimmer');
                img.addEventListener('load', function() {
                    img.classList.remove('loading-shimmer');
                });
            }
        });
        
        // Add staggered animation delays
        const animatedRows = document.querySelectorAll('[data-delay]');
        animatedRows.forEach(row => {
            const delay = row.getAttribute('data-delay') * 0.1;
            row.style.animationDelay = delay + 's';
        });
    });

    // Enhanced hover effects for table rows
    const tableRows = document.querySelectorAll('.custom-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.01)';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
</script>

</body>
</html>
