<!-- /WEB-INF/jsp/includes/sidebar_doctor.jsp -->
<nav class="sidebar">
    <div class="brand">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="DocAid Logo" style="height: 60px; margin-right: 15px;">DocAid
    </div>
    <ul class="nav flex-column">
        <!-- My Profile -->
        <li class="nav-item">
            <a class="nav-link <%= "profile".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/profile">
                <i class="fas fa-user"></i>
                My Profile
            </a>
        </li>
        <!-- View Appointments -->
        <li class="nav-item">
            <a class="nav-link <%= "appointments".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/appointments">
                <i class="fas fa-calendar-check"></i>
                View Appointments
            </a>
        </li>
        <!-- Update Profile -->
        <li class="nav-item">
            <a class="nav-link <%= "update".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/update-profile">
                <i class="fas fa-user-edit"></i>
                Update Profile
            </a>
        </li>
        <!-- View Review -->
        <li class="nav-item">
            <a class="nav-link <%= "review".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/reviews">
                <i class="fas fa-star"></i>
                View Review
            </a>
        </li>
        <!-- Manage Schedule -->
        <li class="nav-item">
            <a class="nav-link <%= "schedule".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/schedule">
                <i class="fas fa-clock"></i>
                Manage Schedule
            </a>
        </li>
        <!-- Affiliation Requests -->
        <li class="nav-item">
            <a class="nav-link <%= "affiliation".equals(request.getAttribute("activePage")) ? "active" : "" %>"
               href="<%= request.getContextPath() %>/doctor/affiliation">
                <i class="fas fa-handshake"></i>
                Affiliation Requests
            </a>
        </li>
        <!-- Sign Out -->
        <li class="nav-item">
            <a class="nav-link" href="<%= request.getContextPath() %>/sign_out.jsp">
                <i class="fas fa-sign-out-alt"></i>
                Sign Out
            </a>
        </li>
    </ul>
</nav>
