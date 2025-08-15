<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="classes.Hospital, classes.SearchHospitalDetails" %>

<c:set var="searchResult" value="${requestScope.searchResult}" />
<c:set var="hospitals" value="${searchResult.hospitals}" />
<c:set var="totalResults" value="${searchResult.totalResults}" />
<c:set var="totalPages" value="${searchResult.totalPages}" />
<c:set var="currentPage" value="${searchResult.currentPage}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find a Hospital - DocAid</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --background-color: #f8f9fa;
            --surface-color: #ffffff;
            --text-color: #343a40;
            --text-muted-color: #6c757d;
            --border-color: #dee2e6;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
            --border-radius: 0.5rem;
        }
        body { background-color: var(--background-color); color: var(--text-color); }
        .search-hero { background: linear-gradient(45deg, #0d6efd, #0dcaf0); padding: 4rem 0; color: white; }
        .search-box { background: var(--surface-color); padding: 2rem; border-radius: var(--border-radius); box-shadow: var(--shadow-md); max-width: 800px; margin: auto; }
        .hospital-card { background-color: var(--surface-color); border: 1px solid var(--border-color); border-radius: var(--border-radius); padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: var(--shadow-sm); }
    </style>
</head>
<body>

    <%@ include file="header_patient.jsp" %>

    <main style="margin-top: 56px;">
        <section class="search-hero">
            <div class="container">
                <div class="search-box">
                    <h1 class="h2 text-center mb-1">Find a Hospital</h1>
                    <p class="text-center text-muted mb-4">Search by name or location</p>
                    <form action="${pageContext.request.contextPath}/search-hospitals" method="get" id="searchForm">
                        <div class="input-group input-group-lg mb-3">
                            <input type="text" id="unifiedSearch" name="q" class="form-control" placeholder="e.g., City General, Dhaka" value="<c:out value='${param.q}'/>">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
                        </div>
                        <div class="text-center">
                            <button type="button" id="nearMeBtn" class="btn btn-outline-light">Find Near Me</button>
                        </div>
                        <input type="hidden" name="lat" id="userLat">
                        <input type="hidden" name="lng" id="userLng">
                    </form>
                </div>
            </div>
        </section>

        <section class="container py-4">
            <c:if test="${not empty hospitals}">
                <div class="row">
                    <c:forEach var="hospital" items="${hospitals}">
                        <div class="col-12">
                            <div class="hospital-card">
                                <h4><c:out value="${hospital.hospitalName}"/></h4>
                                <p><i class="bi bi-geo-alt"></i> <c:out value="${hospital.address}"/></p>
                                <a href="hospital_profile.jsp?id=${hospital.hospitalId}" class="btn btn-primary">View Profile & Tests</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </section>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('nearMeBtn').addEventListener('click', () => {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(pos => {
                    document.getElementById('userLat').value = pos.coords.latitude;
                    document.getElementById('userLng').value = pos.coords.longitude;
                    const url = new URL(window.location.origin + "${pageContext.request.contextPath}/search-hospitals");
                    url.searchParams.set('lat', pos.coords.latitude);
                    url.searchParams.set('lng', pos.coords.longitude);
                    url.searchParams.set('sort', 'distance');
                    window.location.href = url.toString();
                });
            }
        });
    </script>

</body>
</html>
