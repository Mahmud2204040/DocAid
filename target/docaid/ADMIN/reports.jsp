<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="partials/header.jsp" />

<h1 class="mt-4 mb-4">Appointment Reports</h1>

<!-- Stat Cards -->
<div class="row">
    <div class="col-xl-6 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Appointments (All Time)</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${reportData.totalAppointments}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-calendar-check fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-6 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Appointments (This Month)</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${reportData.appointmentsThisMonth}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-calendar-day fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Appointments Over Time Chart -->
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Appointments per Month</h6>
            </div>
            <div class="card-body">
                <div class="chart-area">
                    <canvas id="appointmentsOverTimeChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const reportLabels = [];
    const reportDataPoints = [];
    <c:forEach var="entry" items="${reportData.appointmentsByMonth}">
        reportLabels.push('${fn:escapeXml(entry.key)}');
        reportDataPoints.push(${entry.value});
    </c:forEach>

    const ctx = document.getElementById('appointmentsOverTimeChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: reportLabels,
            datasets: [{
                label: "Appointments",
                lineTension: 0.3,
                backgroundColor: "rgba(78, 115, 223, 0.05)",
                borderColor: "rgba(78, 115, 223, 1)",
                pointRadius: 3,
                pointBackgroundColor: "rgba(78, 115, 223, 1)",
                pointBorderColor: "rgba(78, 115, 223, 1)",
                pointHoverRadius: 3,
                pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
                pointHoverBorderColor: "rgba(78, 115, 223, 1)",
                pointHitRadius: 10,
                pointBorderWidth: 2,
                data: reportDataPoints,
            }],
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            scales: {
                x: {
                    time: {
                        unit: 'date'
                    },
                    grid: {
                        display: false
                    }
                },
                y: {
                    ticks: {
                        beginAtZero: true,
                        stepSize: 10 // Adjust step size as needed
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
});
</script>

<jsp:include page="partials/footer.jsp" />
