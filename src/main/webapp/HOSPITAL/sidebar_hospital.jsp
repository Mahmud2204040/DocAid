<!-- /HOSPITAL/sidebar_hospital.jsp -->
<nav class="sidebar">
    <div class="brand">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="DocAid Logo" style="height: 60px; margin-right: 15px;">
        DocAid
    </div>
    <ul class="nav flex-column">
        <!-- Dashboard -->
        <li class="nav-item">
            <a class="nav-link <%= "dashboard".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/dashboard">
                <i class="fas fa-tachometer-alt"></i>
                Dashboard
            </a>
        </li>
        <!-- Profile -->
        <li class="nav-item">
            <a class="nav-link <%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/profile">
                <i class="fas fa-hospital"></i>
                My Profile
            </a>
        </li>
        <!-- Doctor Directory -->
        <li class="nav-item">
            <a class="nav-link <%= "doctors".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/doctors">
                <i class="fas fa-user-md"></i>
                Doctors
            </a>
        </li>
        <!-- Appointments -->
        <li class="nav-item">
            <a class="nav-link <%= "appointments".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/appointments">
                <i class="fas fa-calendar-check"></i>
                Appointments
            </a>
        </li>
        <!-- Medical Tests -->
        <li class="nav-item">
            <a class="nav-link <%= "tests".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/medical-tests">
                <i class="fas fa-vial"></i>
                Medical Tests
            </a>
        </li>
        <!-- Patient Feedback -->
        <li class="nav-item">
            <a class="nav-link <%= "feedback".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/hospital/feedback">
                <i class="fas fa-star"></i>
                Patient Feedback
            </a>
        </li>
        <!-- Sign Out -->
        <li class="nav-item mt-auto">
            <a class="nav-link" href="<%= request.getContextPath() %>/sign_out.jsp">
                <i class="fas fa-sign-out-alt"></i>
                Sign Out
            </a>
        </li>
    </ul>
</nav>

<style>
    .sidebar {
        width: 250px;
        background-color: #343a40;
        color: white;
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        padding-top: 20px;
        display: flex;
        flex-direction: column;
    }
    .sidebar .brand {
        font-size: 1.5rem;
        font-weight: bold;
        text-align: left;
        margin-bottom: 20px;
        padding-left: 20px;
        display: flex;
        align-items: center;
    }
    .sidebar .nav-link {
        color: #adb5bd;
        padding: 12px 20px;
        display: flex;
        align-items: center;
        transition: all 0.2s;
    }
    .sidebar .nav-link i {
        margin-right: 15px;
        width: 20px; /* Ensure icons are aligned */
        text-align: center;
    }
    .sidebar .nav-link:hover {
        color: #fff;
        background-color: #495057;
    }
    .sidebar .nav-link.active {
        color: #fff;
        font-weight: bold;
        background-color: #0d6efd; /* Bootstrap primary color */
    }
    .sidebar .mt-auto {
        margin-top: auto;
        padding-bottom: 20px;
    }
</style>
