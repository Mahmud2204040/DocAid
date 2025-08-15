<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.Year" %>
<%@ page import="classes.Doctor, classes.SearchPageDetails" %>

<%--
  Modern Doctor Search Interface - DocAid
  Features: Contemporary blue design system, elegant typography, smooth interactions
--%>

<c:set var="searchResult" value="${requestScope.searchResult}" />
<c:set var="doctors" value="${searchResult.doctors}" />
<c:set var="totalResults" value="${searchResult.totalResults}" />
<c:set var="totalPages" value="${searchResult.totalPages}" />
<c:set var="currentPage" value="${searchResult.currentPage}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find a Doctor - DocAid</title>
    <meta name="description" content="Search for doctors, specialists, and clinics. Book appointments online with DocAid.">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://your-domain.com/search">
    <meta property="og:title" content="Find a Doctor - DocAid">
    <meta property="og:description" content="Search for doctors, specialists, and clinics. Book appointments online with DocAid.">
    <meta property="og:image" content="${pageContext.request.contextPath}/images/search_hero_section.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://your-domain.com/search">
    <meta property="twitter:title" content="Find a Doctor - DocAid">
    <meta property="twitter:description" content="Search for doctors, specialists, and clinics. Book appointments online with DocAid.">
    <meta property="twitter:image" content="${pageContext.request.contextPath}/images/search_hero_section.png">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search_page.css">
</head>

<body>
    <%@ include file="header_patient.jsp" %>

    <main>
        <jsp:include page="_search_box.jsp" />

        <jsp:include page="_filter_bar.jsp" />

        <!-- Results Section -->
        <section class="results-section">
            <div class="container">
                <!-- Loading State -->
                <div class="loading-container" id="loadingSpinner">
                    <div class="loading-spinner"></div>
                </div>

                <!-- Results Container -->
                <div id="resultsContainer">
                    <c:if test="${not empty doctors}">
                        <div class="row">
                            <c:forEach var="doctor" items="${doctors}">
                                <c:set var="doctor" value="${doctor}" scope="request" />
                                <jsp:include page="_doctor_card.jsp" />
                            </c:forEach>
                        </div>
                    </c:if>
                    
                    <!-- Empty State -->
                    <c:if test="${empty doctors and not empty param.q}">
                        <div class="empty-state">
                            <div class="empty-state-icon">
                                <i class="bi bi-search"></i>
                            </div>
                            <h4>No doctors found</h4>
                            <p>Try adjusting your search terms or filters to find more results.</p>
                            <button type="button" class="btn btn-modern-primary mt-3" onclick="clearSearch()">
                                Clear Search
                            </button>
                        </div>
                    </c:if>
                </div>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-4">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="#" onclick="goToPage(${currentPage - 1})">&laquo; Previous</a>
                                </li>
                            </c:if>
                            
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="#" onclick="goToPage(${currentPage + 1})">Next &raquo;</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </section>
    </main>

    <!-- Alert Container -->
    <div id="alertContainer" aria-live="polite" aria-atomic="true"></div>

    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1" role="dialog" aria-labelledby="bookingModalLabel" aria-modal="true" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookingModalLabel">Book Appointment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Content will be loaded dynamically -->
                    <p>Loading schedule...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center py-5">
        <div class="container">
            <img src="${pageContext.request.contextPath}/logo.png" 
                 alt="DocAid Logo" 
                 style="height: 40px; margin-bottom: 30px;">
            
            <div class="footer-links mb-4">
                <a href="${pageContext.request.contextPath}/">Home</a>
                <a href="#">About</a>
                <a href="#">Services</a>
                <a href="#">Contact</a>
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
            </div>
            
            <div class="social-icons mb-4">
                <a href="#" aria-label="Facebook" class="me-3">
                    <img src="${pageContext.request.contextPath}/facebook-icon.png" 
                         alt="Facebook" style="width: 32px;">
                </a>
                <a href="#" aria-label="Twitter" class="me-3">
                    <img src="${pageContext.request.contextPath}/twitter-icon.png" 
                         alt="Twitter" style="width: 32px;">
                </a>
                <a href="#" aria-label="Instagram">
                    <img src="${pageContext.request.contextPath}/instagram-icon.png" 
                         alt="Instagram" style="width: 32px;">
                </a>
            </div>
            
            <p class="text-muted mb-2">&copy; 2024 DocAid. All rights reserved.</p>
            <p class="text-muted small">Crafted with care by Group H</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
// Utility functions
function applySort(sortValue) {
    const url = new URL(window.location);
    url.searchParams.set('sort', sortValue);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function applyFilter(name, value) {
    const url = new URL(window.location);
    if (value) {
        url.searchParams.set(name, value);
    } else {
        url.searchParams.delete(name);
    }
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
}

function goToPage(pageNumber) {
    const url = new URL(window.location);
    url.searchParams.set('page', pageNumber);
    window.location.href = url.toString();
}

function clearSearch() {
    window.location.href = window.location.pathname;
}

// Modern JavaScript for DocAid Search
class DocAidSearch {
    constructor() {
        this.initializeElements();
        this.bindEvents();
        this.setupAutoComplete();
    }

    initializeElements() {
        this.searchForm = document.getElementById('searchForm');
        this.searchInput = document.getElementById('unifiedSearch');
        this.nearMeBtn = document.getElementById('nearMeBtn');
        this.loadingSpinner = document.getElementById('loadingSpinner');
        this.resultsContainer = document.getElementById('resultsContainer');
        this.alertContainer = document.getElementById('alertContainer');
    }

    bindEvents() {
        if (this.searchForm) {
            this.searchForm.addEventListener('submit', (e) => {
                this.handleSearchSubmit(e);
            });
        }

        if (this.nearMeBtn) {
            this.nearMeBtn.addEventListener('click', () => {
                this.handleNearMe();
            });
        }

        if (this.searchInput) {
            this.searchInput.addEventListener('focus', () => {
                this.searchInput.parentElement.classList.add('focused');
            });

            this.searchInput.addEventListener('blur', () => {
                this.searchInput.parentElement.classList.remove('focused');
            });
        }
    }

    handleSearchSubmit(e) {
        if (!this.searchInput || !this.searchInput.value.trim()) {
            e.preventDefault();
            this.showAlert('Please enter a search term', 'warning');
            return;
        }
        this.showLoading();
    }

    handleNearMe() {
        if (!navigator.geolocation) {
            this.showAlert('Geolocation is not supported by your browser', 'error');
            return;
        }

        this.nearMeBtn.disabled = true;
        this.nearMeBtn.innerHTML = '<div class="spinner-border spinner-border-sm me-2" role="status"></div>Getting location...';

        navigator.geolocation.getCurrentPosition(
            (position) => {
                document.getElementById('userLat').value = position.coords.latitude;
                document.getElementById('userLng').value = position.coords.longitude;
                this.searchInput.value = 'doctors near me';
                this.searchForm.submit();
            },
            (error) => {
                this.handleGeolocationError(error);
                this.resetNearMeButton();
            },
            {
                timeout: 10000,
                enableHighAccuracy: true
            }
        );
    }

    handleGeolocationError(error) {
        let message = 'Unable to get your location. ';
        switch(error.code) {
            case error.PERMISSION_DENIED:
                message += 'You have denied access to your location. Please enable it in your browser settings to use this feature.';
                break;
            case error.POSITION_UNAVAILABLE:
                message += 'Your location information is currently unavailable. Please try again later.';
                break;
            case error.TIMEOUT:
                message += 'The request to get your location timed out. Please try again.';
                break;
            default:
                message += 'An unknown error occurred.';
                break;
        }
        this.showAlert(message, 'warning');
    }

    resetNearMeButton() {
        if (this.nearMeBtn) {
            this.nearMeBtn.disabled = false;
            this.nearMeBtn.innerHTML = '<i class="bi bi-geo-alt me-2"></i>Find Near Me';
        }
    }

    setupAutoComplete() {
        if (!this.searchInput) return;
        
        let timeout;
        this.searchInput.addEventListener('input', () => {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                this.handleAutoComplete();
            }, 300);
        });
    }

    handleAutoComplete() {
        const query = this.searchInput.value.trim();
        if (query.length < 2) return;
        console.log('Auto-completing for:', query);
    }

    showLoading() {
        if (this.loadingSpinner) {
            this.loadingSpinner.style.display = 'flex';
        }
        if (this.resultsContainer) {
            this.resultsContainer.style.display = 'none';
        }
    }

    hideLoading() {
        if (this.loadingSpinner) {
            this.loadingSpinner.style.display = 'none';
        }
        if (this.resultsContainer) {
            this.resultsContainer.style.display = 'block';
        }
    }

    showAlert(message, type = 'info') {
        if (!this.alertContainer) return;
        
        const alertId = 'alert-' + Date.now();
        const iconClass = this.getAlertIcon(type);

        const alertHTML = 
            '<div id="' + alertId + '" class="alert-modern alert-' + type + '" role="alert">' +
            '    <div class="d-flex align-items-center">' +
            '        <i class="bi ' + iconClass + ' me-2"></i>' +
            '        <span>' + message + '</span>' +
            '        <button type="button" class="btn-close ms-auto" onclick="this.parentElement.parentElement.remove()"></button>' +
            '    </div>' +
            '</div>';

        this.alertContainer.insertAdjacentHTML('beforeend', alertHTML);

        setTimeout(() => {
            const alert = document.getElementById(alertId);
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            }
        }, 5000);
    }

    getAlertIcon(type) {
        const icons = {
            success: 'bi-check-circle-fill',
            warning: 'bi-exclamation-triangle-fill',
            error: 'bi-x-circle-fill',
            info: 'bi-info-circle-fill'
        };
        return icons[type] || icons.info;
    }
}

// Initialize the search functionality
document.addEventListener('DOMContentLoaded', () => {
    new DocAidSearch();

    const bookingModal = document.getElementById('bookingModal');
    if (bookingModal) {
        bookingModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const doctorId = button.getAttribute('data-doctor-id');
            const doctorName = button.getAttribute('data-doctor-name');

            const modalTitle = bookingModal.querySelector('.modal-title');
            const modalBody = bookingModal.querySelector('.modal-body');

            if (modalTitle) {
                modalTitle.textContent = 'Book Appointment with ' + doctorName;
            }
            if (modalBody) {
                modalBody.innerHTML = '<p>Loading schedule...</p>';
            }

            // Use JSP variable safely - avoid template literals with JSP EL
            const contextPath = '<c:out value="${pageContext.request.contextPath}"/>';
            
            fetch(contextPath + '/patient/get-doctor-schedule?doctorId=' + doctorId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(schedule => {
                    let scheduleHtml;
                    if (schedule && schedule.length > 0) {
                        scheduleHtml = '<table class="table"><thead><tr><th>Day</th><th>Start Time</th><th>End Time</th></tr></thead><tbody>';
                        schedule.forEach(slot => {
                            scheduleHtml += '<tr><td>' + slot.day + '</td><td>' + slot.startTime + '</td><td>' + slot.endTime + '</td></tr>';
                        });
                        scheduleHtml += '</tbody></table>';
                    } else {
                        scheduleHtml = '<div class="alert alert-info">This doctor has not published their schedule yet. Please check back later.</div>';
                    }

                    if (modalBody) {
                        modalBody.innerHTML = 
                            '<h4>Schedule</h4>' + scheduleHtml + '<hr>' +
                            '<h4>Book Now</h4>' +
                            '<form action="' + contextPath + '/patient/book-appointment" method="post">' +
                            '<input type="hidden" name="doctorId" value="' + doctorId + '">' +
                            '<div class="mb-3">' +
                            '<label for="appointmentDate" class="form-label">Select Date</label>' +
                            '<input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>' +
                            '</div>' +
                            '<div class="mb-3">' +
                            '<label for="appointmentTime" class="form-label">Select Time</label>' +
                            '<input type="time" class="form-control" id="appointmentTime" name="appointmentTime" required>' +
                            '</div>' +
                            '<button type="submit" class="btn btn-primary">Book Now</button>' +
                            '</form>';
                    }
                })
                .catch(error => {
                    if (modalBody) {
                        modalBody.innerHTML = '<div class="alert alert-danger">Could not load the schedule at this time. Please close this window and try again.</div>';
                    }
                    console.error('Error fetching schedule:', error);
                });
        });
    }
    
    // Add entrance animations
    const cards = document.querySelectorAll('.doctor-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease-out';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });

    document.documentElement.style.scrollBehavior = 'smooth';
});

// Parallax effect
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.search-hero');
    if (hero) {
        hero.style.transform = 'translateY(' + (scrolled * 0.3) + 'px)';
    }
});
</script>
</body>
</html>