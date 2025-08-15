<%-- 
    Document   : sign_up.jsp
    Created on : Aug 7, 2024, 8:44:21 PM
    Author     : User
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
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
        .cascading-right {
            margin-right: -50px;
        }
        @media (max-width: 991.98px) {
            .cascading-right {
                margin-right: 0;
            }
        }
        .form-outline {
            margin-bottom: 1rem;
        }
        .btn-block {
            width: 100%;
        }
    </style>
</head>
<body>
<section class="text-center text-lg-start">
    <div class="container py-4">
        <nav class="navbar navbar-expand-lg navbar-light bg-white">
            <!-- Add navigation content here if needed -->
        </nav>

        <div class="row g-0 align-items-center">
            <div class="col-lg-6 mb-5 mb-lg-0">
                <div
                    class="card cascading-right"
                    style="background: hsla(0, 0%, 100%, 0.55); backdrop-filter: blur(30px);"
                >
                    <div class="card-body p-5 shadow-5 text-center">
                        <h2 class="fw-bold mb-5">Sign Up</h2>

                        <%-- Display Success/Error Messages --%>
                        <% 
                            String status = request.getParameter("status");
                            String message = request.getParameter("message");
                            if (status != null) {
                                if ("success".equals(status)) {
                                    out.println("<div class='alert alert-success'>Registration successful! You can now <a href='login.jsp'>log in</a>.</div>");
                                } else if ("error".equals(status)) {
                                    out.println("<div class='alert alert-danger'><strong>Error:</strong> " + (message != null ? message : "An unknown error occurred.") + "</div>");
                                }
                            }
                        %>

                        <%
                        if (request.getParameter("s") != null) {
                            if (request.getParameter("s").equals("1")) {
                                out.println("<h6 class='text-success'>You have successfully registered with DocAid.</h6>");
                            } else {
                                String error = request.getParameter("error");
                                message = "<h6 class='text-danger'>";
                               
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
                               
                                message += "</h6>";
                                out.println(message);
                            }
                        }
                        %>

                        <form id="signupForm" action="processSignup.jsp" method="post" novalidate>
                            <!-- Email -->
                            <div class="form-outline mb-4">
                                <input
                                    type="email"
                                    id="emailInput"
                                    name="email"
                                    class="form-control"
                                    placeholder="Email address"
                                    required
                                />
                            </div>

                            <!-- Password -->
                            <div class="form-outline mb-4">
                                <input
                                    type="password"
                                    id="passwordInput"
                                    name="password"
                                    class="form-control"
                                    placeholder="Password"
                                    required
                                    minlength="6"
                                />
                            </div>

                            <!-- Phone Number -->
                            <div class="form-outline mb-4">
                                <input
                                    type="tel"
                                    id="phoneInput"
                                    name="contact_no"
                                    class="form-control"
                                    placeholder="Phone Number"
                                    required
                                    pattern="[0-9]+"
                                />
                            </div>

                            <!-- Role Dropdown -->
                            <div class="form-outline mb-4">
                                <select
                                    id="roleSelect"
                                    name="user_type"
                                    class="form-control"
                                    required
                                    onchange="toggleFields()"
                                >
                                    <option value="">-- Select Role --</option>
                                    <option value="Patient">Patient</option>
                                    <option value="Doctor">Doctor</option>
                                    <option value="Hospital">Hospital</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>

                            <!-- Patient Fields -->
                            <div id="patientFields" style="display: none;">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-outline mb-4">
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
                                        <div class="form-outline mb-4">
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
                                <div class="form-outline mb-4">
                                    <select
                                        id="patientGender"
                                        name="patient_gender"
                                        class="form-control"
                                    >
                                        <option value="">-- Select Gender --</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="form-outline mb-4">
                                    <input
                                        type="date"
                                        id="patientDOB"
                                        name="patient_dob"
                                        class="form-control"
                                        placeholder="Date of Birth"
                                    />
                                </div>
                                <div class="form-outline mb-4">
                                    <select
                                        id="bloodType"
                                        name="blood_type"
                                        class="form-control"
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
                                <div class="form-outline mb-4">
                                    <textarea
                                        id="patientAddress"
                                        name="patient_address"
                                        class="form-control"
                                        placeholder="Address"
                                        rows="3"
                                    ></textarea>
                                </div>
                            </div>

                            <!-- Doctor Fields -->
                            <div id="doctorFields" style="display: none;">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-outline mb-4">
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
                                        <div class="form-outline mb-4">
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
                                <div class="form-outline mb-4">
                                    <select
                                        id="doctorGender"
                                        name="doctor_gender"
                                        class="form-control"
                                    >
                                        <option value="">-- Select Gender --</option>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="form-outline mb-4">
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
                                <div class="form-outline mb-4">
                                    <select
                                        id="specialtySelect"
                                        name="specialty_name"
                                        class="form-control"
                                    >
                                        <option value="">-- Select Medical Specialty --</option>
                                        <option value="Allergy and Immunology">Allergy and Immunology</option>
                                        <option value="Anesthesiology">Anesthesiology</option>
                                        <option value="Cardiology">Cardiology</option>
                                        <option value="Cardiovascular Surgery">Cardiovascular Surgery</option>
                                        <option value="Colon and Rectal Surgery">Colon and Rectal Surgery</option>
                                        <option value="Critical Care Medicine">Critical Care Medicine</option>
                                        <option value="Dermatology">Dermatology</option>
                                        <option value="Emergency Medicine">Emergency Medicine</option>
                                        <option value="Endocrinology">Endocrinology</option>
                                        <option value="Family Medicine">Family Medicine</option>
                                        <option value="Gastroenterology">Gastroenterology</option>
                                        <option value="General Surgery">General Surgery</option>
                                        <option value="Geriatrics">Geriatrics</option>
                                        <option value="Hematology">Hematology</option>
                                        <option value="Infectious Disease">Infectious Disease</option>
                                        <option value="Internal Medicine">Internal Medicine</option>
                                        <option value="Medical Genetics">Medical Genetics</option>
                                        <option value="Nephrology">Nephrology</option>
                                        <option value="Neurology">Neurology</option>
                                        <option value="Neurosurgery">Neurosurgery</option>
                                        <option value="Nuclear Medicine">Nuclear Medicine</option>
                                        <option value="Obstetrics and Gynecology">Obstetrics and Gynecology</option>
                                        <option value="Occupational Medicine">Occupational Medicine</option>
                                        <option value="Oncology">Oncology</option>
                                        <option value="Ophthalmology">Ophthalmology</option>
                                        <option value="Orthopedic Surgery">Orthopedic Surgery</option>
                                        <option value="Otolaryngology (ENT)">Otolaryngology (ENT)</option>
                                        <option value="Pathology">Pathology</option>
                                        <option value="Pediatrics">Pediatrics</option>
                                        <option value="Physical Medicine and Rehabilitation">Physical Medicine and Rehabilitation</option>
                                        <option value="Plastic Surgery">Plastic Surgery</option>
                                        <option value="Preventive Medicine">Preventive Medicine</option>
                                        <option value="Psychiatry">Psychiatry</option>
                                        <option value="Pulmonology">Pulmonology</option>
                                        <option value="Radiation Oncology">Radiation Oncology</option>
                                        <option value="Radiology">Radiology</option>
                                        <option value="Rheumatology">Rheumatology</option>
                                        <option value="Sports Medicine">Sports Medicine</option>
                                        <option value="Thoracic Surgery">Thoracic Surgery</option>
                                        <option value="Urology">Urology</option>
                                        <option value="Vascular Surgery">Vascular Surgery</option>
                                        <option value="Other">Other</option>
                                    </select>
                                    <small class="form-text text-muted">Select your medical specialty</small>
                                </div>
                                
                                <div class="form-outline mb-4">
                                    <input
                                        type="number"
                                        id="expYears"
                                        name="exp_years"
                                        class="form-control"
                                        placeholder="Years of Experience"
                                        min="0"
                                    />
                                </div>
                                <div class="form-outline mb-4">
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
                                <div class="form-outline mb-4">
                                    <textarea
                                        id="bio"
                                        name="bio"
                                        class="form-control"
                                        placeholder="Professional Bio (Optional)"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div class="form-outline mb-4">
                                    <textarea
                                        id="doctorAddress"
                                        name="doctor_address"
                                        class="form-control"
                                        placeholder="Practice Address"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div class="form-outline mb-4">
                                    <input
                                        type="number"
                                        id="hospitalId"
                                        name="hospital_id"
                                        class="form-control"
                                        placeholder="Hospital ID (Optional)"
                                    />
                                    <small class="form-text text-muted">Enter hospital ID if affiliated</small>
                                </div>
                            </div>

                            <!-- Hospital Fields -->
                            <div id="hospitalFields" style="display: none;">
                                <div class="form-outline mb-4">
                                    <input
                                        type="text"
                                        id="hospitalName"
                                        name="hospital_name"
                                        class="form-control"
                                        placeholder="Hospital Name"
                                        maxlength="255"
                                    />
                                </div>
                                <div class="form-outline mb-4">
                                    <textarea
                                        id="hospitalBio"
                                        name="hospital_bio"
                                        class="form-control"
                                        placeholder="Hospital Description (Optional)"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div class="form-outline mb-4">
                                    <textarea
                                        id="hospitalAddress"
                                        name="hospital_address"
                                        class="form-control"
                                        placeholder="Hospital Address"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div class="form-outline mb-4">
                                    <input
                                        type="url"
                                        id="website"
                                        name="website"
                                        class="form-control"
                                        placeholder="Website URL (Optional)"
                                        maxlength="255"
                                    />
                                </div>
                            </div>

                            <!-- Admin Fields -->
                            <div id="adminFields" style="display: none;">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-outline mb-4">
                                            <input
                                                type="text"
                                                id="adminFirstName"
                                                name="admin_first_name"
                                                class="form-control"
                                                placeholder="First Name"
                                                maxlength="100"
                                            />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-outline mb-4">
                                            <input
                                                type="text"
                                                id="adminLastName"
                                                name="admin_last_name"
                                                class="form-control"
                                                placeholder="Last Name"
                                                maxlength="100"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-block mb-4">
                                Sign Up
                            </button>

                            <div class="text-center">
                                <p>
                                    Already have an account? <a href="log.jsp">Sign in</a>
                                </p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 mb-5 mb-lg-0">
                <img
                    src="images/main-image.png"
                    class="w-100 d-none d-lg-block"
                    alt="Sign Up Image"
                />
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-light text-center py-4">
    <div class="container">
        <p class="mb-0">&copy; 2024 DocAid. All rights reserved.</p>
        <p>Designed by Group H</p>
    </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleFields() {
        const roleSelect = document.getElementById('roleSelect');
        const patientFields = document.getElementById('patientFields');
        const doctorFields = document.getElementById('doctorFields');
        const hospitalFields = document.getElementById('hospitalFields');
        const adminFields = document.getElementById('adminFields');

        // Hide all fields first
        patientFields.style.display = 'none';
        doctorFields.style.display = 'none';
        hospitalFields.style.display = 'none';
        adminFields.style.display = 'none';

        // Clear all field requirements and values
        clearFieldRequirements(patientFields);
        clearFieldRequirements(doctorFields);
        clearFieldRequirements(hospitalFields);
        clearFieldRequirements(adminFields);

        // Show relevant fields based on selection
        if (roleSelect.value === 'Patient') {
            patientFields.style.display = 'block';
            setRequiredFields(patientFields, ['patient_first_name', 'patient_last_name', 'patient_gender', 'patient_dob', 'patient_address']);
        } else if (roleSelect.value === 'Doctor') {
            doctorFields.style.display = 'block';
            setRequiredFields(doctorFields, ['doctor_first_name', 'doctor_last_name', 'doctor_gender', 'license_number', 'exp_years', 'fee', 'doctor_address']);
        } else if (roleSelect.value === 'Hospital') {
            hospitalFields.style.display = 'block';
            setRequiredFields(hospitalFields, ['hospital_name', 'hospital_address']);
        } else if (roleSelect.value === 'Admin') {
            adminFields.style.display = 'block';
            setRequiredFields(adminFields, ['admin_first_name', 'admin_last_name']);
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
        const roleSelect = document.getElementById('roleSelect');
        
        if (!roleSelect.value) {
            e.preventDefault();
            alert('Please select a role.');
            return false;
        }

        // Additional validation for specific roles
        if (roleSelect.value === 'Doctor') {
            const licenseNumber = document.getElementById('licenseNumber').value.trim();
            const expYears = document.getElementById('expYears').value.trim();
            const fee = document.getElementById('fee').value.trim();
            
            if (!licenseNumber || !expYears || !fee) {
                e.preventDefault();
                alert('Please fill in all required doctor fields (License Number, Experience Years, Fee).');
                return false;
            }
        }
    });

    // Call once on page load in case of page refresh
    window.onload = toggleFields;
</script>
</body>
</html>
