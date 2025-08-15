<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- This page uses the same layout as update_profile.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DocAid – Affiliation Requests</title>
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
    </style>
</head>
<body>

<%-- Set active page for sidebar --%>
<c:set var="activePage" value="affiliation" scope="request"/>
<jsp:include page="sidebar_doctor.jsp" />

<div class="content">
    <h1 class="mb-4">Affiliation Requests</h1>

    <div class="alert alert-info" role="alert">
        <strong>Important:</strong> Approving a request will automatically affiliate you with that hospital and will deny any other pending requests. If you are currently affiliated with another hospital, this will replace your current affiliation.
    </div>

    <%-- Display feedback message if it exists --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert ${sessionScope.messageClass} alert-dismissible fade show" role="alert">
            <c:out value="${sessionScope.message}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("message"); %>
        <% session.removeAttribute("messageClass"); %>
    </c:if>

    <div class="card shadow-sm">
        <div class="card-header">
            <h6 class="m-0 font-weight-bold text-primary">Pending Requests from Hospitals</h6>
        </div>
        <div class="card-body">
            <div class="list-group">
                <c:forEach var="req" items="${requestList}">
                    <div class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-1"><strong><c:out value="${req.hospitalName}"/></strong></h5>
                            <small>Received on: <c:out value="${req.requestDate}"/></small>
                        </div>
                        <div>
                            <form action="<%= request.getContextPath() %>/doctor/affiliation" method="POST" class="d-inline">
                                <input type="hidden" name="action" value="respond">
                                <input type="hidden" name="request_id" value="${req.requestId}">
                                <input type="hidden" name="response" value="Approved">
                                <button type="submit" class="btn btn-success btn-sm">Approve</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/doctor/affiliation" method="POST" class="d-inline">
                                <input type="hidden" name="action" value="respond">
                                <input type="hidden" name="request_id" value="${req.requestId}">
                                <input type="hidden" name="response" value="Denied">
                                <button type="submit" class="btn btn-danger btn-sm">Deny</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty requestList}">
                    <div class="list-group-item text-center">You have no pending affiliation requests.</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>