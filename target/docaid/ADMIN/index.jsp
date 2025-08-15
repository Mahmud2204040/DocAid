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
                <div class="chart-area">
                    <canvas id="userTypeChart"></canvas>
                </div>
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
                <div class="chart-pie pt-4 pb-2">
                    <canvas id="appointmentStatusChart"></canvas>
                </div>
                <div class="mt-4 text-center small" id="appointment-legend">
                    <!-- Legend will be dynamically generated by Chart.js -->
                </div>
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
                <ul class="list-group list-group-flush">
                    <li class="list-group-item"><i class="fas fa-user-plus me-2 text-success"></i> New patient registered: John Doe</li>
                    <li class="list-group-item"><i class="fas fa-user-plus me-2 text-success"></i> New doctor added: Dr. Smith</li>
                    <li class="list-group-item"><i class="fas fa-star me-2 text-warning"></i> New review submitted for Dr. Jones</li>
                    <li class="list-group-item"><i class="fas fa-file-invoice-dollar me-2 text-info"></i> Appointment completed for Jane Roe</li>
                    <li class="list-group-item"><i class="fas fa-user-plus me-2 text-success"></i> New hospital onboarded: City General</li>
                </ul>
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
    const userTypeLabels = [];
    const userTypeData = [];
    <c:forEach var="entry" items="${analytics.userCounts}">
        userTypeLabels.push('${fn:escapeXml(entry.key)}');
        userTypeData.push(${entry.value});
    </c:forEach>

    const appointmentStatusLabels = [];
    const appointmentStatusData = [];
    <c:forEach var="entry" items="${analytics.appointmentStats}">
        appointmentStatusLabels.push('${fn:escapeXml(entry.key)}');
        appointmentStatusData.push(${entry.value});
    </c:forEach>

    // --- User Distribution Bar Chart ---
    const userTypeCtx = document.getElementById('userTypeChart').getContext('2d');
    if (userTypeCtx) {
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
    const appointmentStatusCtx = document.getElementById('appointmentStatusChart').getContext('2d');
    if (appointmentStatusCtx) {
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