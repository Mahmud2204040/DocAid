<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="partials/header.jsp" />

<h1 class="mt-4 mb-4">User Management</h1>

<!-- Display session messages (e.g., for success/error after deletion) -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <%-- Remove the message from the session to prevent it from showing again --%>
    <c:remove var="message" scope="session" />
    <c:remove var="messageClass" scope="session" />
</c:if>

<!-- User Filter Form -->
<div class="card shadow-sm mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="row g-3 align-items-center">
            <div class="col-auto">
                <label for="userType" class="col-form-label">Filter by Role:</label>
            </div>
            <div class="col-auto">
                <select name="userType" id="userType" class="form-select">
                    <option value="" ${empty currentUserType ? 'selected' : ''}>All Users</option>
                    <option value="Admin" ${currentUserType == 'Admin' ? 'selected' : ''}>Admin</option>
                    <option value="Doctor" ${currentUserType == 'Doctor' ? 'selected' : ''}>Doctor</option>
                    <option value="Hospital" ${currentUserType == 'Hospital' ? 'selected' : ''}>Hospital</option>
                    <option value="Patient" ${currentUserType == 'Patient' ? 'selected' : ''}>Patient</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="submit" class="btn btn-primary">Filter</button>
            </div>
        </form>
    </div>
</div>

<!-- Users Table -->
<div class="card shadow-sm">
    <div class="card-header">
        <i class="fas fa-users me-1"></i>
        User List
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>User ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Date Joined</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td><span class="badge bg-secondary">${user.userType}</span></td>
                            <td>${user.createdAt}</td>
                            <td>
                                <button class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i> Edit</button>
                                <button class="btn btn-sm btn-outline-danger delete-user-btn"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteUserModal"
                                        data-userid="${user.userId}"
                                        data-username="${user.fullName}">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty userList}">
                        <tr>
                            <td colspan="6" class="text-center">No users found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="partials/modals.jsp" />
<jsp:include page="partials/footer.jsp" />
