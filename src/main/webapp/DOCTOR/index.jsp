<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile – DocAid</title>

    <!-- Bootstrap 5 & Font Awesome 6 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root{
            --sidebar-bg:#334155;
            --sidebar-hover:#475569;
            --sidebar-text:#f1f5f9;
            --accent-cyan:#0891b2;
            --star-gold:#fbbf24;
            --body-bg:#f8fafc;
        }
        body{
            background:var(--body-bg);
            overflow-x:hidden;
            font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        .sidebar{width:240px;min-height:100vh;background:var(--sidebar-bg);position:fixed;left:0;top:0;}
        .sidebar .brand{color:var(--sidebar-text);font-size:1.5rem;font-weight:700;display:flex;align-items:center;padding:1rem 1.5rem;border-bottom:1px solid rgba(255,255,255,.1);}
        .sidebar .nav{padding:1rem 0;}
        .sidebar .nav-link{color:var(--sidebar-text);padding:.75rem 1.5rem;display:flex;align-items:center;border-left:3px solid transparent;transition:.2s;}
        .sidebar .nav-link:hover, .sidebar .nav-link.active{background:var(--sidebar-hover);color:#fff;border-left-color:var(--accent-cyan);}
        .sidebar .nav-link i{width:20px;margin-right:.75rem;font-size:16px;}
        .content{margin-left:240px;min-height:100vh;}
        .profile-header{background:#fff;padding:2rem;margin:2rem;border-radius:12px;box-shadow:0 1px 3px rgba(0,0,0,.1);}
        .profile-title{font-size:2rem;font-weight:700;color:#1e293b;margin-bottom:2rem;border-bottom:2px solid #e2e8f0;padding-bottom:1rem;}
        .profile-card{display:flex;align-items:center;margin-bottom:2rem;}
        .profile-avatar{width:80px;height:80px;border-radius:50%;background:var(--accent-cyan);color:#fff;display:flex;align-items:center;justify-content:center;font-size:24px;font-weight:600;margin-right:1.5rem;border:3px solid #e2e8f0;}
        .profile-name{font-size:1.5rem;font-weight:600;color:#1e293b;margin-bottom:.25rem;}
        .profile-specialty{color:#64748b;font-size:1rem;margin-bottom:.75rem;}
        .rating-stars{display:flex;gap:.25rem;}
        .rating-stars i{color:var(--star-gold);font-size:16px;}
        .rating-stars .fa-regular{color:#d1d5db;}
        .profile-details-header{font-size:1.25rem;font-weight:600;color:#1e293b;margin:2rem 0 1.5rem;border-bottom:1px solid #e2e8f0;padding-bottom:.5rem;}
        .profile-details{display:grid;grid-template-columns:1fr 1fr;gap:1.5rem 3rem;}
        .detail-label{font-weight:600;color:#374151;margin-bottom:.25rem;}
        .detail-value{color:#6b7280;}
    </style>
</head>
<body>

<% request.setAttribute("activePage", "profile"); %>
<jsp:include page="sidebar_doctor.jsp" />

<!-- ===== MAIN CONTENT ===== -->
<div class="content">
    <c:choose>
        <c:when test="${not empty doctorProfile and not empty doctorProfile.firstName}">
            <div class="profile-header">
                <h1 class="profile-title">My Profile</h1>

                <!-- Profile Card -->
                <div class="profile-card">
                    <div class="profile-avatar">
                        ${doctorProfile.firstName.substring(0,1)}${doctorProfile.lastName.substring(0,1)}
                    </div>
                    <div>
                        <h2 class="profile-name">Dr. ${doctorProfile.firstName} ${doctorProfile.lastName}</h2>
                        <p class="profile-specialty">${not empty doctorProfile.specialty ? doctorProfile.specialty : 'N/A'}</p>
                        <div class="rating-stars">
                            <c:set var="rating" value="${doctorProfile.rating}" />
                            <c:set var="fullStars" value="${Math.round(rating)}" />
                            <c:forEach begin="1" end="${fullStars}">
                                <i class="fas fa-star"></i>
                            </c:forEach>
                            <c:forEach begin="1" end="${5 - fullStars}">
                                <i class="far fa-star"></i>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Details -->
                <h3 class="profile-details-header">Profile Details</h3>
                <div class="profile-details">
                    <div>
                        <span class="detail-label">Full Name:</span>
                        <span class="detail-value">${doctorProfile.firstName} ${doctorProfile.lastName}</span>
                    </div>
                    <div>
                        <span class="detail-label">Gender:</span>
                        <span class="detail-value">${not empty doctorProfile.gender ? doctorProfile.gender : 'N/A'}</span>
                    </div>
                    <div>
                        <span class="detail-label">Specialty:</span>
                        <span class="detail-value">${not empty doctorProfile.specialty ? doctorProfile.specialty : 'N/A'}</span>
                    </div>
                    <div>
                        <span class="detail-label">Primary Contact:</span>
                        <span class="detail-value">${not empty primaryContact ? primaryContact : 'N/A'}</span>
                    </div>
                    <div>
                        <span class="detail-label">Appointment Contact:</span>
                        <span class="detail-value">${not empty appointmentContact ? appointmentContact : 'N/A'}</span>
                    </div>
                    <div>
                        <span class="detail-label">Address:</span>
                        <span class="detail-value">${not empty doctorProfile.address ? doctorProfile.address : 'N/A'}</span>
                    </div>
                    <div>
                        <span class="detail-label">Years of Experience:</span>
                        <span class="detail-value">${doctorProfile.expYears} years</span>
                    </div>
                    <div>
                        <span class="detail-label">Consultation Fee:</span>
                        <span class="detail-value">$${doctorProfile.fee}</span>
                    </div>
                    <div>
                        <span class="detail-label">License Number:</span>
                        <span class="detail-value">${doctorProfile.licenseNumber}</span>
                    </div>
                    <div>
                        <span class="detail-label">Affiliated Hospital:</span>
                        <span class="detail-value">${not empty doctorProfile.hospitalName ? doctorProfile.hospitalName : 'Unaffiliated'}</span>
                    </div>
                </div>

                <h3 class="profile-details-header">Biography</h3>
                <p class="detail-value">${not empty doctorProfile.bio ? doctorProfile.bio : 'No biography provided.'}</p>

            </div>
        </c:when>
        <c:otherwise>
            <div class="p-5">
                <div class="alert alert-warning" role="alert">
                    <h4 class="alert-heading">Profile Not Found!</h4>
                    <p>We could not find a doctor profile associated with your user account. Please contact an administrator.</p>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>