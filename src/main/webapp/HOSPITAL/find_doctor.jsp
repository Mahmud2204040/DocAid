<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="doctors" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<%-- Main Content --%>
<h1 class="mb-4">Find and Invite Doctor</h1>

<%-- Display feedback message if it exists --%>
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        <c:out value="${sessionScope.message}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
    <% session.removeAttribute("messageClass"); %>
</c:if>

<!-- Search Form -->
<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/hospital/find-doctor" method="GET" class="row g-3 align-items-center">
            <div class="col-auto flex-grow-1">
                <label for="search_term" class="visually-hidden">Doctor Name</label>
                <input type="text" class="form-control" id="search_term" name="search_term" placeholder="Enter doctor's name..." value="<c:out value='${searchTerm}'/>">
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
        </form>
    </div>
</div>

<!-- Search Results -->
<div class="card shadow-sm">
    <div class="card-header">
        <h6 class="m-0 font-weight-bold text-primary">Search Results</h6>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered table-hover" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Doctor Name</th>
                        <th>Specialty</th>
                        <th>Current Hospital</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="doc" items="${searchResults}">
                        <tr>
                            <td><c:out value="${doc.fullName}"/></td>
                            <td><c:out value="${doc.specialty}"/></td>
                            <td><c:out value="${not empty doc.currentHospitalName ? doc.currentHospitalName : 'Unaffiliated'}"/></td>
                            <td>
                                <form action="<%= request.getContextPath() %>/hospital/send-request" method="POST" class="d-inline">
                                    <input type="hidden" name="doctor_id" value="${doc.doctorId}">
                                    <input type="hidden" name="search_term" value="<c:out value='${searchTerm}'/>">
                                    <button type="submit" class="btn btn-sm btn-success">Send Request</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty searchResults and not empty searchTerm}">
                        <tr>
                            <td colspan="4" class="text-center">No doctors found matching your search.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
