<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>About DocAid – Hospital Appointment Booking System</title>

  <!-- Bootstrap CSS -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
    rel="stylesheet"/>
  <!-- Bootstrap Icons -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
    rel="stylesheet"/>
  <!-- Google Font -->
  <link
    href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap"
    rel="stylesheet"/>
  <link rel="icon" href="favicon.ico" type="image/x-icon"/>

  <style>
    :root {
      --accent-gradient: linear-gradient(135deg, #5aaaff, #98c9ff);
      --section-bg-light: #ffffff;
      --section-bg-dark: #f0f4fb;
      --text-dark: #0c264a;
      --text-light: #495057;
    }
    body {
      font-family: 'Roboto', sans-serif;
      background-color: var(--section-bg-dark);
      padding-top: 56px;
    }
    .about-section {
      padding: 80px 0;
      background: var(--section-bg-dark);
    }
    .about-card {
      background: var(--section-bg-light);
      border-radius: 1rem;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
      padding: 2rem;
      margin-bottom: 2rem;
    }
    .about-section h2 {
      position: relative;
      display: inline-block;
      padding-bottom: 0.5rem;
      color: var(--text-dark);
      font-weight: 700;
      margin-bottom: 1rem;
    }
    .about-section h2::after {
      content: '';
      position: absolute;
      bottom: 0; left: 0;
      width: 50px; height: 4px;
      background: var(--accent-gradient);
      border-radius: 2px;
    }
    .about-section .lead {
      font-size: 1.15rem;
      color: var(--text-dark);
      font-weight: 300;
      margin-bottom: 1.5rem;
    }
    .about-section p {
      color: var(--text-light);
      margin-bottom: 1rem;
    }
    .values-section {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin-top: 3rem;
    }
    .values-section .half {
      background: var(--section-bg-light);
      border-radius: 1rem;
      padding: 1.5rem;
      box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    }
    .values-section .half:nth-child(odd) {
      background: var(--section-bg-dark);
    }
    .values-section h3 {
      margin-bottom: 1rem;
      color: var(--text-dark);
      font-weight: 600;
    }
    .values-section ul {
      list-style: none;
      padding: 0;
    }
    .values-section li {
      position: relative;
      padding-left: 2rem;
      margin-bottom: 1rem;
      color: var(--text-dark);
    }
    .values-section li::before {
      content: '★';
      position: absolute;
      left: 0;
      top: 0;
      color: #ffbf47;
      font-size: 1.2rem;
      line-height: 1;
    }
    @media (max-width: 767px) {
      .values-section {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
  <%@ include file="header_patient.jsp" %>

  <main class="container about-section">
    <div class="about-card mx-auto" style="max-width: 800px;">
      <h2>About DocAid</h2>
      <p class="lead">
        DocAid is a revolutionary platform designed to bridge the gap between patients and healthcare providers. Our mission is to make healthcare more accessible, transparent, and patient-centric.
      </p>
      <p>
        Founded in 2024, DocAid began with a simple idea: create a single platform where patients can find trusted doctors, read authentic reviews, and book appointments instantly. We partner with a wide network of hospitals, clinics, and practitioners to offer comprehensive healthcare services.
      </p>
      <p>
        Our team comprises passionate professionals from healthcare and technology, dedicated to improving the patient experience. We continuously innovate and add new features to better serve our users.
      </p>
    </div>

    <section class="values-section container">
      <div class="half">
        <h3>Our Core Values</h3>
        <ul>
          <li>Patient-Centricity: Patients are at the heart of everything we do.</li>
          <li>Trust & Transparency: We provide authentic, reliable information.</li>
        </ul>
      </div>
      <div class="half">
        <ul>
          <li>Innovation: We leverage technology to solve real-world healthcare challenges.</li>
          <li>Accessibility: We strive to make healthcare accessible for everyone, everywhere.</li>
        </ul>
      </div>
    </section>
  </main>

  <%@ include file="../footer.jsp" %>

  <!-- Bootstrap JavaScript -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
