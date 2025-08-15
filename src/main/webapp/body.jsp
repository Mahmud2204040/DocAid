

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DocAid Homepage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* Hero Section Styles */
        .hero {
            position: relative;
            height: 70vh;  /* Reduced from 100vh */
            min-height: 500px;  /* Reduced from 600px */
            background: url('${pageContext.request.contextPath}/images/hero_section.png') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .hero-overlay {
            position: absolute; inset:0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }
        .hero-content {
            position: relative; z-index: 2;
            max-width: 800px; padding: 2rem;
        }
        .hero h1 {
            font-size: 3.2rem; font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
            line-height: 1.2;
        }
        .hero .lead {
            font-size: 1.4rem; font-weight: 300;
            margin-bottom: 5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }
        .search-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 8px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 2rem;
            margin-top: 5rem;
        }
        .search-input-group {
            display: flex; align-items: center;
            border-radius: 50px; overflow: hidden;
        }
        .search-input {
            flex: 1; border: none;
            padding: 1rem 1.5rem;
            font-size: 1.1rem;
            outline: none; background: transparent; color: #333;
        }
        .search-input::placeholder {
            color: #666;
        }
        .search-btn {
            background: linear-gradient(135deg, #5aaaff 0%, #98c9ff 100%);
            border: none; padding: 1rem 2rem;
            border-radius: 50px; color: white;
            font-weight: 600; cursor: pointer;
            transition: all 0.3s ease; margin: 4px;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(90, 170, 255, 0.4);
        }
        .search-btn i { font-size: 1.2rem; }

        .hero .btn-primary {
            background: linear-gradient(135deg, #5aaaff 0%, #98c9ff 100%);
            border: none; padding: 1rem 2rem;
            border-radius: 50px; font-weight: 600;
            font-size: 1.1rem; transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(90, 170, 255, 0.3);
        }
        .hero .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(90, 170, 255, 0.4);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero { height: 60vh; min-height: 450px; }
            .hero h1 { font-size: 2.2rem; }
            .hero .lead { font-size: 1.1rem; }
            .search-container { margin: 0 1rem 2rem; }
            .search-input { padding: 0.8rem 1rem; font-size: 1rem; }
            .search-btn { padding: 0.8rem 1.5rem; }
        }
        @media (max-width: 576px) {
            .hero { height: 55vh; min-height: 400px; }
            .hero h1 { font-size: 1.8rem; }
            .hero .lead { font-size: 1rem; }
        }

        /* Services Section */
        .services {
            background: #f8fafc; padding: 5rem 0; text-align: center;
        }
        .services .card {
            border: none; border-radius: 15px; overflow: hidden;
            transition: all 0.3s ease; height: 100%;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .services .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .services .card-img-top {
            height: 200px; object-fit: cover;
        }
        .services .card-title {
            color: #0c264a; font-weight: 600;
        }

        /* Trusted Partners */
        .partners {
            padding: 5rem 0; background: white; text-align: center;
        }
        .partners img {
            max-height: 100px; filter: grayscale(100%);
            transition: filter 0.3s ease; margin: auto;
        }
        .partners img:hover {
            filter: grayscale(0%);
        }

        /* Testimonials */
        .testimonials {
            background: linear-gradient(135deg, #5aaaff 0%, #98c9ff 100%);
            color: white; padding: 5rem 0; text-align: center;
        }
        .testimonials .card {
            border: none; border-radius: 15px;
            background: rgba(255,255,255,0.95); backdrop-filter: blur(10px);
            transition: all 0.3s ease; height: 100%;
        }
        .testimonials .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        .testimonials .card-body {
            display: block;
        }
        /* Ensure testimonial text is visible */
        .testimonials .card-text,
        .testimonials .card-title,
        .testimonials .text-muted {
            color: #233b54 !important;
        }

        /* Footer Styles */
        .modern-footer {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: white; padding: 5rem 0 1rem;
        }
        .modern-footer .footer-logo {
            font-size: 2rem; font-weight: 800;
            color: #5aaaff; display: flex; align-items: center; gap: 0.5rem;
        }
        .modern-footer .logo-icon {
            font-size: 2.2rem; filter: drop-shadow(0 2px 4px rgba(90,170,255,0.3));
        }
        .modern-footer .footer-section h5 {
            color: white; font-weight: 600; margin-bottom: 1rem;
            position: relative; padding-bottom: 0.5rem;
        }
        .modern-footer .footer-section h5::after {
            content: ''; position: absolute; bottom: 0; left: 0;
            width: 30px; height: 2px; background: #5aaaff;
            border-radius: 1px;
        }
        .modern-footer .footer-links a {
            color: rgba(255,255,255,0.7); text-decoration: none;
            display: block; margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }
        .modern-footer .footer-links a:hover {
            color: #5aaaff; padding-left: 0.5rem; transform: translateX(5px);
        }
        .modern-footer .contact-item {
            color: rgba(255,255,255,0.7); display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;
        }
        .modern-footer .newsletter-text {
            color: rgba(255,255,255,0.8); font-size: 0.9rem; line-height: 1.5;
        }
        .modern-footer .newsletter-input {
            border: none; background: rgba(255,255,255,0.9);
            padding: 0.75rem 1rem; border-radius: 25px 0 0 25px;
            outline: none; font-size: 0.9rem;
        }
        .modern-footer .newsletter-btn {
            background: linear-gradient(135deg, #5aaaff 0%, #98c9ff 100%);
            border: none; color: white; padding: 0.75rem 1rem;
            border-radius: 0 25px 25px 0; transition: all 0.3s ease;
        }
        .modern-footer .newsletter-btn:hover {
            background: linear-gradient(135deg, #4891ff 0%, #7db8ff 100%);
            transform: translateY(-1px);
        }
        .modern-footer .social-links a {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white; position: relative; overflow: hidden;
            margin: 0.25rem; transition: all 0.3s ease;
        }
        .modern-footer .social-links a::before {
            content: ''; position: absolute; inset: 0; border-radius: 50%;
            transition: all 0.3s ease; z-index: 1;
        }
        .modern-footer .social-links a i { position: relative; z-index: 2; }
        .modern-footer .social-links .facebook::before { background: #3b5998; }
        .modern-footer .social-links .twitter::before { background: #1da1f2; }
        .modern-footer .social-links .linkedin::before { background: #0077b5; }
        .modern-footer .social-links .instagram::before { background: linear-gradient(45deg,#f09433,#e6683c,#dc2743,#cc2366,#bc1888); }
        .modern-footer .social-links .youtube::before { background: #ff0000; }
        .modern-footer .footer-bottom {
            background: rgba(0,0,0,0.2); border-top: 1px solid rgba(255,255,255,0.1);
            padding: 0.5rem 0; text-align: center;
        }
        .modern-footer .footer-bottom a {
            color: rgba(255,255,255,0.6); text-decoration: none; margin: 0 0.5rem;
            transition: color 0.3s ease;
        }
        .modern-footer .footer-bottom a:hover { color: #5aaaff; }
        .modern-footer .footer-bottom .separator {
            margin: 0 0.75rem; color: rgba(255,255,255,0.3);
        }

        /* Scroll to Top */
        .scroll-to-top {
            position: fixed; bottom: 2rem; right: 2rem;
            width: 50px; height: 50px; background: linear-gradient(135deg,#5aaaff 0%,#98c9ff 100%);
            color: white; border: none; border-radius: 50%; cursor: pointer;
            display: none; align-items: center; justify-content: center;
            transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(90,170,255,0.3);
            z-index: 1000;
        }
        .scroll-to-top.show { display: flex; }
        .scroll-to-top:hover {
            transform: translateY(-3px); box-shadow: 0 8px 25px rgba(90,170,255,0.4);
        }
    </style>
</head>
<body>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Medical and Health Centre Booking System</h1>
        <p class="lead">For all medical, health and wellness businesses</p>
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/PATIENT/search_page.jsp" method="get">
                <div class="search-input-group">
                    <input type="text" name="query" class="search-input"
                           placeholder="Search for doctors, specialties, conditions, procedures, or enter your location..."
                           aria-label="Search doctors and location" required>
                    <button class="search-btn" type="submit" aria-label="Search">
                        <i class="bi bi-search"></i> Find Care
                    </button>
                </div>
            </form>
        </div>

        
    </div>
</section>

<!-- Services Section -->
<section class="services">
    <div class="container">
        <h2 class="mb-5" style="color: #0c264a; font-weight: 700;">Our Services</h2>
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/consultation room.png" class="card-img-top" alt="Medical Clinics & Doctors">
                    <div class="card-body">
                        <h5 class="card-title">Medical Clinics & Doctors</h5>
                        <p class="card-text text-muted">Find qualified general practitioners and medical specialists</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/Modern dental office.png" class="card-img-top" alt="Dentists">
                    <div class="card-body">
                        <h5 class="card-title">Dentists</h5>
                        <p class="card-text text-muted">Professional dental care and oral health services</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/Chiropractic treatment.png" class="card-img-top" alt="Chiropractics">
                    <div class="card-body">
                        <h5 class="card-title">Chiropractics</h5>
                        <p class="card-text text-muted">Spinal health and musculoskeletal treatment</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/Serene acupuncture treatment room.png" class="card-img-top" alt="Acupuncture">
                    <div class="card-body">
                        <h5 class="card-title">Acupuncture</h5>
                        <p class="card-text text-muted">Traditional Chinese medicine and pain relief</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/therapy room.png" class="card-img-top" alt="Massage">
                    <div class="card-body">
                        <h5 class="card-title">Cardiology</h5>
                        <p class="card-text text-muted">Comprehensive heart care</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <img src="${pageContext.request.contextPath}/images/Professional psychology counseling office.png" class="card-img-top" alt="Psychologists">
                    <div class="card-body">
                        <h5 class="card-title">Psychologists</h5>
                        <p class="card-text text-muted">Mental health support and counseling services</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Trusted Partners Section -->
<section class="partners">
    <div class="container">
        <h2 class="mb-5" style="color: #0c264a; font-weight: 700;">Trusted Partners</h2>
        <div class="row">
            <div class="col-md-3 col-6 mb-4">
                <img src="${pageContext.request.contextPath}/images/Healthcare technology_trusted_partner.png" alt="Partner 1" class="img-fluid">
            </div>
            <div class="col-md-3 col-6 mb-4">
                <img src="${pageContext.request.contextPath}/images/Medical research institute_partner.png" alt="Partner 2" class="img-fluid">
            </div>
            <div class="col-md-3 col-6 mb-4">
                <img src="${pageContext.request.contextPath}/images/Pharmaceutical company partner.png" alt="Partner 3" class="img-fluid">
            </div>
            <div class="col-md-3 col-6 mb-4">
                <img src="${pageContext.request.contextPath}/images/Hospital network partner.png" alt="Partner 4" class="img-fluid">
            </div>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials">
    <div class="container">
        <h2 class="mb-5" style="font-weight: 700;">What Our Users Say</h2>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <img src="${pageContext.request.contextPath}/images/patient.png" alt="Aisha Rahman" class="rounded-circle mb-3" style="width: 80px; height: 80px; object-fit: cover;">
                        <p class="card-text">"DocAid made booking my appointments so easy!"</p>
                        <h6 class="card-title">Aisha Rahman</h6>
                        <p class="text-muted">Patient</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <img src="${pageContext.request.contextPath}/images/doctor.png" alt="Dr. Ahmed Hassan" class="rounded-circle mb-3" style="width: 80px; height: 80px; object-fit: cover;">
                        <p class="card-text">"A reliable and user-friendly platform."</p>
                        <h6 class="card-title">Dr. Ahmed Hassan</h6>
                        <p class="text-muted">Doctor</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <img src="${pageContext.request.contextPath}/images/clinic manager.png" alt="Fatima Al-Zahra" class="rounded-circle mb-3" style="width: 80px; height: 80px; object-fit: cover;">
                        <p class="card-text">"Highly recommend for healthcare providers."</p>
                        <h6 class="card-title">Fatima Al-Zahra</h6>
                        <p class="text-muted">Clinic Manager</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Modern Footer -->
<footer class="modern-footer">
    <div class="container">
        <div class="row">
            <!-- Company Info -->
            <div class="col-lg-4 col-md-6 mb-4 footer-section">
                <h3 class="footer-logo"><img src="${pageContext.request.contextPath}/images/logo.png" alt="DocAid Logo" style="height: 40px;"/> DocAid</h3>
                <p class="footer-description">
                    Your trusted healthcare booking platform connecting patients with qualified medical professionals.
                </p>
                <div class="contact-item"><i class="bi bi-geo-alt-fill"></i> 123 Healthcare Ave, Dhaka 1000</div>
                <div class="contact-item"><i class="bi bi-telephone-fill"></i> +880 1700-000000</div>
                <div class="contact-item"><i class="bi bi-envelope-fill"></i> support@docaid.com</div>
            </div>
            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">Quick Links</h5>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/services.jsp">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/doctors.jsp">Find Doctors</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq.jsp">FAQ</a></li>
                </ul>
            </div>
            <!-- For Patients -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">For Patients</h5>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/PATIENT/search_page.jsp">Search Doctors</a></li>
                    <li><a href="${pageContext.request.contextPath}/sign_up.jsp">Create Account</a></li>
                    <li><a href="${pageContext.request.contextPath}/PATIENT/dashboard.jsp">My Appointments</a></li>
                    <li><a href="${pageContext.request.contextPath}/PATIENT/profile.jsp">My Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/PATIENT/medical_records.jsp">Medical Records</a></li>
                    <li><a href="${pageContext.request.contextPath}/support.jsp">Support</a></li>
                </ul>
            </div>
            <!-- For Providers -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">For Providers</h5>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/DOCTOR/register.jsp">Join as Doctor</a></li>
                    <li><a href="${pageContext.request.contextPath}/DOCTOR/dashboard.jsp">Doctor Portal</a></li>
                    <li><a href="${pageContext.request.contextPath}/CLINIC/register.jsp">List Your Clinic</a></li>
                    <li><a href="${pageContext.request.contextPath}/pricing.jsp">Pricing Plans</a></li>
                    <li><a href="${pageContext.request.contextPath}/resources.jsp">Resources</a></li>
                    <li><a href="${pageContext.request.contextPath}/provider_support.jsp">Provider Support</a></li>
                </ul>
            </div>
            <!-- Stay Connected -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">Stay Connected</h5>
                <p class="newsletter-text">Subscribe for health tips & updates</p>
                <form class="newsletter-form" action="${pageContext.request.contextPath}/newsletter" method="post">
                    <div class="input-group mb-3">
                        <input type="email" name="email" class="newsletter-input" placeholder="Your email address" required>
                        <button class="newsletter-btn" type="submit"><i class="bi bi-paper-plane-fill"></i></button>
                    </div>
                </form>
                <div class="social-links">
                    <a href="#" class="social-link facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-link twitter"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="social-link linkedin"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="social-link instagram"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-link youtube"><i class="bi bi-youtube"></i></a>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2024 DocAid. All rights reserved. | Designed by Group H</p>
        <p>
            <a href="${pageContext.request.contextPath}/privacy-policy.jsp">Privacy Policy</a>
            <span class="separator">|</span>
            <a href="${pageContext.request.contextPath}/terms-of-service.jsp">Terms of Service</a>
            <span class="separator">|</span>
            <a href="${pageContext.request.contextPath}/cookie-policy.jsp">Cookie Policy</a>
        </p>
    </div>
</footer>

<!-- Scroll to Top Button -->
<button class="scroll-to-top" id="scrollToTop" onclick="scrollToTop()" aria-label="Scroll to top">
    <i class="bi bi-chevron-up"></i>
</button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Scroll to Top
    window.addEventListener('scroll', function() {
        const btn = document.getElementById('scrollToTop');
        if (window.pageYOffset > 300) btn.classList.add('show');
        else btn.classList.remove('show');
    });
    function scrollToTop() {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Newsletter Form
    document.querySelector('.newsletter-form').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Thank you for subscribing!');
        this.reset();
    });
</script>
</body>
</html>
