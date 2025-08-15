<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DocAid – My Reviews</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root{--sidebar-bg:#334155; --sidebar-hover:#475569; --sidebar-text:#f1f5f9; --accent-cyan:#0891b2; --body-bg:#f8fafc; --star-gold:#fbbf24;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:var(--body-bg);}
        .sidebar{width:240px;min-height:100vh;background:var(--sidebar-bg);position:fixed;left:0;top:0;}
        .sidebar .brand{color:var(--sidebar-text);font-size:1.5rem;font-weight:700;display:flex;align-items:center;padding:1rem 1.5rem;border-bottom:1px solid rgba(255,255,255,.1);}
        .sidebar .brand::before{content:"DA";background:var(--accent-cyan);color:#fff;width:32px;height:32px;border-radius:6px;display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:600;margin-right:.75rem;}
        .sidebar .nav{padding:1rem 0;}
        .sidebar .nav-link{color:var(--sidebar-text);padding:.75rem 1.5rem;display:flex;align-items:center;border-left:3px solid transparent;transition:.2s;}
        .sidebar .nav-link:hover,.sidebar .nav-link.active{background:var(--sidebar-hover);color:#fff;border-left-color:var(--accent-cyan);}
        .sidebar .nav-link i{width:20px;margin-right:.75rem;font-size:16px;}
        .content{margin-left:240px;min-height:100vh;padding:32px;}
        .review-card{background:#fff;border:1px solid #e2e8f0;border-radius:12px;box-shadow:0 1px 3px rgba(0,0,0,.1);}
        .rating-stars i{color:var(--star-gold);}
        .rating-stars .fa-regular{color:#d1d5db;}
    </style>
</head>
<body>
<% request.setAttribute("activePage", "review"); %>
<jsp:include page="sidebar_doctor.jsp" />

<!-- ===== MAIN CONTENT ===== -->
<div class="content">
    <h2 class="fw-bold mb-4">My Patient Reviews</h2>

    <c:choose>
        <c:when test="${not empty reviewList}">
            <c:forEach var="review" items="${reviewList}">
                <div class="card review-card mb-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <h5 class="card-title mb-0">${review.patientName}</h5>
                            <div class="rating-stars">
                                <c:forEach begin="1" end="${review.rating}"><i class="fas fa-star"></i></c:forEach>
                                <c:forEach begin="${review.rating + 1}" end="5"><i class="far fa-star"></i></c:forEach>
                            </div>
                        </div>
                        <p class="card-text">${review.comment}</p>
                        <p class="card-text"><small class="text-muted">Reviewed on: ${review.reviewDate}</small></p>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info" role="alert">
                You do not have any patient reviews yet.
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
