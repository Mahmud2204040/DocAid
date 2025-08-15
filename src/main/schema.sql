-- =====================================================
-- Healthcare Management System Database - CORRECTED VERSION
-- Implementing 4 User Types: Admin, Doctor, Hospital, Patient
-- =====================================================

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS Monitors;
DROP TABLE IF EXISTS availability;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Doctor_schedule;
DROP TABLE IF EXISTS Medical_test;
DROP TABLE IF EXISTS Hospital_Contact;
DROP TABLE IF EXISTS Doctor_Contact;
DROP TABLE IF EXISTS Patient_Contact;
DROP TABLE IF EXISTS Specialties;
DROP TABLE IF EXISTS Hospital;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Users;

-- =====================================================
-- 1. USERS TABLE (Base Entity for IsA Relationship)
-- =====================================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type ENUM('Admin', 'Doctor', 'Hospital', 'Patient') NOT NULL,
    auth_key VARCHAR(255) DEFAULT NULL,  -- Added for remember-me cookies
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_type (user_type),
    INDEX idx_email (email)
);

-- =====================================================
-- 2. SPECIALTIES TABLE (Referenced by Doctor)
-- =====================================================
CREATE TABLE Specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FULLTEXT(specialty_name)
);

-- =====================================================
-- 3. HOSPITAL TABLE (User Type)
-- =====================================================
CREATE TABLE Hospital (
    hospital_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    hospital_name VARCHAR(255) NOT NULL,
    hospital_bio TEXT,
    address TEXT NOT NULL,
    website VARCHAR(255),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX idx_hospital_name (hospital_name),
    INDEX idx_hospital_location (latitude, longitude)
);

-- =====================================================
-- 4. ADMIN TABLE (User Type)
-- =====================================================
CREATE TABLE Admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX idx_admin_name (first_name, last_name)
);

-- =====================================================
-- 5. PATIENT TABLE (User Type)
-- =====================================================
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX idx_patient_name (first_name, last_name),
    INDEX idx_patient_dob (date_of_birth),
    INDEX idx_patient_location (latitude, longitude)
);

-- =====================================================
-- 6. DOCTOR TABLE (User Type)
-- =====================================================
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    exp_years INT NOT NULL CHECK (exp_years >= 0),
    bio TEXT,
    fee DECIMAL(10, 2) NOT NULL CHECK (fee >= 0),
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    specialty_id INT,
    hospital_id INT,
    profile_image VARCHAR(255) DEFAULT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    is_available_for_patients BOOLEAN DEFAULT TRUE,
    phone VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (specialty_id) REFERENCES Specialties(specialty_id) ON DELETE SET NULL,
    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id) ON DELETE SET NULL,
    INDEX idx_doctor_name (first_name, last_name),
    INDEX idx_doctor_license (license_number),
    INDEX idx_doctor_specialty (specialty_id),
    INDEX idx_doctor_hospital (hospital_id),
    INDEX idx_doctor_location (latitude, longitude),
    FULLTEXT(first_name, last_name, bio, address)
);

-- =====================================================
-- 7. USER CONTACT TABLE (Consolidated)
-- =====================================================
CREATE TABLE User_Contact (
    contact_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    contact_no VARCHAR(20) NOT NULL,
    contact_type ENUM('Primary', 'Secondary', 'Emergency', 'General', 'Appointment') DEFAULT 'Primary',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_contact (user_id, contact_no),
    INDEX idx_user_contact_no (contact_no)
);

-- =====================================================
-- 8. APPOINTMENT TABLE
-- =====================================================
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    appointment_status ENUM('Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY unique_appointment (doctor_id, appointment_date, appointment_time),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_appointment_patient (patient_id),
    INDEX idx_appointment_doctor (doctor_id),
    INDEX idx_appointment_status (appointment_status)
);

-- =====================================================
-- 9. REVIEWS TABLE
-- =====================================================
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    admin_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date DATE NOT NULL,
    is_moderated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id) ON DELETE SET NULL,
    UNIQUE KEY unique_patient_doctor_review (patient_id, doctor_id),
    INDEX idx_review_rating (rating),
    INDEX idx_review_date (review_date),
    INDEX idx_review_moderated (is_moderated)
);

-- =====================================================
-- 10. DOCTOR SCHEDULE TABLE
-- =====================================================
CREATE TABLE Doctor_schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    visiting_day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_day_time (doctor_id, visiting_day, start_time),
    INDEX idx_schedule_day (visiting_day),
    INDEX idx_schedule_doctor (doctor_id),
    CHECK (start_time < end_time)
);

-- =====================================================
-- 11. MEDICAL TEST TABLE
-- =====================================================
CREATE TABLE Medical_test (
    test_id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    test_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id) ON DELETE CASCADE,
    INDEX idx_test_name (test_name),
    INDEX idx_test_hospital (hospital_id),
    INDEX idx_test_price (price)
);

-- =====================================================
-- 12. MONITORS TABLE (Many-to-Many: Admin-Users)
-- =====================================================
CREATE TABLE Monitors (
    monitor_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT NOT NULL,
    monitored_user_id INT NOT NULL,
    monitoring_start_date DATE NOT NULL,
    monitoring_end_date DATE,
    monitoring_reason TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id) ON DELETE CASCADE,
    FOREIGN KEY (monitored_user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_admin_user_monitoring (admin_id, monitored_user_id),
    INDEX idx_monitoring_admin (admin_id),
    INDEX idx_monitoring_user (monitored_user_id),
    INDEX idx_monitoring_active (is_active)
);

-- =====================================================
-- 13. AFFILIATION REQUEST TABLE (Many-to-Many: Hospital-Doctor)
-- =====================================================
CREATE TABLE AffiliationRequest (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    hospital_id INT NOT NULL,
    doctor_id INT NOT NULL,
    request_status ENUM('Pending', 'Approved', 'Denied') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id) ON DELETE CASCADE,
    UNIQUE KEY unique_hospital_doctor_pending_request (hospital_id, doctor_id, request_status),
    INDEX idx_affiliation_request_status (request_status)
);

-- =====================================================
-- TRIGGERS FOR IsA RELATIONSHIP ENFORCEMENT
-- =====================================================

-- Trigger to ensure user_type consistency for Admin
DELIMITER //
CREATE TRIGGER trg_admin_user_type_check
    BEFORE INSERT ON Admin
    FOR EACH ROW
BEGIN
    DECLARE v_user_type VARCHAR(10);
    SELECT user_type INTO v_user_type FROM Users WHERE user_id = NEW.user_id;
    IF v_user_type != 'Admin' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User type must be Admin for Admin table';
    END IF;
END//

-- Trigger to ensure user_type consistency for Doctor
CREATE TRIGGER trg_doctor_user_type_check
    BEFORE INSERT ON Doctor
    FOR EACH ROW
BEGIN
    DECLARE v_user_type VARCHAR(10);
    SELECT user_type INTO v_user_type FROM Users WHERE user_id = NEW.user_id;
    IF v_user_type != 'Doctor' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User type must be Doctor for Doctor table';
    END IF;
END//

-- Trigger to ensure user_type consistency for Hospital
CREATE TRIGGER trg_hospital_user_type_check
    BEFORE INSERT ON Hospital
    FOR EACH ROW
BEGIN
    DECLARE v_user_type VARCHAR(10);
    SELECT user_type INTO v_user_type FROM Users WHERE user_id = NEW.user_id;
    IF v_user_type != 'Hospital' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User type must be Hospital for Hospital table';
    END IF;
END//

-- Trigger to ensure user_type consistency for Patient
CREATE TRIGGER trg_patient_user_type_check
    BEFORE INSERT ON Patient
    FOR EACH ROW
BEGIN
    DECLARE v_user_type VARCHAR(10);
    SELECT user_type INTO v_user_type FROM Users WHERE user_id = NEW.user_id;
    IF v_user_type != 'Patient' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User type must be Patient for Patient table';
    END IF;
END//
DELIMITER ;

-- =====================================================
-- SAMPLE DATA INSERT
-- =====================================================

-- Insert sample specialties
INSERT INTO Specialties (specialty_name) VALUES 
('Cardiology'), ('Dermatology'), ('Neurology'), ('Pediatrics'), ('Orthopedics');

-- Insert sample users
INSERT INTO Users (email, password, user_type) VALUES
('admin1@hospital.com', 'hashed_password1', 'Admin'),
('admin2@hospital.com', 'hashed_password2', 'Admin'),
('hospital1@medical.com', 'hashed_password3', 'Hospital'),
('hospital2@medical.com', 'hashed_password4', 'Hospital'),
('doctor1@medical.com', 'hashed_password5', 'Doctor'),
('doctor2@medical.com', 'hashed_password6', 'Doctor'),
('patient1@email.com', 'hashed_password7', 'Patient'),
('patient2@email.com', 'hashed_password8', 'Patient');

-- Insert sample admins
INSERT INTO Admin (user_id, first_name, last_name) VALUES
(1, 'John', 'Administrator'),
(2, 'Sarah', 'Manager');

-- Insert sample hospitals
INSERT INTO Hospital (user_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES
(3, 'City General Hospital', 'Leading healthcare provider in the city', '123 Main St, City Center', 'www.citygeneral.com', 40.7128, -74.0060),
(4, 'Metropolitan Medical Center', 'Specialized care for complex conditions', '456 Health Ave, Metro District', 'www.metromedical.com', 40.7589, -73.9851);

-- Insert sample doctors
INSERT INTO Doctor (user_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES
(5, 'Dr. Michael', 'Johnson', 'Male', 'MD123456', 15, 'Experienced cardiologist', 200.00, '789 Medical Plaza', 40.7505, -73.9934, 1, 1),
(6, 'Dr. Emily', 'Davis', 'Female', 'MD789012', 8, 'Pediatric specialist', 150.00, '321 Care Center', 40.7282, -74.0776, 4, 2);

-- Insert sample patients
INSERT INTO Patient (user_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES
(7, 'Alice', 'Smith', 'Female', '1985-06-15', 'A+', '555 Residential St', 40.7361, -73.9922),
(8, 'Bob', 'Williams', 'Male', '1990-03-22', 'O-', '777 Community Rd', 40.7488, -73.9857);

-- Insert sample contact information
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES
-- Patient Contacts (user_ids from the Users table are 7 and 8)
(7, '+1-555-0101', 'Primary'),
(8, '+1-555-0102', 'Primary'),
-- Doctor Contacts (user_ids from the Users table are 5 and 6)
(5, '+1-555-0201', 'Primary'),
(6, '+1-555-0202', 'Primary'),
-- Hospital Contacts (user_ids from the Users table are 3 and 4)
(3, '+1-555-0301', 'Emergency'),
(4, '+1-555-0302', 'Emergency');

-- Insert sample appointments
INSERT INTO Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) VALUES
(1, 1, '2025-08-15', '10:00:00', 'Scheduled'),
(2, 2, '2025-08-16', '14:30:00', 'Confirmed');

-- Insert sample reviews
INSERT INTO Reviews (patient_id, doctor_id, admin_id, rating, comment, review_date) VALUES
(1, 1, 1, 5, 'Excellent care and very professional', '2025-07-20'),
(2, 2, NULL, 4, 'Good experience, very patient with children', '2025-07-25');

-- Insert sample doctor schedules
INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES
(1, 'Monday', '09:00:00', '17:00:00'),
(1, 'Wednesday', '09:00:00', '17:00:00'),
(2, 'Tuesday', '08:00:00', '16:00:00'),
(2, 'Thursday', '08:00:00', '16:00:00');

-- Insert sample medical tests
INSERT INTO Medical_test (hospital_id, test_name, price, description) VALUES
(1, 'Blood Test Complete', 150.00, 'Comprehensive blood panel analysis'),
(1, 'X-Ray Chest', 200.00, 'Chest X-ray examination'),
(2, 'MRI Brain', 800.00, 'Brain MRI scan with contrast');

-- Insert sample monitoring records
INSERT INTO Monitors (admin_id, monitored_user_id, monitoring_start_date, monitoring_reason) VALUES
(1, 5, '2025-08-01', 'Routine performance monitoring'),
(2, 6, '2025-08-01', 'New doctor onboarding supervision');

-- =====================================================
-- TRIGGERS FOR RATING
-- =====================================================

-- Create trigger to update doctor rating automatically
DELIMITER //
CREATE TRIGGER trg_update_doctor_rating
    AFTER INSERT ON Reviews
    FOR EACH ROW
BEGIN
    UPDATE Doctor 
    SET rating = (
        SELECT AVG(rating) 
        FROM Reviews 
        WHERE doctor_id = NEW.doctor_id
    ),
    review_count = (
        SELECT COUNT(*) 
        FROM Reviews 
        WHERE doctor_id = NEW.doctor_id
    )
    WHERE doctor_id = NEW.doctor_id;
END//

CREATE TRIGGER trg_update_doctor_rating_on_update
    AFTER UPDATE ON Reviews
    FOR EACH ROW
BEGIN
    UPDATE Doctor 
    SET rating = (
        SELECT AVG(rating) 
        FROM Reviews 
        WHERE doctor_id = NEW.doctor_id
    ),
    review_count = (
        SELECT COUNT(*) 
        FROM Reviews 
        WHERE doctor_id = NEW.doctor_id
    )
    WHERE doctor_id = NEW.doctor_id;
END//
DELIMITER ;

-- =====================================================
-- USEFUL VIEWS FOR REPORTING
-- =====================================================

-- Create a comprehensive doctor search view
CREATE VIEW v_doctor_search AS
SELECT 
    d.doctor_id,
    d.user_id,
    CONCAT(d.first_name, ' ', d.last_name) as display_name,
    d.first_name,
    d.last_name,
    d.gender,
    d.license_number,
    d.exp_years as experience,
    d.bio,
    d.fee,
    d.address,
    d.latitude,
    d.longitude,
    d.profile_image,
    d.is_verified,
    d.rating,
    d.review_count,
    d.is_available_for_patients,
    d.phone,                -- Added this line
    s.specialty_name as specialty,
    s.specialty_id,
    h.hospital_name,
    h.hospital_id,
    h.address as hospital_address,
    u.email,
    u.created_at,
    u.updated_at
FROM Doctor d
LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id
LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id
JOIN Users u ON d.user_id = u.user_id
WHERE u.user_type = 'Doctor';

-- View for complete user information with type-specific details
CREATE VIEW v_user_complete_info AS
SELECT 
    u.user_id,
    u.email,
    u.user_type,
    CASE 
        WHEN u.user_type = 'Admin' THEN CONCAT(a.first_name, ' ', a.last_name)
        WHEN u.user_type = 'Doctor' THEN CONCAT(d.first_name, ' ', d.last_name)
        WHEN u.user_type = 'Patient' THEN CONCAT(p.first_name, ' ', p.last_name)
        WHEN u.user_type = 'Hospital' THEN h.hospital_name
    END as full_name,
    u.created_at,
    u.updated_at
FROM Users u
LEFT JOIN Admin a ON u.user_id = a.user_id
LEFT JOIN Doctor d ON u.user_id = d.user_id
LEFT JOIN Patient p ON u.user_id = p.user_id
LEFT JOIN Hospital h ON u.user_id = h.user_id;

-- View for appointment details with names
CREATE VIEW v_appointment_details AS
SELECT 
    ap.appointment_id,
    p.user_id,
    CONCAT(p.first_name, ' ', p.last_name) as patient_name,
    CONCAT(d.first_name, ' ', d.last_name) as doctor_name,
    h.hospital_id,
    h.hospital_name,
    s.specialty_name,
    ap.appointment_date,
    ap.appointment_time,
    ap.appointment_status,
    ap.created_at
FROM Appointment ap
JOIN Patient p ON ap.patient_id = p.patient_id
JOIN Doctor d ON ap.doctor_id = d.doctor_id
JOIN Hospital h ON d.hospital_id = h.hospital_id
JOIN Specialties s ON d.specialty_id = s.specialty_id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to check doctor availability
DELIMITER //
CREATE PROCEDURE CheckDoctorAvailability(
    IN p_doctor_id INT,
    IN p_date DATE,
    IN p_time TIME
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_day_name VARCHAR(10);
    
    SET v_day_name = DAYNAME(p_date);
    
    -- Check if doctor has a schedule for this day and time
    SELECT COUNT(*) INTO v_count
    FROM Doctor_schedule ds
    WHERE ds.doctor_id = p_doctor_id
    AND ds.visiting_day = v_day_name
    AND p_time BETWEEN ds.start_time AND ds.end_time
    AND ds.is_available = TRUE;
    
    IF v_count = 0 THEN
        SELECT 1 AS status_code, 'UNAVAILABLE' AS status, 'Doctor is not scheduled to work at the requested time.' AS message;
    ELSE
        -- Check if there's already an appointment at this time
        SELECT COUNT(*) INTO v_count
        FROM Appointment a
        WHERE a.doctor_id = p_doctor_id
        AND a.appointment_date = p_date
        AND a.appointment_time = p_time
        AND a.appointment_status NOT IN ('Cancelled', 'No-Show');
        
        IF v_count > 0 THEN
            SELECT 2 AS status_code, 'BOOKED' AS status, 'The requested time slot is already booked.' AS message;
        ELSE
            SELECT 0 AS status_code, 'AVAILABLE' AS status, 'The doctor is available at the requested time.' AS message;
        END IF;
    END IF;
END//
DELIMITER ;

-- =====================================================
-- PERFORMANCE INDEXES (Additional)
-- =====================================================

-- Composite indexes for frequent queries
CREATE INDEX idx_appointment_doctor_date ON Appointment(doctor_id, appointment_date);
CREATE INDEX idx_appointment_patient_date ON Appointment(patient_id, appointment_date);
CREATE INDEX idx_reviews_doctor_rating ON Reviews(doctor_id, rating);
CREATE INDEX idx_doctor_hospital_specialty ON Doctor(hospital_id, specialty_id);

-- Full-text search indexes for better search functionality
-- ALTER TABLE Doctor ADD FULLTEXT(first_name, last_name, bio);
-- ALTER TABLE Hospital ADD FULLTEXT(hospital_name, hospital_bio);
-- ALTER TABLE Patient ADD FULLTEXT(first_name, last_name);

-- =====================================================
-- DATABASE SETUP COMPLETE
-- =====================================================

-- Display summary of created tables
SELECT 'Healthcare Management System Database Created Successfully!' as Status;
SELECT TABLE_NAME, TABLE_ROWS, ENGINE 
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = DATABASE() 
ORDER BY TABLE_NAME;