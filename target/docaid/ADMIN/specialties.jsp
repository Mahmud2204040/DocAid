<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="partials/header.jsp" />

<h1 class="mt-4 mb-4">System Settings: Specialties</h1>

<!-- Session Message Feedback -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="message" scope="session" />
    <c:remove var="messageClass" scope="session" />
</c:if>

<div class="row">
    <!-- Add Specialty Form -->
    <div class="col-md-4">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fas fa-plus-circle me-1"></i>
                Add New Specialty
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/specialties" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label for="specialtyName" class="form-label">Specialty Name</label>
                        <input type="text" class="form-control" id="specialtyName" name="specialtyName" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Specialty</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Existing Specialties Table -->
    <div class="col-md-8">
        <div class="card shadow-sm">
            <div class="card-header">
                <i class="fas fa-list-ul me-1"></i>
                Existing Specialties
            </div>
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="specialty" items="${specialtyList}">
                            <tr>
                                <td>${specialty.specialtyId}</td>
                                <td>${specialty.specialtyName}</td>
                                <td class="text-end">
                                    <button class="btn btn-sm btn-outline-secondary edit-specialty-btn"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editSpecialtyModal"
                                            data-specialtyid="${specialty.specialtyId}"
                                            data-specialtyname="${specialty.specialtyName}">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger delete-specialty-btn"
                                            data-bs-toggle="modal"
                                            data-bs-target="#deleteSpecialtyModal"
                                            data-specialtyid="${specialty.specialtyId}"
                                            data-specialtyname="${specialty.specialtyName}">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="partials/modals.jsp" />
<jsp:include page="partials/footer.jsp" />
