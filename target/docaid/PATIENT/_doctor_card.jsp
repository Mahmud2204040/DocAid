<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-12">
    <div class="doctor-card">
        <div class="d-flex gap-3">
            <div class="flex-shrink-0">
                <img src="<c:url value='${not empty doctor.profileImage ? doctor.profileImage : "images/default-doctor.jpg"}'/>" 
                     alt="Dr. <c:out value='${doctor.displayName}'/>" 
                     class="doctor-avatar">
            </div>
            
            <div class="doctor-info">
                <h3 class="doctor-name">Dr. <c:out value="${doctor.displayName}"/></h3>
                <p class="doctor-specialty"><c:out value="${doctor.specialty}"/></p>
                
                <div class="doctor-location">
                    <i class="bi bi-geo-alt"></i>
                    <span><c:out value="${doctor.address}"/></span>
                </div>
                
                <div class="doctor-rating">
                    <div class="rating-stars">
                        <c:forEach begin="1" end="5" var="star">
                            <i class="bi ${star <= doctor.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                        </c:forEach>
                    </div>
                    <span class="rating-text">
                        <fmt:formatNumber value="${doctor.rating}" maxFractionDigits="1"/>
                    </span>
                    <span class="rating-count">(${doctor.reviewCount} reviews)</span>
                </div>
                
                <div class="doctor-badges">
                    <c:if test="${doctor.availableForPatients}">
                        <span class="badge-modern badge-success">
                            <i class="bi bi-check-circle me-1"></i>Accepting Patients
                        </span>
                    </c:if>
                    <c:if test="${doctor.verified}">
                        <span class="badge-modern badge-info">
                            <i class="bi bi-patch-check me-1"></i>Verified
                        </span>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="doctor-actions">
            <div class="distance-info">
                <c:if test="${doctor.distance > 0}">
                    <i class="bi bi-geo me-1"></i>
                    <span class="distance-value">
                        <fmt:formatNumber value="${doctor.distance}" maxFractionDigits="1"/> km
                    </span> away
                </c:if>
            </div>
            
            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/patient/doctor-profile?id=${doctor.doctorId}" class="btn btn-outline-modern">
                <button type="button" class="btn btn-accent book-appointment-btn"
                        data-bs-toggle="modal" data-bs-target="#bookingModal"
                        data-doctor-id="${doctor.doctorId}" data-doctor-name="Dr. <c:out value='${doctor.displayName}'/>">
                    <i class="bi bi-calendar-plus me-2"></i>Book Appointment
                </button>
            </div>
        </div>
    </div>
</div>
