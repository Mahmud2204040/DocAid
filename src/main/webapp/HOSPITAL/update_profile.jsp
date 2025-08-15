<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="profile" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="sidebar_hospital.jsp" />

    <%-- Main Content --%>
    <div class="main-content flex-grow-1 p-4">
        <h1 class="mb-4">Manage Profile</h1>

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
            <div class="card-header">
                <h6 class="m-0 font-weight-bold text-primary">Update Your Hospital's Information</h6>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/hospital/profile" method="POST">
                    <div class="mb-3">
                        <label for="hospital_name" class="form-label">Hospital Name</label>
                        <input type="text" class="form-control" id="hospital_name" name="hospital_name" value="<c:out value='${hospital.hospitalName}'/>" required>
                    </div>
                    <div class="mb-3">
                        <label for="website" class="form-label">Website</label>
                        <input type="url" class="form-control" id="website" name="website" value="<c:out value='${hospital.website}'/>">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control" id="address" name="address" rows="3" required><c:out value='${hospital.address}'/></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="hospital_bio" class="form-label">Hospital Bio</label>
                        <textarea class="form-control" id="hospital_bio" name="hospital_bio" rows="5"><c:out value='${hospital.hospitalBio}'/></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
    </div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
