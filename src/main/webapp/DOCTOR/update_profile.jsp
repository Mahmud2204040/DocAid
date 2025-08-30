<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DocAid – Update Profile</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root{--sidebar-bg:#334155; --sidebar-hover:#475569; --sidebar-text:#f1f5f9; --accent-cyan:#0891b2; --body-bg:#f8fafc;}
        body{background:var(--body-bg);font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;}
        .sidebar{width:240px;min-height:100vh;background:var(--sidebar-bg);position:fixed;left:0;top:0;}
        .sidebar .brand{color:var(--sidebar-text);font-size:1.5rem;font-weight:700;display:flex;align-items:center;padding:1rem 1.5rem;border-bottom:1px solid rgba(255,255,255,.1);}
        .sidebar .brand::before{content:"DA";background:var(--accent-cyan);color:#fff;width:32px;height:32px;border-radius:6px;display:flex;align-items:center;justify-content:center;font-size:14px;font-weight:600;margin-right:.75rem;}
        .sidebar .nav{padding:1rem 0;}
        .sidebar .nav-link{color:var(--sidebar-text);padding:.75rem 1.5rem;display:flex;align-items:center;border-left:3px solid transparent;transition:.2s;}
        .sidebar .nav-link:hover,.sidebar .nav-link.active{background:var(--sidebar-hover);color:#fff;border-left-color:var(--accent-cyan);}
        .sidebar .nav-link i{width:20px;margin-right:.75rem;font-size:16px;}
        .content{margin-left:240px;min-height:100vh;padding:32px;}
        .card-form{background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:2rem;box-shadow:0 1px 3px rgba(0,0,0,.1);}
        .card-form h3{font-weight:700;margin-bottom:1.5rem;}
    </style>
</head>
<body>
<% request.setAttribute("activePage", "update"); %>
<jsp:include page="sidebar_doctor.jsp" />

<!-- ===== MAIN CONTENT ===== -->
<div class="content">
    <div class="card-form mx-auto" style="max-width:800px;">
        <h3>Update Profile Information</h3>
        <p class="text-muted">Keep your professional details up to date.</p>
        <hr/>
        <form action="${pageContext.request.contextPath}/doctor/update-profile" method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">First Name</label>
                    <input type="text" class="form-control" name="firstName" value="${doctorProfile.firstName}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="lastName" value="${doctorProfile.lastName}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Gender</label>
                    <select name="gender" class="form-select">
                        <option value="Male" ${doctorProfile.gender == 'Male' ? 'selected' : ''}>Male</option>
                        <option value="Female" ${doctorProfile.gender == 'Female' ? 'selected' : ''}>Female</option>
                        <option value="Other" ${doctorProfile.gender == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Primary Contact</label>
                    <input type="tel" class="form-control" name="primary_contact" value="${primaryContact}" placeholder="Your main contact number">
                    <div class="form-text">This number is for hospital use.</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Appointment Contact</label>
                    <input type="tel" class="form-control" name="appointment_contact" value="${appointmentContact}" placeholder="Number for patient appointments">
                     <div class="form-text">This number is for patient use.</div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Address</label>
                    <input type="text" class="form-control" name="address" value="${doctorProfile.address}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Consultation Fee ($)</label>
                    <input type="number" class="form-control" name="fee" value="${doctorProfile.fee}" step="0.01">
                </div>
                <div class="col-12">
                    <label class="form-label">Biography</label>
                    <textarea class="form-control" name="bio" rows="4">${doctorProfile.bio}</textarea>
                </div>
                <div class="col-12 text-end">
                    <a href="${pageContext.request.contextPath}/doctor/profile" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save me-1"></i>Save Changes</button>
                </div>
            </div>
        </form>

        <hr class="my-4"/>

        <div id="affiliation-management">
            <h3>Affiliation Management</h3>
            <c:choose>
                <c:when test="${not empty doctorProfile.hospitalName}">
                    <p>You are currently affiliated with: <strong><c:out value="${doctorProfile.hospitalName}"/></strong></p>
                    <form action="${pageContext.request.contextPath}/doctor/affiliation" method="POST" onsubmit="return confirm('Are you sure you want to remove your affiliation with this hospital?');">
                        <input type="hidden" name="action" value="remove">
                        <button type="submit" class="btn btn-danger">Remove Affiliation</button>
                    </form>
                    <p class="form-text mt-2">To change your affiliated hospital, you must first receive and approve a request from the new hospital on the 'Affiliation Requests' page.</p>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">You are not currently affiliated with any hospital.</p>
                    <a href="${pageContext.request.contextPath}/doctor/affiliation" class="btn btn-success">View Pending Requests</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>