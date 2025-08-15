<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="feedback" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<style>
    .rating-stars .fa-star { color: #ffc107; }
    .review-card {
        margin-bottom: 1.5rem;
        border-left: 4px solid #0d6efd;
    }
</style>

<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="sidebar_hospital.jsp" />

    <%-- Main Content --%>
    <div class="main-content flex-grow-1 p-4">
        <h1 class="mb-4">Patient Feedback Hub</h1>

        <c:if test="${empty feedbackList}">
            <div class="alert alert-info">No patient feedback found for any doctors at this hospital.</div>
        </c:if>

        <c:forEach var="fb" items="${feedbackList}">
            <div class="card shadow-sm review-card">
                <div class="card-header d-flex justify-content-between">
                    <div>
                        <strong>Doctor:</strong> <c:out value="${fb.doctorName}"/> | 
                        <strong>Patient:</strong> <c:out value="${fb.patientName}"/>
                    </div>
                    <span class="text-muted"><c:out value="${fb.reviewDate}"/></span>
                </div>
                <div class="card-body">
                    <div class="mb-2 rating-stars">
                        <c:forEach begin="1" end="${fb.rating}">
                            <i class="fas fa-star"></i>
                        </c:forEach>
                        <c:forEach begin="${fb.rating + 1}" end="5">
                            <i class="far fa-star"></i>
                        </c:forEach>
                    </div>
                    <p class="card-text">"<c:out value="${fb.comment}"/>"</p>
                </div>
            </div>
        </c:forEach>

    </div>
    </div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
