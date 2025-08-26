<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - DocAid</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search_page.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor_card.css">
</head>
<body>
    <%@ include file="header_patient.jsp" %>

    <div class="container mt-5">
        <h1>Search Results for "<c:out value='${param.q}'/>"</h1>
        <p class="text-muted">Found ${searchResult.totalResults} doctors.</p>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <c:if test="${empty searchResult.doctors}">
                    <div class="alert alert-info" role="alert">
                        No doctors found matching your search criteria.
                    </div>
                </c:if>
                <c:forEach var="doctor" items="${searchResult.doctors}">
                    <div class="mb-4">
                        <%@ include file="_doctor_card.jsp" %>
                    </div>
                </c:forEach>

                <c:if test="${searchResult.totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${searchResult.currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?q=${param.q}&page=${searchResult.currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${searchResult.totalPages}" var="i">
                                <li class="page-item ${searchResult.currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?q=${param.q}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${searchResult.currentPage == searchResult.totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?q=${param.q}&page=${searchResult.currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <%@ include file="_booking_modal.jsp" %>
</body>
</html>