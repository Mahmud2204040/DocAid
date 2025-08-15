<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="dashboard" scope="request"/>

<%-- Header --%>
<jsp:include page="/HOSPITAL/partials/header.jsp" />

<style>
    .stat-card { border-left: 5px solid; transition: all 0.3s ease-in-out; }
    .stat-card:hover { transform: translateY(-5px); box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .stat-card.border-primary { border-color: #0d6efd !important; }
    .stat-card.border-success { border-color: #198754 !important; }
    .stat-card.border-info { border-color: #0dcaf0 !important; }
    .stat-card.border-warning { border-color: #ffc107 !important; }
    .stat-card .card-body i { font-size: 3rem; opacity: 0.3; }
    .card-header-custom { background-color: #f8f9fa; font-weight: 600; }
</style>

<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="sidebar_hospital.jsp" />

    <%-- Main Content --%>
    <div class="main-content flex-grow-1 p-4">
        <h1 class="mb-4">Hospital Dashboard</h1>

        <!-- STATISTIC CARDS ROW -->
        <div class="row">
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-primary shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Affiliated Doctors</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.affiliatedDoctorsCount}</div>
                            </div>
                            <div class="col-auto"><i class="fas fa-user-md text-gray-300"></i></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-success shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Upcoming Appointments</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.upcomingAppointmentsCount}</div>
                            </div>
                            <div class="col-auto"><i class="fas fa-calendar-check text-gray-300"></i></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-info shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Medical Tests</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.testsAvailableCount}</div>
                            </div>
                            <div class="col-auto"><i class="fas fa-vial text-gray-300"></i></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-4">
                <div class="card stat-card border-warning shadow h-100 py-2">
                    <div class="card-body">
                        <div class="row no-gutters align-items-center">
                            <div class="col mr-2">
                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Average Rating</div>
                                <div class="h5 mb-0 font-weight-bold text-gray-800"><c:out value="${String.format('%.2f', analytics.averageRating)}"/></div>
                            </div>
                            <div class="col-auto"><i class="fas fa-star text-gray-300"></i></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- CHARTS AND REVIEWS ROW -->
        <div class="row">
            <div class="col-xl-8 col-lg-7">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 card-header-custom">
                        <h6 class="m-0 font-weight-bold text-primary">Appointment Status Breakdown</h6>
                    </div>
                    <div class="card-body">
                        <div class="chart-area" style="height: 320px;">
                            <canvas id="appointmentStatusChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-4 col-lg-5">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 card-header-custom">
                        <h6 class="m-0 font-weight-bold text-primary">Recent Patient Reviews</h6>
                    </div>
                    <div class="card-body" style="height: 360px; overflow-y: auto;">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="review" items="${analytics.recentReviews}">
                                <li class="list-group-item">
                                    <strong><c:out value="${review.doctorName}"/></strong> received a <c:out value="${review.rating}"/> star review.
                                    <p class="small text-muted mb-0">"<c:out value="${review.comment}"/>"</p>
                                </li>
                            </c:forEach>
                            <c:if test="${empty analytics.recentReviews}">
                                <li class="list-group-item">No recent reviews.</li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</div>

<!-- CHART.JS SCRIPT BLOCK -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const appointmentStatusLabels = [];
    const appointmentStatusData = [];
    <c:forEach var="entry" items="${analytics.appointmentsByStatus}">
        appointmentStatusLabels.push('${fn:escapeXml(entry.key)}');
        appointmentStatusData.push(${entry.value});
    </c:forEach>

    const appointmentStatusCtx = document.getElementById('appointmentStatusChart').getContext('2d');
    if (appointmentStatusCtx) {
        new Chart(appointmentStatusCtx, {
            type: 'bar',
            data: {
                labels: appointmentStatusLabels,
                datasets: [{
                    label: 'Count',
                    data: appointmentStatusData,
                    backgroundColor: [
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(75, 192, 192, 0.6)',
                        'rgba(255, 206, 86, 0.6)',
                        'rgba(255, 99, 132, 0.6)',
                        'rgba(153, 102, 255, 0.6)'
                    ],
                    borderColor: [
                        'rgba(54, 162, 235, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(255, 99, 132, 1)',
                        'rgba(153, 102, 255, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                },
                plugins: { 
                    legend: { 
                        display: false 
                    }
                }
            }
        });
    }
});
</script>

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />

<%-- Footer --%>
<jsp:include page="/HOSPITAL/partials/footer.jsp" />