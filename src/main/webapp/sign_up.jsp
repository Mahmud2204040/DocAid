<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>DocAid - Sign Up</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />

    <style>
        /* Main container styling */
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        /* Left side - Image/Illustration */
        .image-section {
            background: linear-gradient(rgba(102, 126, 234, 0.8), rgba(118, 75, 162, 0.8)), 
                        url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" style="stop-color:%23667eea;stop-opacity:1" /><stop offset="100%" style="stop-color:%23764ba2;stop-opacity:1" /></linearGradient></defs><rect width="1000" height="1000" fill="url(%23grad)"/></svg>');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .healthcare-illustration {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
            max-width: 80%;
        }

        .healthcare-icon {
            font-size: 8rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .healthcare-illustration h1 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .healthcare-illustration p {
            font-size: 1.2rem;
            opacity: 0.9;
            line-height: 1.6;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }

        /* Floating elements for visual appeal */
        .floating-element {
            position: absolute;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        .floating-element:nth-child(1) {
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }

        .floating-element:nth-child(2) {
            top: 20%;
            right: 15%;
            animation-delay: 2s;
        }

        .floating-element:nth-child(3) {
            bottom: 30%;
            left: 20%;
            animation-delay: 4s;
        }

        .floating-element:nth-child(4) {
            bottom: 20%;
            right: 10%;
            animation-delay: 1s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        /* Right side - Form */
        .form-section {
            background: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 2rem;
        }

        .form-container {
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-header h2 {
            color: #333;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: #666;
            font-size: 1.1rem;
        }

        /* Form styling */
        .form-control, .form-select {
            border: 2px solid #e1e5e9;
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            background: white;
        }

        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 0.5rem;
        }

        .form-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }

        /* Button styling */
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 0.75rem;
            padding: 0.875rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }

        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 0.5rem;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        /* Role-specific sections */
        .toggle-section {
            margin-top: 1.5rem;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 1rem;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .toggle-section.show {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
        }

        /* Alert styling */
        .alert {
            border-radius: 0.75rem;
            border: none;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
        }

        /* Links */
        a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        a:hover {
            color: #5a6fd8;
            text-decoration: underline;
        }

        /* Responsive design */
        @media (max-width: 991.98px) {
            .image-section {
                min-height: 40vh;
                order: 2;
            }
            
            .form-section {
                min-height: auto;
                order: 1;
            }
            
            .healthcare-illustration h1 {
                font-size: 2rem;
            }
            
            .healthcare-icon {
                font-size: 4rem;
            }
            
            .form-header h2 {
                font-size: 2rem;
            }
        }

        @media (max-width: 576px) {
            .form-section {
                padding: 1rem;
            }
            
            .healthcare-illustration {
                max-width: 90%;
            }
            
            .healthcare-illustration h1 {
                font-size: 1.5rem;
            }
            
            .healthcare-icon {
                font-size: 3rem;
            }
        }

        /* Footer */
        .footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 1rem 0;
            margin-top: auto;
        }

        .footer p {
            margin: 0;
            font-size: 0.9rem;
        }

        /* Custom scrollbar */
        .form-section::-webkit-scrollbar {
            width: 6px;
        }

        .form-section::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .form-section::-webkit-scrollbar-thumb {
            background: #667eea;
            border-radius: 3px;
        }

        .form-section::-webkit-scrollbar-thumb:hover {
            background: #5a6fd8;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0 main-container">
            <!-- Left Side - Healthcare Illustration -->
            <div class="col-lg-6 image-section">
                <!-- Floating decorative elements -->
                <div class="floating-element">
                    <i class="fas fa-heartbeat" style="font-size: 3rem;"></i>
                </div>
                <div class="floating-element">
                    <i class="fas fa-stethoscope" style="font-size: 2.5rem;"></i>
                </div>
                <div class="floating-element">
                    <i class="fas fa-user-md" style="font-size: 3.5rem;"></i>
                </div>
                <div class="floating-element">
                    <i class="fas fa-hospital" style="font-size: 2rem;"></i>
                </div>

                <div class="healthcare-illustration">
                    <div class="healthcare-icon">
                        <i class="fas fa-hand-holding-heart"></i>
                    </div>
                    <h1>Welcome to DocAid</h1>
                    <p>Your trusted healthcare companion. Connect with qualified doctors, book appointments, and manage your health journey with ease.</p>
                    <div class="mt-4">
                        <i class="fas fa-shield-alt me-3" style="font-size: 1.5rem;"></i>
                        <i class="fas fa-clock me-3" style="font-size: 1.5rem;"></i>
                        <i class="fas fa-users" style="font-size: 1.5rem;"></i>
                    </div>
                </div>
            </div>

            <!-- Right Side - Sign Up Form -->
            <div class="col-lg-6 form-section">
                <div class="form-container">
                    <div class="form-header">
                        <h2><i class="fas fa-user-plus me-2"></i>Sign Up</h2>
                        <p>Join our healthcare community today</p>
                    </div>

                    <%-- Display Success/Error Messages --%>
                    <% 
                        String status = request.getParameter("status");
                        String message = request.getParameter("message");
                        if (status != null) {
                            if ("success".equals(status)) {
                                out.println("<div class='alert alert-success'><i class='fas fa-check-circle me-2'></i>Registration successful! You can now <a href='login.jsp'>log in</a>.</div>");
                            } else if ("error".equals(status)) {
                                out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-circle me-2'></i><strong>Error:</strong> " + (message != null ? message : "An unknown error occurred.") + "</div>");
                            }
                        }
                    %>

                    <%
                    if (request.getParameter("s") != null) {
                        if (request.getParameter("s").equals("1")) {
                            out.println("<div class='alert alert-success'><i class='fas fa-check-circle me-2'></i>You have successfully registered with DocAid.</div>");
                        } else {
                            String error = request.getParameter("error");
                            message = "<div class='alert alert-danger'><i class='fas fa-exclamation-circle me-2'></i>";
                           
                            if ("missing_doctor_fields".equals(error)) {
                                message += "Please fill in all doctor-specific fields.";
                            } else if ("invalid_department".equals(error)) {
                                message += "Invalid Department/Hospital ID. Please enter a valid ID.";
                            } else if ("duplicate_entry".equals(error)) {
                                message += "Email or License Number already exists. Please use different values.";
                            } else if ("incomplete_data".equals(error)) {
                                message += "Please fill in all required fields.";
                            } else {
                                message += "An error occurred. Please try registering again.";
                            }
                           
                            message += "</div>";
                            out.println(message);
                        }
                    }
                    %>

                    <form id="signupForm" action="signup" method="post" novalidate>
                        <!-- Email -->
                        <div class="mb-3">
                            <label for="emailInput" class="form-label">
                                <i class="fas fa-envelope me-2"></i>Email Address
                            </label>
                            <input
                                type="email"
                                id="emailInput"
                                name="email"
                                class="form-control"
                                placeholder="Enter your email address"
                                required
                            />
                            <div class="form-text">Must be a @gmail.com address</div>
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">
                                <i class="fas fa-lock me-2"></i>Password
                            </label>
                            <input
                                type="password"
                                id="passwordInput"
                                name="password"
                                class="form-control"
                                placeholder="Create a secure password"
                                required
                                minlength="6"
                            />
                            <div class="form-text">Minimum 6 characters or numbers</div>
                        </div>

                        <!-- Role Dropdown -->
                        <div class="mb-3">
                            <label for="roleSelect" class="form-label">
                                <i class="fas fa-user-tag me-2"></i>Select Your Role
                            </label>
                            <select
                                id="roleSelect"
                                name="user_type"
                                class="form-select"
                                required
                                onchange="toggleFields()"
                            >
                                <option value="">-- Choose your role --</option>
                                <option value="Patient">Patient</option>
                                <option value="Doctor">Doctor</option>
                                <option value="Hospital">Hospital</option>
                            </select>
                        </div>

                        <!-- Patient Fields -->
                        <div id="patientFields" class="toggle-section" style="display: none;">
                            <h5 class="mb-3"><i class="fas fa-user me-2"></i>Patient Information</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <input
                                            type="text"
                                            id="patientFirstName"
                                            name="patient_first_name"
                                            class="form-control"
                                            placeholder="First Name"
                                            maxlength="100"
                                        />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <input
                                            type="text"
                                            id="patientLastName"
                                            name="patient_last_name"
                                            class="form-control"
                                            placeholder="Last Name"
                                            maxlength="100"
                                        />
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="patientPrimaryContact" class="form-label"><i class="fas fa-phone me-2"></i>Primary Contact</label>
                                <input type="tel" id="patientPrimaryContact" name="patient_primary_contact" class="form-control" placeholder="Enter your phone number">
                            </div>
                            <div class="mb-3">
                                <select
                                    id="patientGender"
                                    name="patient_gender"
                                    class="form-select"
                                >
                                    <option value="">-- Select Gender --</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="patientDOB" class="form-label">Date of Birth</label>
                                <input
                                    type="date"
                                    id="patientDOB"
                                    name="patient_dob"
                                    class="form-control"
                                />
                            </div>
                            <div class="mb-3">
                                <select
                                    id="bloodType"
                                    name="blood_type"
                                    class="form-select"
                                >
                                    <option value="">-- Select Blood Type (Optional) --</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="patientAddress" class="form-label">Address</label>
                                <textarea
                                    id="patientAddress"
                                    name="patient_address"
                                    class="form-control"
                                    placeholder="Enter your address"
                                    rows="3"
                                ></textarea>
                                <input type="hidden" id="patientLatitude" name="patient_latitude" required>
                                <input type="hidden" id="patientLongitude" name="patient_longitude" required>
                                <button type="button" class="btn btn-secondary mt-2" onclick="getLocation('patient')">
                                    <i class="fas fa-map-marker-alt me-2"></i>Get My Location
                                </button>
                            </div>
                        </div>

                        <!-- Doctor Fields -->
                        <div id="doctorFields" class="toggle-section" style="display: none;">
                            <h5 class="mb-3"><i class="fas fa-user-md me-2"></i>Doctor Information</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <input
                                            type="text"
                                            id="doctorFirstName"
                                            name="doctor_first_name"
                                            class="form-control"
                                            placeholder="First Name"
                                            maxlength="100"
                                        />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <input
                                            type="text"
                                            id="doctorLastName"
                                            name="doctor_last_name"
                                            class="form-control"
                                            placeholder="Last Name"
                                            maxlength="100"
                                        />
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="doctorPrimaryContact" class="form-label"><i class="fas fa-phone me-2"></i>Primary Contact</label>
                                        <input type="tel" id="doctorPrimaryContact" name="doctor_primary_contact" class="form-control" placeholder="For hospital use">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="doctorAppointmentContact" class="form-label"><i class="fas fa-calendar-check me-2"></i>Appointment Contact</label>
                                        <input type="tel" id="doctorAppointmentContact" name="doctor_appointment_contact" class="form-control" placeholder="For patient use">
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <select
                                    id="doctorGender"
                                    name="doctor_gender"
                                    class="form-select"
                                >
                                    <option value="">-- Select Gender --</option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <input
                                    type="text"
                                    id="licenseNumber"
                                    name="license_number"
                                    class="form-control"
                                    placeholder="Medical License Number"
                                    maxlength="50"
                                />
                            </div>
                            
                            <!-- Medical Specialty Dropdown -->
                            <div class="mb-3">
                                <select
                                    id="specialtySelect"
                                    name="specialty_name"
                                    class="form-select"
                                >
                                    <option value="">-- Select Medical Specialty --</option>
                                    <c:forEach var="specialty" items="${specialties}">
                                        <option value="${specialty.name}">${specialty.name}</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Select your medical specialty</div>
                            </div>
                            
                            <div class="mb-3">
                                <input
                                    type="number"
                                    id="expYears"
                                    name="exp_years"
                                    class="form-control"
                                    placeholder="Years of Experience"
                                    min="0"
                                />
                            </div>
                            <div class="mb-3">
                                <input
                                    type="number"
                                    id="fee"
                                    name="fee"
                                    class="form-control"
                                    placeholder="Consultation Fee"
                                    min="0"
                                    step="0.01"
                                />
                            </div>
                            <div class="mb-3">
                                <textarea
                                    id="bio"
                                    name="bio"
                                    class="form-control"
                                    placeholder="Professional Bio (Optional)"
                                    rows="3"
                                ></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="doctorAddress" class="form-label">Practice Address</label>
                                <textarea
                                    id="doctorAddress"
                                    name="doctor_address"
                                    class="form-control"
                                    placeholder="Enter your practice address"
                                    rows="3"
                                ></textarea>
                                <input type="hidden" id="doctorLatitude" name="doctor_latitude" required>
                                <input type="hidden" id="doctorLongitude" name="doctor_longitude" required>
                                <button type="button" class="btn btn-secondary mt-2" onclick="getLocation('doctor')">
                                    <i class="fas fa-map-marker-alt me-2"></i>Get My Location
                                </button>
                            </div>
                        </div>

                        <!-- Hospital Fields -->
                        <div id="hospitalFields" class="toggle-section" style="display: none;">
                            <h5 class="mb-3"><i class="fas fa-hospital me-2"></i>Hospital Information</h5>
                            <div class="mb-3">
                                <input
                                    type="text"
                                    id="hospitalName"
                                    name="hospital_name"
                                    class="form-control"
                                    placeholder="Hospital Name"
                                    maxlength="255"
                                />
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="hospitalPrimaryContact" class="form-label"><i class="fas fa-phone me-2"></i>Primary Contact</label>
                                        <input type="tel" id="hospitalPrimaryContact" name="hospital_primary_contact" class="form-control" placeholder="Main contact number">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="hospitalEmergencyContact" class="form-label"><i class="fas fa-ambulance me-2"></i>Emergency Contact</label>
                                        <input type="tel" id="hospitalEmergencyContact" name="hospital_emergency_contact" class="form-control" placeholder="For emergencies">
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <input
                                    type="url"
                                    id="website"
                                    name="website"
                                    class="form-control"
                                    placeholder="Website URL (Optional)"
                                    maxlength="255"
                                />
                            </div>
                            <div class="mb-3">
                                <textarea
                                    id="hospitalBio"
                                    name="hospital_bio"
                                    class="form-control"
                                    placeholder="Hospital Description (Optional)"
                                    rows="3"
                                ></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="hospitalAddress" class="form-label">Hospital Address</label>
                                <textarea
                                    id="hospitalAddress"
                                    name="hospital_address"
                                    class="form-control"
                                    placeholder="Enter hospital address"
                                    rows="3"
                                ></textarea>
                                <input type="hidden" id="hospitalLatitude" name="hospital_latitude" required>
                                <input type="hidden" id="hospitalLongitude" name="hospital_longitude" required>
                                <button type="button" class="btn btn-secondary mt-2" onclick="getLocation('hospital')">
                                    <i class="fas fa-map-marker-alt me-2"></i>Get My Location
                                </button>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-user-plus me-2"></i>Create Account
                            </button>
                        </div>

                        <div class="text-center mt-3">
                            <p class="mb-0">
                                Already have an account? <a href="log.jsp">Sign in here</a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 DocAid. All rights reserved.</p>
            <p>Designed by Group H</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function getLocation(rolePrefix) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        document.getElementById(rolePrefix + 'Latitude').value = position.coords.latitude;
                        document.getElementById(rolePrefix + 'Longitude').value = position.coords.longitude;
                        alert('Location captured successfully!');
                    },
                    () => {
                        alert('Unable to retrieve your location. Please enter your address manually.');
                    }
                );
            } else {
                alert('Geolocation is not supported by this browser.');
            }
        }

        function toggleFields() {
            const roleSelect = document.getElementById('roleSelect');
            const patientFields = document.getElementById('patientFields');
            const doctorFields = document.getElementById('doctorFields');
            const hospitalFields = document.getElementById('hospitalFields');

            // Hide all fields first and remove show class
            [patientFields, doctorFields, hospitalFields].forEach(field => {
                field.style.display = 'none';
                field.classList.remove('show');
            });

            // Clear all field requirements and values
            clearFieldRequirements(patientFields);
            clearFieldRequirements(doctorFields);
            clearFieldRequirements(hospitalFields);

            // Show relevant fields based on selection
            if (roleSelect.value === 'Patient') {
                patientFields.style.display = 'block';
                patientFields.classList.add('show');
                setRequiredFields(patientFields, ['patient_first_name', 'patient_last_name', 'patient_gender', 'patient_dob', 'patient_address', 'patient_latitude', 'patient_longitude']);
            } else if (roleSelect.value === 'Doctor') {
                doctorFields.style.display = 'block';
                doctorFields.classList.add('show');
                setRequiredFields(doctorFields, ['doctor_first_name', 'doctor_last_name', 'doctor_gender', 'license_number', 'exp_years', 'fee', 'doctor_address', 'doctor_latitude', 'doctor_longitude']);
            } else if (roleSelect.value === 'Hospital') {
                hospitalFields.style.display = 'block';
                hospitalFields.classList.add('show');
                setRequiredFields(hospitalFields, ['hospital_name', 'hospital_address', 'hospital_latitude', 'hospital_longitude']);
            }
        }

        function clearFieldRequirements(container) {
            const inputs = container.querySelectorAll('input, select, textarea');
            inputs.forEach(input => {
                input.required = false;
                input.value = '';
            });
        }

        function setRequiredFields(container, requiredNames) {
            requiredNames.forEach(name => {
                const field = container.querySelector(`[name="${name}"]`);
                if (field) {
                    field.required = true;
                }
            });
        }

        // Form validation before submission
        document.getElementById('signupForm').addEventListener('submit', function(e) {
            // Email validation
            const emailInput = document.getElementById('emailInput');
            const email = emailInput.value.trim();
            if (!email.endsWith('@gmail.com')) {
                e.preventDefault();
                alert('Please enter a valid @gmail.com email address.');
                return;
            }

            // Password validation
            const passwordInput = document.getElementById('passwordInput');
            const password = passwordInput.value.trim();
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return;
            }

            // Phone number validation
            const phoneInput = document.getElementById('phoneInput');
            const phone = phoneInput.value.trim();
            if (!/^\d{11}$/.test(phone)) {
                e.preventDefault();
                alert('Phone number must be exactly 11 digits.');
                return;
            }

            const roleSelect = document.getElementById('roleSelect');
            const role = roleSelect.value;
            
            if (!role) {
                e.preventDefault();
                alert('Please select a role.');
                return;
            }

            let latField, lonField, addressField;
            if (role === 'Patient') {
                latField = document.getElementById('patientLatitude');
                lonField = document.getElementById('patientLongitude');
                addressField = document.getElementById('patientAddress');
            } else if (role === 'Doctor') {
                latField = document.getElementById('doctorLatitude');
                lonField = document.getElementById('doctorLongitude');
                addressField = document.getElementById('doctorAddress');
            } else if (role === 'Hospital') {
                latField = document.getElementById('hospitalLatitude');
                lonField = document.getElementById('hospitalLongitude');
                addressField = document.getElementById('hospitalAddress');
            }

            if (addressField && !addressField.value.trim()) {
                e.preventDefault();
                alert('Please input address');
                return;
            }

            if (latField && lonField) {
                if (!latField.value || !lonField.value) {
                    e.preventDefault();
                    alert('Please input a valid location using Get Location button.');
                    return;
                }
            }

            // Additional validation for specific roles
            if (role === 'Doctor') {
                const licenseNumber = document.getElementById('licenseNumber').value.trim();
                const expYears = document.getElementById('expYears').value.trim();
                const fee = document.getElementById('fee').value.trim();
                
                if (!licenseNumber || !expYears || !fee) {
                    e.preventDefault();
                    alert('Please fill in all required doctor fields (License Number, Experience Years, Fee).');
                    return;
                }
            }
        });

        // Call once on page load in case of page refresh
        window.onload = toggleFields;
    </script>
</body>
</html>
