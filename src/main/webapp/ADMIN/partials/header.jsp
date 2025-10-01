<!-- Admin Header -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DocAid Admin - Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <!-- Custom Admin CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">

    <!-- Chart.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>
<body>

<div class="d-flex" id="wrapper">

    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Page Content Wrapper -->
    <div id="page-content-wrapper">
        <!-- Top Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
            <div class="container-fluid">
                <button class="btn btn-primary" id="sidebarToggle"><i class="fas fa-bars"></i></button>

                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                        
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Page Content -->
        <div class="container-fluid p-4">