
<!-- Body Content - DocAid Homepage -->
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
</style>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Medical and Health Centre Booking System</h1>
        <p class="lead">For all medical, health and wellness businesses</p>
        <div class="search-container">
            <form onsubmit="window.location.href='${pageContext.request.contextPath}/log.jsp?error=4'; return false;">
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
<section id="services" class="services">
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