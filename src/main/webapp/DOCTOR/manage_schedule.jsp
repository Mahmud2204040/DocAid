<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DocAid – Manage Schedule</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        :root{--sidebar-bg:#334155; --sidebar-hover:#475569; --sidebar-text:#f1f5f9; --accent-cyan:#0891b2; --body-bg:#f8fafc;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:var(--body-bg);}
        .sidebar{width:240px;min-height:100vh;background:var(--sidebar-bg);position:fixed;left:0;top:0;}
        .sidebar .brand{color:var(--sidebar-text);font-size:1.5rem;font-weight:700;display:flex;align-items:center;padding:1rem 1.5rem;border-bottom:1px solid rgba(255,255,255,.1);}
        .sidebar .nav{padding:1rem 0;}
        .sidebar .nav-link{color:var(--sidebar-text);padding:.75rem 1.5rem;display:flex;align-items:center;border-left:3px solid transparent;transition:.2s;}
        .sidebar .nav-link:hover,.sidebar .nav-link.active{background:var(--sidebar-hover);color:#fff;border-left-color:var(--accent-cyan);}
        .sidebar .nav-link i{width:20px;margin-right:.75rem;font-size:16px;}
        .content{margin-left:240px;min-height:100vh;padding:32px;}
        .card-schedule{background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:2rem;box-shadow:0 1px 3px rgba(0,0,0,.1);}
    </style>
</head>
<body>
<% request.setAttribute("activePage", "schedule"); %>
<jsp:include page="sidebar_doctor.jsp" />

<!-- ===== MAIN CONTENT ===== -->
<div class="content">
    <div class="card-schedule">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="m-0 fw-bold">Weekly Schedule</h3>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSlotModal">
                <i class="fas fa-plus me-1"></i>Add Time Slot
            </button>
        </div>

        <!-- Schedule Table -->
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th style="width:160px;">Day</th>
                        <th>Available Time Slots</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${scheduleMap}">
                        <tr>
                            <td class="fw-semibold">${entry.key}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty entry.value}">
                                        <c:forEach var="slot" items="${entry.value}">
                                            <span class="badge bg-success bg-opacity-25 text-success border border-success me-2 p-2">
                                                ${slot}
                                            </span>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ===== Add Slot Modal ===== -->
<div class="modal fade" id="addSlotModal" tabindex="-1" aria-labelledby="addSlotLabel" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" action="${pageContext.request.contextPath}/doctor/schedule" method="post">
      <div class="modal-header">
        <h5 class="modal-title" id="addSlotLabel">Add Time Slot</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="mb-3">
              <label class="form-label">Day</label>
              <select class="form-select" name="day">
                  <option>Monday</option><option>Tuesday</option><option>Wednesday</option>
                  <option>Thursday</option><option>Friday</option><option>Saturday</option><option>Sunday</option>
              </select>
          </div>
          <div class="row g-2">
              <div class="col">
                  <label class="form-label">Start Time</label>
                  <input type="time" class="form-control" name="startTime" required>
              </div>
              <div class="col">
                  <label class="form-label">End Time</label>
                  <input type="time" class="form-control" name="endTime" required>
              </div>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-primary">Save Slot</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>