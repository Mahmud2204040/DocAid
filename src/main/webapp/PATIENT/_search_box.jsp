<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Hero Section -->
<section class="search-hero">
    <div class="container">
        <div class="search-container">
            <h1 class="hero-title">Find Your Perfect Doctor</h1>
            <p class="hero-subtitle">Connect with trusted healthcare professionals in your area</p>
            
            <div class="search-box">
                <form action="${pageContext.request.contextPath}/search" method="get" id="searchForm">
                    <div class="search-input-wrapper">
                        <input type="text" 
                               id="unifiedSearch" 
                               name="q" 
                               class="search-input" 
                               placeholder="Search by doctor name, specialty, or location..."
                               value="<c:out value='${param.q}'/>"
                               autocomplete="off">
                        <i class="bi bi-search search-input-icon"></i>
                    </div>
                    
                    <div class="search-actions">
                        <button type="submit" class="btn btn-modern-primary">
                            <i class="bi bi-search me-2"></i>Search Doctors
                        </button>
                        <button type="button" id="nearMeBtn" class="btn btn-modern-secondary">
                            <i class="bi bi-geo-alt me-2"></i>Find Near Me
                        </button>
                    </div>
                    
                    <input type="hidden" name="lat" id="userLat">
                    <input type="hidden" name="lng" id="userLng">
                </form>
            </div>
        </div>
    </div>
</section>
