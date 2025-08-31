
<!-- Modern Footer Section -->
<style>
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

<!-- Modern Footer -->
<footer id="contact" class="modern-footer">
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
                    <li><a href="#">Home</a></li>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Services</a></li>
                    <li><a href="#">Find Doctors</a></li>
                    <li><a href="#">Contact</a></li>
                    <li><a href="#">FAQ</a></li>
                </ul>
            </div>
            <!-- For Patients -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">For Patients</h5>
                <ul class="footer-links">
                    <li><a href="#">Search Doctors</a></li>
                    <li><a href="#">Create Account</a></li>
                    <li><a href="#">My Appointments</a></li>
                    <li><a href="#">My Profile</a></li>
                    <li><a href="#">Medical Records</a></li>
                    <li><a href="#">Support</a></li>
                </ul>
            </div>
            <!-- For Providers -->
            <div class="col-lg-2 col-md-6 mb-4 footer-section">
                <h5 class="footer-title">For Providers</h5>
                <ul class="footer-links">
                    <li><a href="#">Join as Doctor</a></li>
                    <li><a href="#">Doctor Portal</a></li>
                    <li><a href="#">List Your Clinic</a></li>
                    <li><a href="#">Pricing Plans</a></li>
                    <li><a href="#">Resources</a></li>
                    <li><a href="#">Provider Support</a></li>
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
        <p>© 2025 DocAid. All rights reserved. | Designed by Mahmudul Hasan</p>
        <p>
            <a href="#">Privacy Policy</a>
            <span class="separator">|</span>
            <a href="#">Terms of Service</a>
            <span class="separator">|</span>
            <a href="#">Cookie Policy</a>
        </p>
    </div>
</footer>
<!-- Scroll to Top Button -->
<button class="scroll-to-top" id="scrollToTop" onclick="scrollToTop()" aria-label="Scroll to top">
    <i class="bi bi-chevron-up"></i>
</button>

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