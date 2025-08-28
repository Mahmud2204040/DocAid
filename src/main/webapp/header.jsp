
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!-- Header Navigation Section -->
<style>
    :root {
      --background-color: #f8f9fa;
      --primary-color: #007BFF;
      --secondary-color: #28A745;
      --text-color: #333333;
    }

    body {
      font-family: 'Roboto', sans-serif;
      background-color: var(--background-color);
      padding-top: 56px; /* for fixed navbar */
    }

    .navbar {
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .nav-link {
      font-weight: 500;
      color: var(--text-color);
    }

    .nav-link:hover {
      color: var(--primary-color) !important;
    }

    /* Fixed navbar button styles */
    .navbar-btn {
      color: white !important;
      text-decoration: none !important;
      padding: 8px 20px !important;
      border-radius: 25px !important;
      font-weight: 500 !important;
      transition: all 0.3s ease !important;
      border: none !important;
      display: inline-block !important;
    }

    .navbar-btn.btn-primary {
      background-color: var(--primary-color) !important;
      border-color: var(--primary-color) !important;
    }

    .navbar-btn.btn-primary:hover {
      background-color: #0056b3 !important;
      border-color: #0056b3 !important;
      transform: translateY(-1px) !important;
    }

    .navbar-btn.btn-secondary {
      background-color: var(--secondary-color) !important;
      border-color: var(--secondary-color) !important;
    }

    .navbar-btn.btn-secondary:hover {
      background-color: #218838 !important;
      border-color: #218838 !important;
      transform: translateY(-1px) !important;
    }

    /* Rest of your existing CSS remains the same */
    .form-control {
      border-color: var(--primary-color);
      border-right: none;
    }

    .hero {
      padding: 60px 0;
      position: relative;
      padding-bottom: 140px; /* makes room for the search bar at bottom */
    }

    .hero::before {
      content: '';
      position: absolute;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: radial-gradient(circle, rgba(0,123,255,0.1) 0%, transparent 70%);
      z-index: -1;
    }

    /* HERO SEARCH BAR – Positioned at bottom of hero section */
    .hero .search-container {
      position: absolute;
      bottom: 40px; /* distance from the hero's bottom edge */
      left: 50%;
      transform: translateX(-50%); /* centers horizontally */
      width: 100%;
      max-width: 1200px; /* container width for extended search bar */
      padding: 0 15px;
      z-index: 10;
    }

    .hero .input-group {
      border-radius: 50px;
      box-shadow: 0 4px 25px rgba(0, 123, 255, 0.2);
      overflow: hidden;
      background: white;
      border: 2px solid var(--primary-color);
      width: 100%;
    }

    .hero .input-group > .form-control {
      height: 70px; /* increased height */
      padding: 0 30px; /* increased padding */
      border: none;
      font-size: 18px; /* larger font size */
      background: transparent;
      min-width: 300px; /* minimum width for each field */
    }

    .hero .input-group > .form-control:focus {
      box-shadow: none;
      border: none;
      outline: none;
    }

    .hero .input-group > .form-control:first-child {
      flex: 1 1 50%; /* doctor/condition field - extended double length */
      border-right: 2px solid #e9ecef;
    }

    .hero .input-group > .form-control:last-child {
      flex: 1 1 50%; /* location field - extended double length */
    }

    .hero .input-group-append > .btn {
      height: 70px;
      width: 70px;
      border-radius: 50%;
      border: none;
      background: var(--primary-color);
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 22px;
      margin: 4px;
      transition: all 0.3s ease;
      box-shadow: 0 2px 10px rgba(0, 123, 255, 0.3);
    }

    .hero .input-group-append > .btn:hover {
      background: #0056b3;
      transform: scale(1.05);
      box-shadow: 0 4px 15px rgba(0, 123, 255, 0.4);
    }

    .hero .input-group > .form-control::placeholder {
      color: #6c757d;
      font-weight: 400;
      font-size: 16px;
    }

    .card {
      transition: transform 0.2s;
      border: none;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .card:hover {
      transform: translateY(-5px);
    }

    .btn-primary {
      background-color: var(--primary-color);
      border-color: var(--primary-color);
    }

    .btn-primary:hover {
      background-color: #0056b3;
      border-color: #0056b3;
    }

    .btn-secondary {
      background-color: var(--secondary-color);
      border-color: var(--secondary-color);
    }

    .btn-secondary:hover {
      background-color: #218838;
      border-color: #218838;
    }

    .footer-links a {
      color: var(--text-color);
      margin: 0 10px;
    }

    .footer-links a:hover {
      color: var(--primary-color);
      text-decoration: none;
    }

     @media (max-width: 992px) {
      .hero .search-container {
        max-width: 100%;
        padding: 0 20px;
      }
      .hero .input-group > .form-control {
        min-width: 200px;
        font-size: 16px;
      }
      
      /* Stack buttons vertically on smaller screens */
      .navbar-nav.ms-3 {
        flex-direction: column;
        gap: 10px;
        margin-top: 1rem;
      }
    }

     @media (max-width: 767px) {
      .hero .row {
        flex-direction: column-reverse;
      }
      .hero img {
        margin-bottom: 20px;
      }
      .hero {
        padding-bottom: 160px; /* more room for mobile search bar */
      }
      .hero .search-container {
        bottom: 20px;
        padding: 0 15px;
      }
      .hero .input-group {
        flex-direction: column;
        border-radius: 25px;
      }
      .hero .input-group > .form-control {
        height: 55px;
        border-right: none !important;
        border-bottom: 2px solid #e9ecef;
        min-width: auto;
        font-size: 16px;
      }
      .hero .input-group > .form-control:last-child {
        border-bottom: none;
      }
      .hero .input-group-append {
        padding: 10px;
        justify-content: center;
      }
      .hero .input-group-append > .btn {
        height: 55px;
        width: 55px;
        margin: 0;
        font-size: 18px;
      }
    }
</style>

<!-- Navigation Bar - Header Content -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/">
        <img src="${pageContext.request.contextPath}/images/logo.png" alt="DocAid Logo" style="height: 40px;"/>
    </a>
    <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarNav"
        aria-controls="navbarNav"
        aria-expanded="false"
        aria-label="Toggle navigation"
    >
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav me-auto">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/about.jsp">About</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/#services">Services</a></li>
            <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
        </ul>

        <!-- Sign Up / Sign In - Fixed buttons -->
        <div class="navbar-nav ms-3">
            <a class="btn btn-primary me-2 navbar-btn" href="${pageContext.request.contextPath}/sign_up.jsp">Sign Up</a>
            <a class="btn btn-secondary navbar-btn" href="${pageContext.request.contextPath}/log.jsp">Sign In</a>
        </div>
    </div>
</nav>