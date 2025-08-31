<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dr. <c:out value="${doctor.displayName}"/>'s Profile - DocAid</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .rating-stars .fa-star {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <%@ include file="header_patient.jsp" %>

    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <c:set var="imagePath" value="${pageContext.request.contextPath}/images/default-doctor.jpg" />
                    <c:if test="${doctor.gender == 'Male'}">
                        <c:set var="imagePath" value="${pageContext.request.contextPath}/images/male_doctor.png" />
                    </c:if>
                    <c:if test="${doctor.gender == 'Female'}">
                        <c:set var="imagePath" value="${pageContext.request.contextPath}/images/female_doctor.png" />
                    </c:if>
                    <img src="${imagePath}"
                         alt="Dr. <c:out value='${doctor.displayName}'/>"
                         class="profile-avatar">
                </div>
                <div class="col-md-9">
                    <h1>Dr. <c:out value="${doctor.displayName}"/></h1>
                    <h5 class="text-light"><c:out value="${doctor.specialtyName}"/></h5>
                    <div class="d-flex align-items-center">
                        <div class="rating-stars me-2">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="${i <= doctor.rating ? 'fas' : 'far'} fa-star"></i>
                            </c:forEach>
                        </div>
                        <span><fmt:formatNumber value="${doctor.rating}" maxFractionDigits="1"/> (${doctor.reviewCount} reviews)</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <c:if test="${not empty sessionScope.bookingError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <c:out value="${sessionScope.bookingError}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="bookingError" scope="session" />
        </c:if>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <ul class="nav nav-tabs card-header-tabs" id="profileTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="about-tab" data-bs-toggle="tab" data-bs-target="#about" type="button" role="tab" aria-controls="about" aria-selected="true">About</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="schedule-tab" data-bs-toggle="tab" data-bs-target="#schedule" type="button" role="tab" aria-controls="schedule" aria-selected="false">Schedule & Booking</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">Reviews</button>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body">
                        <div class="tab-content" id="profileTabContent">
                            <!-- About Tab -->
                            <div class="tab-pane fade show active" id="about" role="tabpanel" aria-labelledby="about-tab">
                                <h5 class="card-title">Biography</h5>
                                <p class="card-text"><c:out value="${doctor.bio}"/></p>
                                <hr>
                                <h5 class="card-title">Details</h5>
                                <ul class="list-unstyled">
                                    <li><strong>License Number:</strong> <c:out value="${doctor.licenseNumber}"/></li>
                                    <li><strong>Years of Experience:</strong> <c:out value="${doctor.expYears}"/> years</li>
                                    <li><strong>Affiliated Hospital:</strong> <c:out value="${doctor.hospitalName}"/></li>
                                </ul>
                            </div>

                            <!-- Schedule & Booking Tab -->
                            <div class="tab-pane fade" id="schedule" role="tabpanel" aria-labelledby="schedule-tab">
                                <h5 class="card-title">Weekly Schedule</h5>
                                <c:if test="${not empty schedule}">
                                    <table class="table table-striped">
                                        <thead><tr><th>Day</th><th>From</th><th>To</th></tr></thead>
                                        <tbody>
                                            <c:forEach var="slot" items="${schedule}">
                                                <tr>
                                                    <td><c:out value="${slot.day}"/></td>
                                                    <td>
                                                        <c:set var="startTime" value="${slot.startTime}" />
                                                        <c:if test="${not empty startTime}">
                                                            <%
                                                                Object startTimeObj = pageContext.getAttribute("startTime");
                                                                String formattedStartTime = "";
                                                                if (startTimeObj != null) {
                                                                    try {
                                                                        java.sql.Time sqlTime = (java.sql.Time) startTimeObj;
                                                                        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("hh:mm a");
                                                                        formattedStartTime = formatter.format(sqlTime);
                                                                    } catch (Exception e) {
                                                                        // If it's a string, try to parse it
                                                                        String timeStr = startTimeObj.toString();
                                                                        try {
                                                                            java.text.SimpleDateFormat parser = new java.text.SimpleDateFormat("HH:mm:ss");
                                                                            java.util.Date parsedTime = parser.parse(timeStr);
                                                                            java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("hh:mm a");
                                                                            formattedStartTime = formatter.format(parsedTime);
                                                                        } catch (java.text.ParseException pe) {
                                                                            formattedStartTime = timeStr; // fallback to original string
                                                                        }
                                                                    }
                                                                }
                                                                pageContext.setAttribute("formattedStartTime", formattedStartTime);
                                                            %>
                                                            <c:out value="${formattedStartTime}"/>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:set var="endTime" value="${slot.endTime}" />
                                                        <c:if test="${not empty endTime}">
                                                            <%
                                                                Object endTimeObj = pageContext.getAttribute("endTime");
                                                                String formattedEndTime = "";
                                                                if (endTimeObj != null) {
                                                                    try {
                                                                        java.sql.Time sqlTime = (java.sql.Time) endTimeObj;
                                                                        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("hh:mm a");
                                                                        formattedEndTime = formatter.format(sqlTime);
                                                                    } catch (Exception e) {
                                                                        // If it's a string, try to parse it
                                                                        String timeStr = endTimeObj.toString();
                                                                        try {
                                                                            java.text.SimpleDateFormat parser = new java.text.SimpleDateFormat("HH:mm:ss");
                                                                            java.util.Date parsedTime = parser.parse(timeStr);
                                                                            java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("hh:mm a");
                                                                            formattedEndTime = formatter.format(parsedTime);
                                                                        } catch (java.text.ParseException pe) {
                                                                            formattedEndTime = timeStr; // fallback to original string
                                                                        }
                                                                    }
                                                                }
                                                                pageContext.setAttribute("formattedEndTime", formattedEndTime);
                                                            %>
                                                            <c:out value="${formattedEndTime}"/>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>
                                <c:if test="${empty schedule}">
                                    <div class="alert alert-info">This doctor has not published their schedule yet.</div>
                                </c:if>
                                <hr>
                                <h5 class="card-title">Book an Appointment</h5>
                                <form action="${pageContext.request.contextPath}/patient/book-appointment" method="post">
                                    <input type="hidden" name="doctorId" value="${doctor.doctorId}">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="appointmentDate" class="form-label">Date</label>
                                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="appointmentTime" class="form-label">Time</label>
                                            <input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Request Appointment</button>
                                </form>
                            </div>

                            <!-- Reviews Tab -->
                            <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                                <c:if test="${empty reviews}">
                                    <div class="alert alert-info">No reviews yet for this doctor.</div>
                                </c:if>
                                <c:forEach var="review" items="${reviews}">
                                    <div class="mb-3">
                                        <strong><c:out value="${review.patientName}"/></strong>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="${i <= review.rating ? 'fas' : 'far'} fa-star"></i>
                                            </c:forEach>
                                        </div>
                                        <p><c:out value="${review.comment}"/></p>
                                        <small class="text-muted">Posted on <fmt:formatDate value="${review.reviewDate}" pattern="MMM dd, yyyy"/></small>
                                        <hr>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">Contact & Location</div>
                    <div class="card-body">
                        <p><strong>Phone:</strong> <c:out value="${doctor.phone}"/></p>
                        <p><strong>Email:</strong> <c:out value="${doctor.email}"/></p>
                        <p><strong>Address:</strong> <c:out value="${doctor.address}"/></p>
                        <!-- Add a map here if you have lat/lng -->
                    </div>
                </div>
                <div class="card mt-3">
                    <div class="card-header">Consultation Fee</div>
                    <div class="card-body">
                        <h4>$<fmt:formatNumber value="${doctor.fee}" type="currency" currencySymbol="" maxFractionDigits="2"/></h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>