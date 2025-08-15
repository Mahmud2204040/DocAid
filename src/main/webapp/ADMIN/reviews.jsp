<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="partials/header.jsp" />

<h1 class="mt-4 mb-4">Review Moderation</h1>
<p>Approve or delete reviews submitted by patients. Approved reviews will be visible on doctor profiles.</p>

<!-- Display session messages -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="message" scope="session" />
    <c:remove var="messageClass" scope="session" />
</c:if>

<c:choose>
    <c:when test="${not empty reviewList}">
        <c:forEach var="review" items="${reviewList}">
            <div class="card shadow-sm mb-3">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <strong>Patient:</strong> ${review.patientName} | 
                        <strong>Doctor:</strong> ${review.doctorName}
                    </div>
                    <span class="badge bg-warning text-dark">Pending Approval</span>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Rating: 
                        <c:forEach begin="1" end="${review.rating}">
                            <i class="fas fa-star text-warning"></i>
                        </c:forEach>
                        <c:forEach begin="${review.rating + 1}" end="5">
                            <i class="far fa-star text-warning"></i>
                        </c:forEach>
                    </h5>
                    <p class="card-text">"${review.comment}"</p>
                    <small class="text-muted">Reviewed on: ${review.reviewDate}</small>
                </div>
                <div class="card-footer text-end">
                    <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" class="d-inline-block me-2">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="reviewId" value="${review.reviewId}">
                        <button type="submit" class="btn btn-success"><i class="fas fa-check"></i> Approve</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" class="d-inline-block">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="reviewId" value="${review.reviewId}">
                        <button type="submit" class="btn btn-danger"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info" role="alert">
            <h4 class="alert-heading">All Clear!</h4>
            <p>There are no pending reviews that require moderation.</p>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="partials/footer.jsp" />
