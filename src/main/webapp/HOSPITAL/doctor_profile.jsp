<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="doctors" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">Doctor Profile</h1>

    <div class="row">
        <div class="col-lg-4">
            <!-- Doctor's Photo and Basic Info -->
            <div class="card shadow mb-4">
                <div class="card-body text-center">
                    <img src="${pageContext.request.contextPath}/images/doctor.png" alt="Doctor" class="img-fluid rounded-circle mb-3" style="width: 150px; height: 150px; object-fit: cover;">
                    <h4 class="card-title"><c:out value="${doctor.displayName}"/></h4>
                    <p class="card-text text-primary"><c:out value="${doctor.specialtyName}"/></p>
                    <div class="d-flex justify-content-center align-items-center">
                        <div class="text-warning me-1">
                            <i class="fas fa-star"></i>
                        </div>
                        <span><c:out value="${String.format('%.2f', doctor.rating)}"/> (${doctor.reviewCount} reviews)</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <!-- Detailed Information -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Doctor Details</h6>
                </div>
                <div class="card-body">
                    <h5>Bio</h5>
                    <p><c:out value="${doctor.bio}"/></p>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <strong>Full Name</strong>
                            <p><c:out value="${doctor.displayName}"/></p>
                        </div>
                        <div class="col-md-6">
                            <strong>License Number</strong>
                            <p><c:out value="${doctor.licenseNumber}"/></p>
                        </div>
                        <div class="col-md-6">
                            <strong>Years of Experience</strong>
                            <p><c:out value="${doctor.expYears}"/> years</p>
                        </div>
                        <div class="col-md-6">
                            <strong>Consultation Fee</strong>
                            <p>$<c:out value="${String.format('%.2f', doctor.fee)}"/></p>
                        </div>
                        <div class="col-md-6">
                            <strong>Gender</strong>
                            <p><c:out value="${doctor.gender}"/></p>
                        </div>
                    </div>
                    <hr>
                    <h5>Contact Information</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <strong>Email</strong>
                            <p><c:out value="${doctor.email}"/></p>
                        </div>
                        <c:if test="${not empty doctor.phone}">
                            <div class="col-md-6">
                                <strong>Primary Contact</strong>
                                <p><c:out value="${doctor.phone}"/></p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Reviews Section -->
    <div class="row">
        <div class="col-lg-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Patient Reviews</h6>
                </div>
                <div class="card-body">
                    <c:if test="${empty reviews}">
                        <p class="text-center">This doctor has not received any reviews yet.</p>
                    </c:if>
                    <c:forEach var="review" items="${reviews}">
                        <div class="review mb-3">
                            <strong><c:out value="${review.patientName}"/></strong>
                            <div class="text-warning d-inline-block ms-2">
                                <c:forEach begin="1" end="${review.rating}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                                <c:forEach begin="${review.rating + 1}" end="5">
                                    <i class="far fa-star"></i>
                                </c:forEach>
                            </div>
                            <p class="mt-1 mb-0"><c:out value="${review.comment}"/></p>
                            <small class="text-muted">Reviewed on: <c:out value="${review.reviewDate}"/></small>
                        </div>
                        <hr/>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
