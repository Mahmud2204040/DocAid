<!-- Hospital Header -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DocAid Hospital - Dashboard</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <!-- Custom CSS for layout -->
    <style>
        /* When using a fixed sidebar, the main content wrapper needs a left margin 
           equal to the sidebar's width to prevent overlap. */
        #page-content-wrapper {
            margin-left: 250px; /* Must match sidebar width */
        }
    </style>

</head>
<body>

<div id="wrapper">

    <!-- Sidebar -->
    <jsp:include page="/HOSPITAL/sidebar_hospital.jsp" />

    <!-- Page Content Wrapper -->
    <div id="page-content-wrapper">
        <!-- Top Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary border-bottom">
            <div class="container-fluid">
                <span class="navbar-brand mb-0 h1">Hospital Dashboard</span>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-hospital fa-fw"></i> Hospital
                            </a>
                            <div class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/hospital/profile">Profile Settings</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/sign_out.jsp">Logout</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Page Content -->
        <div class="container-fluid p-4">
        <!-- Top Navigation -->
