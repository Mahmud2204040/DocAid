<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="appointments" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="sidebar_hospital.jsp" />

    <%-- Main Content --%>
    <div class="main-content flex-grow-1 p-4">
        <h1 class="mb-4">Appointment Management</h1>

        <div class="card shadow-sm">
            <div class="card-header">
                <h6 class="m-0 font-weight-bold text-primary">All Appointments</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="appointmentsTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Doctor Name</th>
                                <th>Specialty</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appt" items="${appointmentList}">
                                <tr>
                                    <td><c:out value="${appt.patientName}"/></td>
                                    <td><c:out value="${appt.doctorName}"/></td>
                                    <td><c:out value="${appt.specialty}"/></td>
                                    <td><fmt:formatDate value="${appt.appointmentTimestamp}" pattern="dd MMMM yyyy hh:mm a"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${appt.status == 'Completed'}">
                                                <span class="badge bg-success"><c:out value="${appt.status}"/></span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Scheduled'}">
                                                <span class="badge bg-info"><c:out value="${appt.status}"/></span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Confirmed'}">
                                                <span class="badge bg-primary"><c:out value="${appt.status}"/></span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Cancelled'}">
                                                <span class="badge bg-danger"><c:out value="${appt.status}"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><c:out value="${appt.status}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointmentList}">
                                <tr>
                                    <td colspan="6" class="text-center">No appointments found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />
