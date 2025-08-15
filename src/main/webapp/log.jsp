<%-- 
    Document   : log.jsp   (Login page / form)
    Created on : Aug 7 2024
    Updated on : Aug 11 2025  (Removed email validation + deeper-blue palette)
    Enhanced DocAid Login Experience
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>DocAid – Welcome Back | Secure Patient Portal</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />

    <style>
        :root{
            /* ——— S A T U R A T E D  B L U E  P A L E T T E ——— */
            --primary-gradient:  linear-gradient(135deg,#5aaaff 0%,#98c9ff 100%);
            --secondary-gradient:linear-gradient(135deg,#c8e1ff 0%,#eaf4ff 100%);
            --success-gradient:  linear-gradient(135deg,#55e3ff 0%,#a4f4ff 100%);
            --warning-gradient:  linear-gradient(135deg,#fff9e0 0%,#fff0b9 100%);
            --danger-gradient:   linear-gradient(135deg,#ffc7cf 0%,#ffe9ec 100%);
            --info-gradient:var(--primary-gradient);

            --bg-primary:#ebf5ff;
            --bg-secondary:#ffffff;
            --text-primary:#0c264a;
            --text-secondary:#415f7b;
            --text-muted:#68849b;
            --border-color:#b9d9f4;

            --shadow-light: 0 4px 6px -1px rgba(0,0,0,.05),
                            0 2px 4px -1px rgba(0,0,0,.03);
            --shadow-medium:0 10px 15px -3px rgba(0,0,0,.08),
                            0 4px 6px -2px rgba(0,0,0,.04);
            --shadow-heavy: 0 25px 50px -12px rgba(0,0,0,.15);

            --transition-fast:  all .2s ease-in-out;
            --transition-medium:all .3s cubic-bezier(.4,0,.2,1);
            --transition-slow:  all .5s cubic-bezier(.4,0,.2,1);
        }

        /* Reset & base */
        *{margin:0;padding:0;box-sizing:border-box;}
        body{
            font-family:'Inter',-apple-system,BlinkMacSystemFont,sans-serif;
            background:linear-gradient(135deg,#5aaaff 0%,#7dbcff 50%,#d3ebff 100%);
            min-height:100vh;display:flex;align-items:center;justify-content:center;position:relative;overflow-x:hidden;
        }

        /* Animated background */
        .bg-animation{position:fixed;inset:0;z-index:-1;overflow:hidden;}
        .floating-shapes{position:absolute;inset:0;}
        .shape{position:absolute;background:rgba(255,255,255,.1);border-radius:50%;animation:float 6s ease-in-out infinite;}
        .shape:nth-child(1){width:80px;height:80px;top:20%;left:10%;}
        .shape:nth-child(2){width:120px;height:120px;top:60%;right:15%;animation-delay:2s;}
        .shape:nth-child(3){width:60px;height:60px;bottom:20%;left:20%;animation-delay:4s;}
        .shape:nth-child(4){width:100px;height:100px;top:10%;right:25%;animation-delay:1s;}
        .shape:nth-child(5){width:90px;height:90px;bottom:30%;right:10%;animation-delay:3s;}

        /* Card */
        .login-container{width:100%;max-width:1200px;padding:2rem;}
        .login-card{background:rgba(255,255,255,.95);backdrop-filter:blur(20px);border-radius:24px;
                    box-shadow:var(--shadow-heavy);border:1px solid rgba(255,255,255,.2);overflow:hidden;position:relative;}
        .login-card::before{content:'';position:absolute;inset:0;height:4px;background:var(--primary-gradient);z-index:1;}

        /* Left panel */
        .form-panel{padding:3rem;}
        .brand-header{text-align:center;margin-bottom:2rem;}
        .brand-logo{width:80px;height:80px;background:var(--primary-gradient);border-radius:20px;
                    display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;
                    font-size:2rem;font-weight:700;color:#fff;box-shadow:var(--shadow-medium);position:relative;overflow:hidden;}
        .brand-logo::after{content:'';position:absolute;top:-50%;left:-50%;width:200%;height:200%;
                           background:linear-gradient(45deg,rgba(255,255,255,.1)0%,rgba(255,255,255,.3)50%,rgba(255,255,255,.1)100%);
                           transform:rotate(45deg)translate(-50%,-50%);animation:shine 3s ease-in-out infinite;}
        .brand-title{font-size:2.6rem;font-weight:800;background:var(--primary-gradient);
                     -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;margin-bottom:.4rem;}
        .brand-subtitle{color:var(--text-secondary);font-size:1.1rem;font-weight:500;margin-bottom:.4rem;}
        .welcome-text{color:var(--text-muted);font-size:.95rem;line-height:1.6;}

        /* Error */
        .error-alert{background:linear-gradient(135deg,rgba(239,68,68,.1)0%,rgba(220,38,38,.1)100%);
                     color:#7f1d1d;border:1px solid rgba(239,68,68,.2);border-radius:12px;padding:1rem;margin-bottom:1.5rem;
                     display:flex;align-items:center;gap:.75rem;animation:shake .5s ease-in-out;}
        .error-alert i{font-size:1.25rem;color:#ef4444;}

        /* Form */
        .form-section{margin-bottom:2rem;}
        .section-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin-bottom:1.5rem;position:relative;padding-left:1rem;}
        .section-title::before{content:'';position:absolute;left:0;top:50%;transform:translateY(-50%);
                               width:4px;height:24px;background:var(--primary-gradient);border-radius:2px;}

        .form-group{margin-bottom:1.5rem;position:relative;}
        .form-label{font-weight:600;color:var(--text-primary);margin-bottom:.75rem;display:flex;align-items:center;gap:.5rem;font-size:.95rem;}
        .form-label i{color:var(--text-muted);font-size:1rem;}
        .input-wrapper{position:relative;}
        .form-control{border:2px solid var(--border-color);border-radius:12px;padding:1rem 1rem 1rem 3rem;
                      font-size:1rem;font-weight:500;background:var(--bg-secondary);color:var(--text-primary);
                      transition:var(--transition-fast);}
        .form-control:focus{outline:none;border-color:#419aff;box-shadow:0 0 0 3px rgba(65,154,255,.15);transform:translateY(-2px);}
        .form-control:hover{border-color:#8ec1f2;transform:translateY(-1px);}
        .input-icon{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:var(--text-muted);
                    font-size:1.1rem;z-index:5;transition:var(--transition-fast);}
        .form-control:focus + .input-icon{color:#419aff;}

        /* Password toggle */
        .password-toggle{position:absolute;right:1rem;top:50%;transform:translateY(-50%);background:none;border:none;
                         color:var(--text-muted);cursor:pointer;padding:.5rem;border-radius:6px;transition:var(--transition-fast);}
        .password-toggle:hover{background:#e8f3ff;color:var(--text-primary);}

        /* Remember / forgot */
        .remember-section{display:flex;justify-content:space-between;align-items:center;margin:2rem 0;}
        .custom-checkbox{display:flex;align-items:center;gap:.75rem;cursor:pointer;}
        .custom-checkbox input{display:none;}
        .checkbox-indicator{width:20px;height:20px;border:2px solid var(--border-color);border-radius:4px;
                             display:flex;align-items:center;justify-content:center;background:var(--bg-secondary);
                             transition:var(--transition-fast);}
        .custom-checkbox input:checked + .checkbox-indicator{background:var(--primary-gradient);border-color:transparent;color:#fff;}
        .checkbox-indicator i{font-size:.75rem;opacity:0;transition:var(--transition-fast);}
        .custom-checkbox input:checked + .checkbox-indicator i{opacity:1;}

        .forgot-password{color:var(--text-secondary);font-weight:500;text-decoration:none;transition:var(--transition-fast);}
        .forgot-password:hover{color:#419aff;text-decoration:underline;}

        /* Button */
        .submit-btn{background:var(--primary-gradient);border:none;color:#fff;padding:1rem 2rem;border-radius:12px;font-weight:600;
                    font-size:1rem;text-transform:uppercase;letter-spacing:.5px;transition:var(--transition-medium);
                    box-shadow:var(--shadow-light);position:relative;overflow:hidden;width:100%;cursor:pointer;}
        .submit-btn::before{content:'';position:absolute;top:0;left:-100%;width:100%;height:100%;
                            background:linear-gradient(90deg,transparent,rgba(255,255,255,.2),transparent);
                            transition:var(--transition-medium);}
        .submit-btn:hover{transform:translateY(-3px);box-shadow:var(--shadow-heavy);}
        .submit-btn:hover::before{left:100%;}
        .submit-btn:disabled{opacity:.7;cursor:not-allowed;transform:none;}
        .btn-loading{position:relative;color:transparent;}
        .btn-loading::after{content:'';position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
                            width:20px;height:20px;border:2px solid rgba(255,255,255,.3);border-radius:50%;
                            border-top-color:#fff;animation:spin 1s linear infinite;}

        /* Sign-up */
        .signup-section{text-align:center;margin-top:2rem;padding-top:2rem;border-top:1px solid var(--border-color);}
        .signup-text{color:var(--text-secondary);margin-bottom:1rem;}
        .signup-link{color:#419aff;font-weight:600;text-decoration:none;padding:.5rem 1rem;border-radius:8px;transition:var(--transition-fast);}
        .signup-link:hover{background:rgba(65,154,255,.12);color:#1f80ff;text-decoration:none;}

        /* Right panel */
        .image-panel{background:var(--primary-gradient);position:relative;display:flex;align-items:center;justify-content:center;
                     padding:3rem;min-height:600px;}
        .image-panel::before{content:'';position:absolute;inset:0;
                             background:url('data:image/svg+xml,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 100 100\"><defs><pattern id=\"grain\" width=\"100\" height=\"100\" patternUnits=\"userSpaceOnUse\"><circle cx=\"50\" cy=\"50\" r=\"1\" fill=\"rgba(255,255,255,0.1)\"/></pattern></defs><rect width=\"100\" height=\"100\" fill=\"url(%23grain)\"/></svg>');opacity:.3;}
        .image-content{position:relative;z-index:2;text-align:center;color:#fff;}
        .image-content h2{font-size:3rem;font-weight:800;margin-bottom:1rem;text-shadow:0 2px 4px rgba(0,0,0,.3);}
        .image-content p{font-size:1.25rem;font-weight:300;opacity:.9;line-height:1.6;max-width:400px;margin-inline:auto;}
        .feature-list{list-style:none;margin-top:2rem;text-align:left;}
        .feature-list li{display:flex;align-items:center;gap:1rem;margin-bottom:1rem;font-size:1.1rem;}
        .feature-list i{width:24px;height:24px;background:rgba(255,255,255,.25);border-radius:50%;
                        display:flex;align-items:center;justify-content:center;font-size:.9rem;}

        /* Icons animation */
        .medical-icons{position:absolute;inset:0;}
        .medical-icon{position:absolute;color:rgba(255,255,255,.15);font-size:2rem;animation:float 4s ease-in-out infinite;}
        .medical-icon:nth-child(1){top:15%;left:15%;}
        .medical-icon:nth-child(2){top:25%;right:20%;animation-delay:1s;}
        .medical-icon:nth-child(3){bottom:30%;left:10%;animation-delay:2s;}
        .medical-icon:nth-child(4){bottom:15%;right:15%;animation-delay:3s;}

        /* Security badge */
        .security-badge{position:absolute;bottom:2rem;left:50%;transform:translateX(-50%);
                        background:rgba(255,255,255,.12);backdrop-filter:blur(10px);
                        padding:1rem 1.5rem;border-radius:50px;display:flex;align-items:center;gap:.75rem;
                        color:#fff;font-weight:500;border:1px solid rgba(255,255,255,.2);}
        .security-badge i{color:#4ade80;font-size:1.25rem;}

        /* Animations */
        @keyframes float{0%,100%{transform:translateY(0);}50%{transform:translateY(-20px);}}
        @keyframes shine{0%,100%{transform:rotate(45deg)translate(-200%,-200%);}50%{transform:rotate(45deg)translate(200%,200%);}}
        @keyframes shake{0%,100%{transform:translateX(0);}25%{transform:translateX(-5px);}75%{transform:translateX(5px);}}
        @keyframes spin{0%{transform:translate(-50%,-50%)rotate(0);}100%{transform:translate(-50%,-50%)rotate(360deg);}}

        /* Responsive */
        @media(max-width:992px){.image-panel{min-height:400px;} .image-content h2{font-size:2.5rem;} .form-panel{padding:2rem;}}
        @media(max-width:768px){
            .login-container{padding:1rem;} .form-panel{padding:1.5rem;} .image-panel{min-height:300px;padding:2rem;}
            .image-content h2{font-size:2rem;} .brand-title{font-size:2rem;}
            .remember-section{flex-direction:column;gap:1rem;align-items:flex-start;}
        }
        @media(max-width:576px){
            .brand-title{font-size:1.75rem;} .section-title{font-size:1.25rem;}
            .image-content h2{font-size:1.75rem;} .image-content p{font-size:1rem;}
        }

        /* Validation states */
        .form-control.is-invalid{border-color:#ef4444;animation:shake .5s ease-in-out;}
        .form-control.is-valid{border-color:#10b981;}
        .invalid-feedback,.valid-feedback{font-size:.875rem;margin-top:.5rem;display:block;}
        .invalid-feedback{color:#ef4444;} .valid-feedback{color:#10b981;}
    </style>
</head>

<body>
    <!-- Background -->
    <div class="bg-animation">
        <div class="floating-shapes">
            <div class="shape"></div><div class="shape"></div><div class="shape"></div><div class="shape"></div><div class="shape"></div>
        </div>
    </div>

    <!-- Login card -->
    <div class="login-container">
        <div class="login-card animate__animated animate__fadeInUp">
            <div class="row g-0 h-100">
                <!-- Left -->
                <div class="col-lg-6">
                    <div class="form-panel">
                        <!-- Branding -->
                        <div class="brand-header">
                            <div class="brand-logo">DA</div>
                            <h1 class="brand-title">DocAid</h1>
                            <p class="brand-subtitle">Welcome Back</p>
                            <p class="welcome-text">Sign in to access your healthcare dashboard and manage appointments securely.</p>
                        </div>

                        <%-- Server-side errors --%>
                        <%
                            String err = request.getParameter("error");
                            if (err != null) {
                                String msg = "";
                                String icon = "fas fa-exclamation-triangle";
                                switch (err) {
                                    case "1": msg="Incorrect email or password. Please try again."; icon="fas fa-lock"; break;
                                    case "2": msg="Please enter both email and password.";          icon="fas fa-exclamation-circle"; break;
                                    case "3": msg="A server error occurred. Please try again.";     icon="fas fa-server"; break;
                                    default:  msg="Authentication failed. Please try again.";      icon="fas fa-times-circle";
                                }
                        %>
                                <div class="error-alert"><i class="<%=icon%>"></i><span><%=msg%></span></div>
                        <%
                            }
                        %>

                        <!-- Form -->
                        <div class="form-section">
                            <h2 class="section-title"><i class="fas fa-sign-in-alt"></i> Sign In</h2>

                            <form action="login.jsp" method="POST" id="loginForm" novalidate>
                                <!-- Email -->
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-envelope"></i>Email Address</label>
                                    <div class="input-wrapper">
                                        <input type="email" name="email" class="form-control" placeholder="Enter your email" required autocomplete="email">
                                        <i class="fas fa-envelope input-icon"></i>
                                    </div>
                                    <div class="invalid-feedback"></div>
                                </div>

                                <!-- Password -->
                                <div class="form-group">
                                    <label class="form-label"><i class="fas fa-lock"></i>Password</label>
                                    <div class="input-wrapper">
                                        <input type="password" name="password" class="form-control" placeholder="Enter your password" required minlength="6" autocomplete="current-password">
                                        <i class="fas fa-lock input-icon"></i>
                                        <button type="button" class="password-toggle" id="passwordToggle"><i class="fas fa-eye"></i></button>
                                    </div>
                                    <div class="invalid-feedback"></div>
                                </div>

                                <!-- Remember / Forgot -->
                                <div class="remember-section">
                                    <label class="custom-checkbox">
                                        <input type="checkbox" id="remember_me" name="remember_me">
                                        <div class="checkbox-indicator"><i class="fas fa-check"></i></div>
                                        <span>Remember me</span>
                                    </label>
                                    <a href="#" class="forgot-password">Forgot password?</a>
                                </div>

                                <!-- Submit -->
                                <button type="submit" class="submit-btn" id="submitBtn">
                                    <i class="fas fa-sign-in-alt me-2"></i>Sign In Securely
                                </button>
                            </form>
                        </div>

                        <!-- Sign-up -->
                        <div class="signup-section">
                            <p class="signup-text">Don't have a DocAid account yet?</p>
                            <a href="../sign_up.jsp" class="signup-link"><i class="fas fa-user-plus me-2"></i>Create New Account</a>
                        </div>
                    </div>
                </div>

                <!-- Right -->
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="image-panel">
                        <div class="medical-icons">
                            <i class="fas fa-stethoscope medical-icon"></i>
                            <i class="fas fa-heartbeat medical-icon"></i>
                            <i class="fas fa-user-md medical-icon"></i>
                            <i class="fas fa-hospital medical-icon"></i>
                        </div>

                        <div class="image-content">
                            <h2>Healthcare Made Simple</h2>
                            <p>Access medical records, book appointments, and connect with providers through our secure portal.</p>
                            <ul class="feature-list">
                                <li><i class="fas fa-shield-alt"></i><span>HIPAA-Compliant Security</span></li>
                                <li><i class="fas fa-calendar-check"></i><span>Easy Appointment Booking</span></li>
                                <li><i class="fas fa-file-medical"></i><span>Digital Medical Records</span></li>
                                <li><i class="fas fa-comments"></i><span>Direct Doctor Communication</span></li>
                            </ul>
                        </div>

                        <div class="security-badge"><i class="fas fa-shield-check"></i><span>256-bit SSL Encrypted</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded',()=>{
        const form=document.getElementById('loginForm');
        const submitBtn=document.getElementById('submitBtn');
        const passwordToggle=document.getElementById('passwordToggle');
        const passwordField=document.querySelector('input[name="password"]');

        /* Toggle password */
        passwordToggle.addEventListener('click',()=>{
            const type=passwordField.type==='password'?'text':'password';
            passwordField.type=type;
            passwordToggle.querySelector('i').classList.toggle('fa-eye');
            passwordToggle.querySelector('i').classList.toggle('fa-eye-slash');
        });

        /* Validation - Removed email regex check */
        function validateField(field){
            const value=field.value.trim();
            const feedback=field.parentNode.parentNode.querySelector('.invalid-feedback');
            field.classList.remove('is-invalid','is-valid');

            if(field.hasAttribute('required')&&!value){
                field.classList.add('is-invalid');
                feedback.textContent='This field is required.';
                return false;
            }
            if(field.name==='password'&&value.length>0&&value.length<6){
                field.classList.add('is-invalid');
                feedback.textContent='Password must be ≥6 characters.';
                return false;
            }
            if(value){
                field.classList.add('is-valid');
                feedback.textContent='';
            }
            return true;
        }

        /* Real-time listeners */
        document.querySelectorAll('.form-control').forEach(f=>{
            f.addEventListener('blur',()=>validateField(f));
            f.addEventListener('input',()=>{if(f.classList.contains('is-invalid'))validateField(f);});
        });

        /* Submit */
        form.addEventListener('submit',e=>{
            e.preventDefault();
            let ok=true;
            form.querySelectorAll('[required]').forEach(f=>{if(!validateField(f))ok=false;});
            if(ok){
                submitBtn.classList.add('btn-loading');submitBtn.disabled=true;
                setTimeout(()=>form.submit(),1000);
            }else{
                const firstInvalid=form.querySelector('.is-invalid');
                if(firstInvalid){firstInvalid.scrollIntoView({behavior:'smooth',block:'center'});firstInvalid.focus();}
            }
        });

        /* Focus effect */
        document.querySelectorAll('.form-control').forEach(i=>{
            i.addEventListener('focus',()=>i.parentNode.style.transform='translateY(-2px)');
            i.addEventListener('blur',()=>i.parentNode.style.transform='translateY(0)');
        });

        /* Keyboard Enter */
        document.addEventListener('keydown',e=>{
            if(e.key==='Enter'&&e.target.type!=='submit')submitBtn.click();
        });

        /* Autofocus */
        setTimeout(()=>form.querySelector('input[type="email"]').focus(),500);

        /* Checkbox animation */
        const remember=document.getElementById('remember_me');
        remember.addEventListener('change',()=>{
            const ind=remember.nextElementSibling;
            if(remember.checked){
                ind.style.transform='scale(1.1)';setTimeout(()=>ind.style.transform='scale(1)',150);
            }
        });

        /* Prevent resubmit */
        if(window.history.replaceState)window.history.replaceState(null,null,window.location.href);

        /* CSRF placeholder */
        const csrf=document.createElement('input');
        csrf.type='hidden';csrf.name='csrf_token';csrf.value='placeholder-csrf-token';form.appendChild(csrf);
    });

    /* Staggered load */
    window.addEventListener('load',()=>{
        document.querySelectorAll('.form-group,.remember-section,.submit-btn,.signup-section')
                .forEach((el,i)=>{
                    el.style.opacity='0';el.style.transform='translateY(20px)';
                    el.style.transition='opacity .5s ease,transform .5s ease';
                    setTimeout(()=>{el.style.opacity='1';el.style.transform='translateY(0)';},100*i);
                });
    });
    </script>
</body>
</html>
