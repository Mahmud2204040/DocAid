<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Filter Bar -->
<section class="filter-bar">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div class="results-count">
                <c:if test="${not empty doctors}">
                    <span class="count-number">${totalResults}</span> doctors found
                </c:if>
                <c:if test="${empty doctors and not empty param.q}">
                    No results found
                </c:if>
            </div>
            
            <div class="filter-actions">
                <div class="dropdown">
                    <button class="filter-btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-sort-down"></i>Sort By
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#" onclick="applySort('relevance')">Relevance</a></li>
                        <li><a class="dropdown-item" href="#" onclick="applySort('rating')">Top Rated</a></li>
                        <li><a class="dropdown-item" href="#" onclick="applySort('distance')">Distance</a></li>
                        <li><a class="dropdown-item" href="#" onclick="applySort('name')">Name A-Z</a></li>
                    </ul>
                </div>
                
                <div class="dropdown">
                    <button class="filter-btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-funnel"></i>Filters
                    </button>
                    <div class="dropdown-menu dropdown-menu-end p-3" style="width: 280px;">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Minimum Rating</label>
                            <select class="form-select form-select-sm" onchange="applyFilter('rating', this.value)">
                                <option value="">Any Rating</option>
                                <option value="4.5">4.5+ Stars</option>
                                <option value="4">4+ Stars</option>
                                <option value="3.5">3.5+ Stars</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Availability</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="availableToday" onchange="applyFilter('availability', this.checked ? 'today' : '')">
                                <label class="form-check-label" for="availableToday">Available Today</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="acceptingPatients" onchange="applyFilter('accepting', this.checked ? 'yes' : '')">
                                <label class="form-check-label" for="acceptingPatients">Accepting New Patients</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
