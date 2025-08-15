<!-- Admin Sidebar -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="bg-dark border-right" id="sidebar-wrapper">
    <div class="sidebar-heading text-light">DocAid Admin</div>
    <div class="list-group list-group-flush">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-users me-2"></i>User Management
        </a>
        <a href="${pageContext.request.contextPath}/admin/reviews" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-star me-2"></i>Review Moderation
        </a>
        <a href="${pageContext.request.contextPath}/admin/monitoring" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-binoculars me-2"></i>Activity Monitoring
        </a>
        <a href="${pageContext.request.contextPath}/admin/specialties" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-cogs me-2"></i>System Settings
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="list-group-item list-group-item-action bg-dark text-light">
            <i class="fas fa-chart-line me-2"></i>Reports
        </a>
    </div>
</div>