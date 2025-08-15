<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile - DocAid Patient Portal</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning-gradient: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
            --danger-gradient: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --info-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            
            --bg-primary: #f8fafc;
            --bg-secondary: #ffffff;
            --text-primary: #1a202c;
            --text-secondary: #4a5568;
            --text-muted: #718096;
            --border-color: #e2e8f0;
            --shadow-light: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-medium: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-heavy: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            
            --transition-fast: all 0.2s ease-in-out;
            --transition-medium: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --transition-slow: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Header Styles */
        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 4rem 0 6rem;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .page-header .container {
            position: relative;
            z-index: 2;
        }

        .page-title {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out;
        }

        .page-subtitle {
            font-size: 1.25rem;
            font-weight: 300;
            opacity: 0.9;
            max-width: 600px;
            animation: fadeInUp 1s ease-out 0.2s both;
        }

        .header-icon {
            position: absolute;
            right: 2rem;
            top: 50%;
            transform: translateY(-50%);
            font-size: 8rem;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        /* Main Content */
        .main-content {
            margin-top: -3rem;
            position: relative;
            z-index: 10;
            padding: 2rem 0 4rem;
        }

        .profile-form-card {
            background: var(--bg-secondary);
            border-radius: 24px;
            box-shadow: var(--shadow-medium);
            border: 1px solid var(--border-color);
            overflow: hidden;
            position: relative;
        }

        .profile-form-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
            z-index: 1;
        }

        .form-header {
            padding: 2.5rem 2.5rem 1.5rem;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid var(--border-color);
            text-align: center;
        }

        .form-header h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--text-secondary);
            font-size: 1rem;
            margin: 0;
        }

        .form-container {
            padding: 2.5rem;
        }

        /* Alert Styles */
        .alert-custom {
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(5, 150, 105, 0.1) 100%);
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(220, 38, 38, 0.1) 100%);
            color: #7f1d1d;
            border-left: 4px solid #ef4444;
        }

        /* Form Group Styles */
        .form-group {
            margin-bottom: 2rem;
            position: relative;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-label i {
            color: var(--text-muted);
            font-size: 1rem;
        }

        .form-control,
        .form-select {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            font-size: 1rem;
            font-weight: 500;
            background: var(--bg-secondary);
            color: var(--text-primary);
            transition: var(--transition-fast);
            position: relative;
        }

        .form-control:focus,
        .form-select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-control:hover,
        .form-select:hover {
            border-color: #a0aec0;
            transform: translateY(-1px);
        }

        /* Input Icons */
        .input-group-icon {
            position: relative;
        }

        .input-group-icon .form-control {
            padding-left: 3rem;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.1rem;
            z-index: 5;
        }

        /* Form Row Enhancements */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 1rem;
        }

        .form-row-full {
            display: grid;
            grid-template-columns: 1fr;
            margin-bottom: 1rem;
        }

        /* Button Styles */
        .btn-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3rem;
            gap: 1rem;
        }

        .btn-primary-custom {
            background: var(--primary-gradient);
            border: none;
            color: white;
            padding: 1rem 2.5rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: var(--transition-medium);
            box-shadow: var(--shadow-light);
            position: relative;
            overflow: hidden;
        }

        .btn-primary-custom::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: var(--transition-medium);
        }

        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-heavy);
        }

        .btn-primary-custom:hover::before {
            left: 100%;
        }

        .btn-secondary-custom {
            background: transparent;
            border: 2px solid var(--border-color);
            color: var(--text-secondary);
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition-fast);
        }

        .btn-secondary-custom:hover {
            background: var(--bg-primary);
            border-color: var(--text-muted);
            color: var(--text-primary);
            transform: translateY(-2px);
            text-decoration: none;
        }

        /* Progress Indicator */
        .progress-container {
            background: var(--bg-primary);
            padding: 1.5rem 2.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .progress-steps {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2rem;
        }

        .step {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .step.active {
            color: #667eea;
        }

        .step-number {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--border-color);
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .step.active .step-number {
            background: var(--primary-gradient);
            color: white;
        }

        /* Validation Styles */
        .form-control.is-invalid {
            border-color: #ef4444;
            animation: shake 0.5s ease-in-out;
        }

        .form-control.is-valid {
            border-color: #10b981;
        }

        .invalid-feedback {
            color: #ef4444;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: block;
        }

        .valid-feedback {
            color: #10b981;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: block;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(-50px) rotate(0deg); }
            50% { transform: translateY(-70px) rotate(5deg); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Loading Spinner */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: var(--transition-fast);
        }

        .loading-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #e2e8f0;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-title {
                font-size: 2.5rem;
            }
            
            .header-icon {
                display: none;
            }
            
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .btn-container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                text-align: center;
            }
            
            .form-container {
                padding: 1.5rem;
            }
            
            .progress-steps {
                gap: 1rem;
            }
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 2rem 0 4rem;
            }
            
            .page-title {
                font-size: 2rem;
            }
            
            .form-header {
                padding: 1.5rem;
            }
            
            .progress-steps {
                flex-direction: column;
                gap: 0.5rem;
            }
        }

        /* Custom Select Styling */
        .form-select {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 1rem center;
            background-repeat: no-repeat;
            background-size: 1rem;
            padding-right: 3rem;
        }

        /* Blood Group Special Styling */
        .blood-group-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        .blood-group-option {
            padding: 0.75rem;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: var(--transition-fast);
            font-weight: 600;
            background: white;
        }

        .blood-group-option:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.1);
        }

        .blood-group-option.selected {
            border-color: #667eea;
            background: var(--primary-gradient);
            color: white;
        }

        /* Floating Labels Effect */
        .floating-label {
            position: relative;
        }

        .floating-label input,
        .floating-label select,
        .floating-label textarea {
            padding-top: 1.5rem;
            padding-bottom: 0.5rem;
        }

        .floating-label label {
            position: absolute;
            top: 1rem;
            left: 1.25rem;
            transition: var(--transition-fast);
            pointer-events: none;
            color: var(--text-muted);
        }

        .floating-label input:focus + label,
        .floating-label input:not(:placeholder-shown) + label,
        .floating-label select:focus + label,
        .floating-label textarea:focus + label,
        .floating-label textarea:not(:placeholder-shown) + label {
            top: 0.25rem;
            font-size: 0.75rem;
            color: #667eea;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <%@ include file="header_patient.jsp" %>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="page-title">Update Profile</h1>
                    <p class="page-subtitle">
                        Keep your personal information up to date to ensure the best healthcare experience. 
                        Your privacy and security are our top priorities.
                    </p>
                </div>
            </div>
            <i class="fas fa-user-edit header-icon"></i>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <div class="profile-form-card animate__animated animate__fadeInUp">
                
                <!-- Form Header -->
                <div class="form-header">
                    <h2><i class="fas fa-user-circle me-2"></i>Personal Information</h2>
                    <p>Update your profile details below</p>
                </div>

                <!-- Progress Indicator -->
                <div class="progress-container">
                    <div class="progress-steps">
                        <div class="step active">
                            <div class="step-number">1</div>
                            <span>Personal Details</span>
                        </div>
                        <div class="step">
                            <div class="step-number">2</div>
                            <span>Contact Info</span>
                        </div>
                        <div class="step">
                            <div class="step-number">3</div>
                            <span>Medical Info</span>
                        </div>
                    </div>
                </div>

                <!-- Form Container -->
                <div class="form-container">
                    <c:if test="${not empty sessionScope.bookingError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${sessionScope.bookingError}"/>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="bookingError" scope="session" />
                    </c:if>
                    
                    <!-- Update Form -->
                    <form id="updateProfileForm" action="${pageContext.request.contextPath}/patient/update-profile" method="post" novalidate>
                        
                        <!-- Personal Information Section -->
                        <div class="section-header mb-4">
                            <h4><i class="fas fa-user me-2"></i>Personal Information</h4>
                            <hr>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-user"></i>
                                    First Name *
                                </label>
                                <div class="input-group-icon">
                                    <input type="text" class="form-control" name="firstName" 
                                           value="<c:out value='${patient.firstName}'/>" required 
                                           placeholder="Enter your first name">
                                    <i class="fas fa-user input-icon"></i>
                                </div>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-user"></i>
                                    Last Name *
                                </label>
                                <div class="input-group-icon">
                                    <input type="text" class="form-control" name="lastName" 
                                           value="<c:out value='${patient.lastName}'/>" required 
                                           placeholder="Enter your last name">
                                    <i class="fas fa-user input-icon"></i>
                                </div>
                                <div class="invalid-feedback"></div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-venus-mars"></i>
                                    Gender
                                </label>
                                <select class="form-select" name="gender">
                                    <option value="">Select Gender</option>
                                    <option value="Male" <c:if test="${patient.gender == 'Male'}">selected</c:if>>Male</option>
                                    <option value="Female" <c:if test="${patient.gender == 'Female'}">selected</c:if>>Female</option>
                                    <option value="Other" <c:if test="${patient.gender == 'Other'}">selected</c:if>>Other</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-birthday-cake"></i>
                                    Date of Birth
                                </label>
                                <input type="date" class="form-control" name="dob" 
                                       value="<c:out value='${patient.dateOfBirth}'/>">
                            </div>
                        </div>

                        <!-- Contact Information Section -->
                        <div class="section-header mb-4 mt-5">
                            <h4><i class="fas fa-address-book me-2"></i>Contact Information</h4>
                            <hr>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-envelope"></i>
                                    Email Address *
                                </label>
                                <div class="input-group-icon">
                                    <input type="email" class="form-control" name="email" 
                                           value="<c:out value='${patient.email}'/>" required 
                                           placeholder="Enter your email address">
                                    <i class="fas fa-envelope input-icon"></i>
                                </div>
                                <div class="invalid-feedback"></div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-phone"></i>
                                    Phone Number
                                </label>
                                <div class="input-group-icon">
                                    <input type="tel" class="form-control" name="phone" 
                                           value="<c:out value='${patient.phone}'/>" 
                                           placeholder="Enter your phone number">
                                    <i class="fas fa-phone input-icon"></i>
                                </div>
                            </div>
                        </div>

                        <div class="form-row-full">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-map-marker-alt"></i>
                                    Address
                                </label>
                                <div class="input-group-icon">
                                    <input type="text" class="form-control" name="address" 
                                           value="<c:out value='${patient.address}'/>" 
                                           placeholder="Enter your full address">
                                    <i class="fas fa-map-marker-alt input-icon"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Medical Information Section -->
                        <div class="section-header mb-4 mt-5">
                            <h4><i class="fas fa-heartbeat me-2"></i>Medical Information</h4>
                            <hr>
                        </div>

                        <div class="form-row-full">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="fas fa-tint"></i>
                                    Blood Group
                                </label>
                                <input type="text" class="form-control" name="bloodGroup" 
                                       value="<c:out value='${patient.bloodType}'/>" 
                                       placeholder="e.g., A+, B-, O+, AB-">
                                
                                <!-- Blood Group Quick Select -->
                                <div class="blood-group-container mt-2">
                                    <div class="blood-group-option" data-value="A+">A+</div>
                                    <div class="blood-group-option" data-value="A-">A-</div>
                                    <div class="blood-group-option" data-value="B+">B+</div>
                                    <div class="blood-group-option" data-value="B-">B-</div>
                                    <div class="blood-group-option" data-value="AB+">AB+</div>
                                    <div class="blood-group-option" data-value="AB-">AB-</div>
                                    <div class="blood-group-option" data-value="O+">O+</div>
                                    <div class="blood-group-option" data-value="O-">O-</div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="btn-container">
                            <a href="${pageContext.request.contextPath}/patient/profile" class="btn-secondary-custom">
                                <i class="fas fa-arrow-left me-2"></i>
                                Cancel
                            </a>
                            <button type="submit" class="btn-primary-custom">
                                <i class="fas fa-save me-2"></i>
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Form validation
        const form = document.getElementById('updateProfileForm');
        const loadingOverlay = document.getElementById('loadingOverlay');
        
        // Real-time validation
        function validateField(field) {
            const value = field.value.trim();
            const feedback = field.parentNode.nextElementSibling;
            
            field.classList.remove('is-invalid', 'is-valid');
            
            if (field.hasAttribute('required') && !value) {
                field.classList.add('is-invalid');
                feedback.textContent = 'This field is required.';
                return false;
            }
            
            if (field.type === 'email' && value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    field.classList.add('is-invalid');
                    feedback.textContent = 'Please enter a valid email address.';
                    return false;
                }
            }
            
            if (field.name === 'phone' && value) {
                const phoneRegex = /^\+?[\d\s\-\(\)]{10,}$/;
                if (!phoneRegex.test(value)) {
                    field.classList.add('is-invalid');
                    feedback.textContent = 'Please enter a valid phone number.';
                    return false;
                }
            }
            
            if (value) {
                field.classList.add('is-valid');
                feedback.textContent = '';
            }
            
            return true;
        }
        
        // Add event listeners for real-time validation
        document.querySelectorAll('.form-control').forEach(field => {
            field.addEventListener('blur', () => validateField(field));
            field.addEventListener('input', () => {
                if (field.classList.contains('is-invalid')) {
                    validateField(field);
                }
            });
        });
        
        // Form submission
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            let isValid = true;
            const requiredFields = form.querySelectorAll('[required]');
            
            requiredFields.forEach(field => {
                if (!validateField(field)) {
                    isValid = false;
                }
            });
            
            if (isValid) {
                loadingOverlay.classList.add('active');
                setTimeout(() => {
                    form.submit();
                }, 500);
            } else {
                // Scroll to first invalid field
                const firstInvalid = form.querySelector('.is-invalid');
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
            }
        });
        
        // Blood group quick select
        document.querySelectorAll('.blood-group-option').forEach(option => {
            option.addEventListener('click', function() {
                const bloodGroupInput = document.querySelector('input[name="bloodGroup"]');
                const selectedValue = this.dataset.value;
                
                // Remove selected class from all options
                document.querySelectorAll('.blood-group-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                
                // Add selected class to clicked option
                this.classList.add('selected');
                
                // Set the input value
                bloodGroupInput.value = selectedValue;
                
                // Add success styling
                bloodGroupInput.classList.remove('is-invalid');
                bloodGroupInput.classList.add('is-valid');
            });
        });
        
        // Set initial blood group selection
        const currentBloodGroup = '${patient.bloodType}';
        if (currentBloodGroup) {
            document.querySelectorAll('.blood-group-option').forEach(option => {
                if (option.dataset.value === currentBloodGroup) {
                    option.classList.add('selected');
                }
            });
        }
        
        // Progress step animation
        function updateProgressSteps() {
            const steps = document.querySelectorAll('.step');
            let currentStep = 0;
            
            const personalFields = form.querySelectorAll('input[name="firstName"], input[name="lastName"]');
            const contactFields = form.querySelectorAll('input[name="email"], input[name="phone"]');
            const medicalFields = form.querySelectorAll('input[name="bloodGroup"]');
            
            // Check personal details
            if (Array.from(personalFields).every(field => field.value.trim() !== '')) {
                currentStep = Math.max(currentStep, 1);
            }
            
            // Check contact info
            if (currentStep >= 1 && Array.from(contactFields).some(field => field.value.trim() !== '')) {
                currentStep = Math.max(currentStep, 2);
            }
            
            // Check medical info
            if (currentStep >= 2 && Array.from(medicalFields).some(field => field.value.trim() !== '')) {
                currentStep = Math.max(currentStep, 3);
            }
            
            steps.forEach((step, index) => {
                if (index < currentStep) {
                    step.classList.add('active');
                } else {
                    step.classList.remove('active');
                }
            });
        }
        
        // Update progress on input
        form.addEventListener('input', updateProgressSteps);
        
        // Initial progress update
        updateProgressSteps();
        
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert-custom');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                setTimeout(() => {
                    alert.remove();
                }, 300);
            });
        }, 5000);
        
        // Smooth scroll for invalid fields
        document.addEventListener('invalid', function(e) {
            e.target.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }, true);
        
        // Initialize tooltips if Bootstrap tooltips are available
        if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }
    </script>
</body>
</html>