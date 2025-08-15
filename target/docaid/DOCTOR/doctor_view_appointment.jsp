<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DocAid – Appointments</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root{--sidebar-bg:#334155; --sidebar-hover:#475569; --sidebar-text:#f1f5f9; --accent-cyan:#0891b2; --body-bg:#f8fafc; --pending:#ffc107; --approved:#22c55e; --cancelled:#ef4444;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:var(--body-bg);}
        .sidebar{width:240px;min-height:100vh;background:var(--sidebar-bg);position:fixed;left:0;top:0;}
        .sidebar .brand{color:var(--sidebar-text);font-size:1.5rem;font-weight:700;display:flex;align-items:center;padding:1rem 1.5rem;border-bottom:1px solid rgba(255,255,255,.1);}
        .sidebar .brand::before{content:"DA";background:var(--accent-cyan);color:#fff;width:32px;height:32px;border-radius:6px;display:flex;align-items-center;justify-content:center;font-size:14px;font-weight:600;margin-right:.75rem;}
        .sidebar .nav{padding:1rem 0;}
        .sidebar .nav-link{color:var(--sidebar-text);padding:.75rem 1.5rem;display:flex;align-items:center;border-left:3px solid transparent;transition:.2s;}
        .sidebar .nav-link:hover,.sidebar .nav-link.active{background:var(--sidebar-hover);color:#fff;border-left-color:var(--accent-cyan);}
        .sidebar .nav-link i{width:20px;margin-right:.75rem;font-size:16px;}
        .content{margin-left:240px;min-height:100vh;padding:32px;}
        .card-stat{background:#fff;border:1px solid #e2e8f0;border-radius:8px;padding:20px;text-align:center;}
        .card-stat h3{margin:0;font-size:2.2rem;font-weight:700;color:#1f2937;}
        .badge-status{padding:.35rem .9rem;font-size:.75rem;font-weight:600;border-radius:12px; text-transform: capitalize;}
        .badge-scheduled{background:var(--pending);color:#000;}
        .badge-confirmed{background:var(--approved);color:#fff;}
        .badge-cancelled{background:var(--cancelled);color:#fff;}
        .badge-completed{background: #6c757d; color: #fff;}
        .avatar{width:42px;height:42px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:600;color:#fff;}
        .avatar.bg-primary{background:var(--accent-cyan);}
    </style>
</head>
<body>

<% request.setAttribute("activePage", "appointments"); %>
<jsp:include page="sidebar_doctor.jsp" />

<!-- ===== MAIN CONTENT ===== -->
<div class="content">
    <h2 class="fw-bold">Patient Appointments</h2>
    <p class="text-muted mb-4">Manage and review patient appointment requests</p>

    <!-- Stats row -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3"><div class="card-stat"><p class="text-muted mb-1">Total Appointments</p><h3>${totalAppointments}</h3></div></div>
        <div class="col-6 col-lg-3"><div class="card-stat"><p class="text-muted mb-1">Pending (Scheduled)</p><h3 class="text-warning">${pendingAppointments}</h3></div></div>
        <div class="col-6 col-lg-3"><div class="card-stat"><p class="text-muted mb-1">Confirmed</p><h3 class="text-success">${approvedAppointments}</h3></div></div>
        <div class="col-6 col-lg-3"><div class="card-stat"><p class="text-muted mb-1">Cancelled</p><h3 class="text-danger">${cancelledAppointments}</h3></div></div>
    </div>

    <!-- Appointment table -->
    <div class="table-responsive">
        <table class="table align-middle mb-0 bg-white">
            <thead class="bg-light"><tr><th>Patient</th><th>Date & Time</th><th>Status</th><th class="text-center">Actions</th></tr></thead>
            <tbody>
            <c:forEach var="app" items="${appointments}">
            <tr>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <div class="avatar bg-primary">${app.doctorName.substring(0, 1)}</div>
                        <div><p class="fw-bold mb-1">${app.doctorName}</p></div>
                    </div>
                </td>
                <td>
                    <p class="fw-normal mb-1"><i class="fa-solid fa-calendar-days text-primary me-1"></i>${app.appointmentDate}</p>
                    <p class="text-muted mb-0"><i class="fa-solid fa-clock text-primary me-1"></i>${app.appointmentTime}</p>
                </td>
                <td><span class="badge badge-status badge-${app.status.toLowerCase()}">${app.status}</span></td>
                <td class="text-center">
                    <c:if test="${app.status == 'Scheduled'}">
                        <form action="${pageContext.request.contextPath}/doctor/appointments" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="confirm">
                            <input type="hidden" name="appointmentId" value="${app.appointment_ID}">
                            <button type="submit" class="btn btn-sm btn-success me-1" title="Confirm Appointment"><i class="fa-solid fa-check"></i></button>
                        </form>
                        <form action="${pageContext.request.contextPath}/doctor/appointments" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="appointmentId" value="${app.appointment_ID}">
                            <button type="submit" class="btn btn-sm btn-danger" title="Cancel Appointment"><i class="fa-solid fa-xmark"></i></button>
                        </form>
                    </c:if>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>