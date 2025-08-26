<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="doctor-card">
    <div class="d-flex gap-3">
        <div class="flex-shrink-0">
            <c:set var="imagePath" value="images/default-doctor.jpg" />
            <c:if test="${doctor.gender == 'Male'}">
                <c:set var="imagePath" value="images/male_doctor.png" />
            </c:if>
            <c:if test="${doctor.gender == 'Female'}">
                <c:set var="imagePath" value="images/female_doctor.png" />
            </c:if>

            <img src="<c:url value='${imagePath}'/>" 
                 alt="Dr. <c:out value='${doctor.displayName}'/>" 
                 class="doctor-avatar">
        </div>
        
        <div class="doctor-info">
            <h3 class="doctor-name">Dr. <c:out value="${doctor.displayName}"/></h3>
            <p class="doctor-specialty"><c:out value="${doctor.specialty}"/></p>

            <div class="doctor-details mt-3">
                <div class="row">
                    <div class="col-md-6">
                        <p class="mb-1"><strong>Experience:</strong> <c:out value="${doctor.expYears}"/> years</p>
                        <c:if test="${not empty doctor.hospitalName}">
                            <p class="mb-1"><strong>Hospital:</strong> <c:out value="${doctor.hospitalName}"/></p>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1"><strong>Fee:</strong> $<fmt:formatNumber value="${doctor.fee}" maxFractionDigits="0" /></p>
                    </div>
                </div>
                <c:if test="${not empty doctor.bio}">
                    <p class="doctor-bio mt-2">
                        <c:choose>
                            <c:when test="${fn:length(doctor.bio) > 150}">
                                <c:out value="${fn:substring(doctor.bio, 0, 150)}"/>...
                            </c:when>
                            <c:otherwise>
                                <c:out value="${doctor.bio}"/>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:if>
            </div>
            
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
        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/patient/doctor-profile?id=${doctor.doctorId}" class="btn btn-outline-modern">View Profile</a>
            <button type="button" class="btn btn-accent book-appointment-btn"
                    data-bs-toggle="modal" data-bs-target="#bookingModal"
                    data-doctor-id="${doctor.doctorId}" data-doctor-name="Dr. <c:out value='${doctor.displayName}'/>">
                <i class="bi bi-calendar-plus me-2"></i>Book Appointment
            </button>
        </div>
    </div>
</div>