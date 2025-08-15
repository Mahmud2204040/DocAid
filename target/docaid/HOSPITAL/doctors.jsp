<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="doctors" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<%-- Main Content --%>
<h1 class="mb-4">Doctor Directory</h1>

<%-- Display feedback message if it exists --%>
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        <c:out value="${sessionScope.message}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
    <% session.removeAttribute("messageClass"); %>
</c:if>

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h6 class="m-0 font-weight-bold text-primary">Affiliated Doctors</h6>
        <a href="<%= request.getContextPath() %>/hospital/find-doctor" class="btn btn-primary btn-sm">
            <i class="fas fa-search"></i> Find and Invite Doctor
        </a>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-hover" id="doctorsTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Specialty</th>
                        <th>Rating</th>
                        <th>Reviews</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="doc" items="${doctorList}">
                        <tr>
                            <td><c:out value="${doc.fullName}"/></td>
                            <td><c:out value="${doc.specialty}"/></td>
                            <td>
                                <span class="badge bg-primary"><i class="fas fa-star"></i> <c:out value="${String.format('%.2f', doc.rating)}"/></span>
                            </td>
                            <td><c:out value="${doc.reviewCount}"/></td>
                            <td>
                                <c:if test="${doc.verified}">
                                    <span class="badge bg-success"><i class="fas fa-check-circle"></i> Verified</span>
                                </c:if>
                                <c:if test="${!doc.verified}">
                                    <span class="badge bg-warning text-dark"><i class="fas fa-exclamation-triangle"></i> Unverified</span>
                                </c:if>
                            </td>
                            <td>
                                <a href="#" class="btn btn-sm btn-info">View Profile</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctorList}">
                        <tr>
                            <td colspan="6" class="text-center">No doctors found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
