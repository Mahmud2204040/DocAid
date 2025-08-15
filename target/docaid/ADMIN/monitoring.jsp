<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="partials/header.jsp" />

<!-- Page Title -->
<h1 class="mt-4 mb-4">Activity Monitoring</h1>

<!-- Session Message Feedback -->
<c:if test="${not empty sessionScope.message}">
    <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
        ${sessionScope.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="message" scope="session" />
    <c:remove var="messageClass" scope="session" />
</c:if>

<!-- Layout Row -->
<div class="row">

    <!-- Column 1: Start Monitoring Form -->
    <div class="col-lg-5">
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h6 class="m-0 font-weight-bold"><i class="fas fa-plus-circle me-2"></i>Start New Monitoring Session</h6>
            </div>
            <div class="card-body">
                <p class="card-text">Enter the User ID and a reason to begin monitoring a user's activity.</p>
                
                <!-- Start Monitoring Form -->
                <form action="${pageContext.request.contextPath}/admin/monitoring" method="POST">
                    <!-- Hidden action input -->
                    <input type="hidden" name="action" value="start">
                    
                    <!-- User ID Input -->
                    <div class="mb-3">
                        <label for="userId" class="form-label">User ID to Monitor</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <input type="number" class="form-control" id="userId" name="userId" placeholder="e.g., 123" required>
                        </div>
                        <div class="form-text">The numeric ID of the user (Patient, Doctor, etc.) to monitor.</div>
                    </div>
                    
                    <!-- Reason Input -->
                    <div class="mb-3">
                        <label for="reason" class="form-label">Reason for Monitoring</label>
                        <div class="input-group">
                             <span class="input-group-text"><i class="fas fa-clipboard-list"></i></span>
                            <textarea class="form-control" id="reason" name="reason" rows="4" placeholder="e.g., Routine performance review, Investigating user report..." required></textarea>
                        </div>
                    </div>
                    
                    <!-- Submit Button -->
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Start Monitoring</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Column 2: Active Monitors List -->
    <div class="col-lg-7">
        <div class="card shadow mb-4">
            <div class="card-header bg-success text-white">
                <h6 class="m-0 font-weight-bold"><i class="fas fa-binoculars me-2"></i>Currently Active Monitors</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Monitor ID</th>
                                <th>Monitored User</th>
                                <th>Reason</th>
                                <th>Start Date</th>
                                <th>Admin</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty monitorList}">
                                    <c:forEach var="monitor" items="${monitorList}">
                                        <tr>
                                            <td>${monitor.monitorId}</td>
                                            <td><a href="#">${monitor.monitoredUserEmail}</a></td>
                                            <td>${monitor.monitoringReason}</td>
                                            <td>${monitor.startDate}</td>
                                            <td>${monitor.adminName}</td>
                                            <td>
                                                <button class="btn btn-sm btn-danger stop-monitor-btn"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#stopMonitorModal"
                                                        data-monitorid="${monitor.monitorId}"
                                                        data-useremail="${monitor.monitoredUserEmail}">
                                                    <i class="fas fa-stop-circle me-1"></i> Stop
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" class="text-center">No active monitoring sessions.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Include Modals -->
<jsp:include page="partials/modals.jsp" />

<!-- Include Footer -->
<jsp:include page="partials/footer.jsp" />
