<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="partials/header.jsp" />

<!-- Custom Styles for this page -->
<style>
    .stat-card {
        border-left: 5px solid;
        transition: all 0.3s ease-in-out;
    }
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .stat-card.border-primary { border-color: #0d6efd !important; }
    .stat-card.border-success { border-color: #198754 !important; }
    .stat-card.border-warning { border-color: #ffc107 !important; }
    .stat-card.border-danger { border-color: #dc3545 !important; }

    .stat-card .card-body .display-4 {
        font-weight: 700;
    }
    .stat-card .card-body i {
        font-size: 3rem;
        opacity: 0.3;
    }
    .card-header-custom {
        background-color: #f8f9fa;
        font-weight: 600;
    }
    
    /* Equal height chart containers */
    .chart-area, .chart-pie {
        height: 350px;
        position: relative;
    }
</style>

<!-- Page Title -->
<h1 class="mt-4 mb-4">Admin Dashboard</h1>

<!-- ======================================================================================= -->
<!-- STATISTIC CARDS ROW                                                                     -->
<!-- ======================================================================================= -->
<div class="row">

    <!-- Total Patients Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card border-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Patients</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.userCounts['Patient'] ne null ? analytics.userCounts['Patient'] : 0}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-hospital-user text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Total Doctors Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card border-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Doctors</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.userCounts['Doctor'] ne null ? analytics.userCounts['Doctor'] : 0}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-user-md text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Pending Reviews Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card border-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Pending Reviews</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.pendingReviewsCount}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-comments text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Active Monitors Card -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card border-danger shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">Active Monitors</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${analytics.activeMonitorsCount}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-binoculars text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ======================================================================================= -->
<!-- CHARTS ROW                                                                              -->
<!-- ======================================================================================= -->
<div class="row">

    <!-- Area Chart -->
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <!-- Card Header -->
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between card-header-custom">
                <h6 class="m-0 font-weight-bold text-primary">User Distribution</h6>
            </div>
            <!-- Card Body -->
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty analytics.userCounts}">
                        <div class="text-center p-5">
                            <p class="text-muted">No user data available to display chart.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="chart-area">
                            <canvas id="userTypeChart"></canvas>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Pie Chart -->
    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <!-- Card Header -->
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between card-header-custom">
                <h6 class="m-0 font-weight-bold text-primary">Appointment Status</h6>
            </div>
            <!-- Card Body -->
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty analytics.appointmentStats}">
                        <div class="text-center p-5">
                            <p class="text-muted">No appointment data available to display chart.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="chart-pie pt-4 pb-2">
                            <canvas id="appointmentStatusChart"></canvas>
                        </div>
                        <div class="mt-4 text-center small" id="appointment-legend">
                            <!-- Legend will be dynamically generated by Chart.js -->
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- ======================================================================================= -->
<!-- CONTENT ROW                                                                             -->
<!-- ======================================================================================= -->
<div class="row">
    <div class="col-lg-6 mb-4">
        <!-- Recent Activity Panel -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 card-header-custom">
                <h6 class="m-0 font-weight-bold text-primary">Recent Activity</h6>
            </div>
            <div class="card-body">
                <div class="list-group list-group-flush">
                    <c:choose>
                        <c:when test="${not empty recentActivityList}">
                            <c:forEach var="user" items="${recentActivityList}">
                                <div class="list-group-item d-flex align-items-center">
                                    <c:choose>
                                        <c:when test="${user.userType == 'Patient'}">
                                            <i class="fas fa-hospital-user me-3 text-primary"></i>
                                            <div>New Patient registered: <strong><c:out value="${user.fullName}"/></strong></div>
                                        </c:when>
                                        <c:when test="${user.userType == 'Doctor'}">
                                            <i class="fas fa-user-md me-3 text-success"></i>
                                            <div>New Doctor registered: <strong><c:out value="${user.fullName}"/></strong></div>
                                        </c:when>
                                        <c:when test="${user.userType == 'Hospital'}">
                                            <i class="fas fa-hospital me-3 text-info"></i>
                                            <div>New Hospital registered: <strong><c:out value="${user.fullName}"/></strong></div>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user me-3 text-secondary"></i>
                                            <div>New <c:out value="${user.userType}"/> registered: <strong><c:out value="${user.fullName}"/></strong></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group-item">No recent user registrations found.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-6 mb-4">
        <!-- Server Status Panel -->
        <div class="card shadow mb-4">
            <div class="card-header py-3 card-header-custom">
                <h6 class="m-0 font-weight-bold text-primary">System Status</h6>
            </div>
            <div class="card-body">
                <h4 class="small font-weight-bold">Database Load <span class="float-end">20%</span></h4>
                <div class="progress mb-4">
                    <div class="progress-bar bg-danger" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <h4 class="small font-weight-bold">API Response Time <span class="float-end">40%</span></h4>
                <div class="progress mb-4">
                    <div class="progress-bar bg-warning" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <h4 class="small font-weight-bold">Active Sessions <span class="float-end">60%</span></h4>
                <div class="progress mb-4">
                    <div class="progress-bar" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <h4 class="small font-weight-bold">Memory Usage <span class="float-end">80%</span></h4>
                <div class="progress mb-4">
                    <div class="progress-bar bg-info" role="progressbar" style="width: 80%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <h4 class="small font-weight-bold">Overall System Health <span class="float-end">Healthy!</span></h4>
                <div class="progress">
                    <div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ======================================================================================= -->
<!-- CHART.JS SCRIPT BLOCK                                                                   -->
<!-- ======================================================================================= -->
<script>
// This script block will execute after the DOM is loaded and all libraries are available.
document.addEventListener("DOMContentLoaded", function() {

    // --- Data Preparation from JSP to JS ---
    const userTypeLabels = [
        <c:forEach var="entry" items="${analytics.userCounts}" varStatus="status">
            '${fn:escapeXml(entry.key)}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    const userTypeData = [
        <c:forEach var="entry" items="${analytics.userCounts}" varStatus="status">
            ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const appointmentStatusLabels = [
        <c:forEach var="entry" items="${analytics.appointmentStats}" varStatus="status">
            '${fn:escapeXml(entry.key)}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    const appointmentStatusData = [
        <c:forEach var="entry" items="${analytics.appointmentStats}" varStatus="status">
            ${entry.value}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // Debug: Check if Chart.js is loaded
    if (typeof Chart === 'undefined') {
        console.error('Chart.js is not loaded! Please add Chart.js to your header.');
        return;
    }

    // --- User Distribution Bar Chart ---
    const userTypeCanvas = document.getElementById('userTypeChart');
    if (userTypeCanvas && userTypeLabels.length > 0) {
        const userTypeCtx = userTypeCanvas.getContext('2d');
        new Chart(userTypeCtx, {
            type: 'bar',
            data: {
                labels: userTypeLabels,
                datasets: [{
                    label: 'Total Users',
                    data: userTypeData,
                    backgroundColor: [
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(75, 192, 192, 0.6)',
                        'rgba(255, 206, 86, 0.6)',
                        'rgba(255, 99, 132, 0.6)'
                    ],
                    borderColor: [
                        'rgba(54, 162, 235, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(255, 99, 132, 1)'
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

    // --- Appointment Status Doughnut Chart ---
    const appointmentStatusCanvas = document.getElementById('appointmentStatusChart');
    if (appointmentStatusCanvas && appointmentStatusLabels.length > 0) {
        const appointmentStatusCtx = appointmentStatusCanvas.getContext('2d');
        new Chart(appointmentStatusCtx, {
            type: 'doughnut',
            data: {
                labels: appointmentStatusLabels,
                datasets: [{
                    data: appointmentStatusData,
                    backgroundColor: [
                        '#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b'
                    ],
                    hoverBackgroundColor: [
                        '#2e59d9', '#17a673', '#2c9faf', '#dda20a', '#be2617'
                    ],
                    hoverBorderColor: "rgba(234, 236, 244, 1)",
                }],
            },
            options: {
                maintainAspectRatio: false,
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                },
                cutout: '80%',
            },
        });
    }
});
</script>

<jsp:include page="partials/footer.jsp" />