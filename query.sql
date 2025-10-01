-- Admin.java
SELECT user_type, COUNT(*) AS count FROM Users GROUP BY user_type;
SELECT appointment_status, COUNT(*) AS count FROM Appointment GROUP BY appointment_status;
SELECT COUNT(*) FROM Reviews WHERE is_moderated = FALSE;
SELECT u.user_id, u.email, u.user_type FROM Users u;
DELETE FROM Users WHERE user_id = ?;
SELECT r.review_id, CONCAT(p.first_name, ' ', p.last_name) as patient_name FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id JOIN Doctor d ON r.doctor_id = d.doctor_id WHERE r.is_moderated = FALSE ORDER BY r.review_date ASC;
UPDATE Reviews SET is_moderated = TRUE, admin_id = ? WHERE review_id = ?;
DELETE FROM Reviews WHERE review_id = ?;
SELECT 1 FROM Users WHERE user_id = ?;
SELECT specialty_id, specialty_name FROM Specialties ORDER BY specialty_name;
INSERT INTO Specialties (specialty_name) VALUES (?);
UPDATE Specialties SET specialty_name = ? WHERE specialty_id = ?;
DELETE FROM Specialties WHERE specialty_id = ?;
SELECT COUNT(*) FROM Appointment;
SELECT COUNT(*) FROM Appointment WHERE MONTH(appointment_date) = MONTH(CURDATE()) AND YEAR(appointment_date) = YEAR(CURDATE());
SELECT DATE_FORMAT(appointment_date, '%Y-%m') as month, COUNT(*) as count FROM Appointment GROUP BY month ORDER BY month ASC;

-- AppointmentServlet.java
SELECT * FROM v_appointment_details WHERE user_id = ? ORDER BY appointment_date DESC, appointment_time DESC;

-- BookAppointmentServlet.java
SELECT COUNT(*) FROM Doctor_schedule WHERE doctor_id = ? AND visiting_day = DAYNAME(?) AND ? BETWEEN start_time AND end_time;
SELECT COUNT(*) FROM Appointment WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ? AND appointment_status NOT IN ('Cancelled', 'No-Show');
INSERT INTO Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) VALUES (?, ?, ?, ?, 'Scheduled');
SELECT patient_id FROM Patient WHERE user_id = ?;

-- Doctor.java
INSERT INTO Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, 'Primary') ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no);
SELECT r.rating, r.comment, r.review_date, p.first_name, p.last_name FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id WHERE r.doctor_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC;
SELECT ar.request_id, h.hospital_name FROM AffiliationRequest ar JOIN Hospital h ON ar.hospital_id = h.hospital_id WHERE ar.doctor_id = ? AND ar.request_status = 'Pending';
SELECT hospital_id, doctor_id FROM AffiliationRequest WHERE request_id = ? AND request_status = 'Pending';
UPDATE AffiliationRequest SET request_status = ? WHERE request_id = ?;
UPDATE Doctor SET hospital_id = ? WHERE doctor_id = ?;
UPDATE AffiliationRequest SET request_status = 'Denied' WHERE doctor_id = ? AND request_status = 'Pending';
UPDATE Doctor SET hospital_id = NULL WHERE doctor_id = ?;
SELECT d.*, s.specialty_name, h.hospital_name, u.email, uc.contact_no FROM Doctor d JOIN Users u ON d.doctor_id = u.user_id JOIN Specialties s ON d.specialty_id = s.specialty_id LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id LEFT JOIN User_Contact uc ON d.doctor_id = uc.user_id AND uc.contact_type = 'Appointment' WHERE d.doctor_id = ?;

-- DoctorAppointmentServlet.java
SELECT a.appointment_id, a.appointment_date, a.appointment_time, a.appointment_status, FROM Appointment a JOIN Patient p ON a.patient_id = p.patient_id WHERE a.doctor_id = ? ORDER BY a.appointment_date DESC, a.appointment_time ASC;
UPDATE Appointment SET appointment_status = ? WHERE appointment_id = ?;

-- DoctorProfileServlet.java
SELECT d.*, s.specialty_name, h.hospital_name, u.email FROM Doctor d JOIN Users u ON d.doctor_id = u.user_id JOIN Specialties s ON d.specialty_id = s.specialty_id LEFT JOIN Hospital h ON d.hospital_id = h.hospital_id WHERE d.doctor_id = ?;

-- DoctorScheduleServlet.java
SELECT visiting_day, start_time, end_time FROM Doctor_schedule WHERE doctor_id = ? ORDER BY start_time;
INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES (?, ?, ?, ?);

-- DoctorService.java
SELECT * FROM Doctor_schedule WHERE doctor_id = ? ORDER BY FIELD(visiting_day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- DoctorUpdateProfileServlet.java
SELECT d.* FROM Doctor d JOIN Users u ON d.doctor_id = u.user_id WHERE d.doctor_id = ?;
UPDATE Doctor SET first_name=?, last_name=?, gender=?, bio=?, fee=?, address=? WHERE doctor_id=?;
DELETE FROM User_Contact WHERE user_id = ? AND contact_type = ?;
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no);

-- Hospital.java
SELECT COUNT(*), AVG(rating) FROM Doctor WHERE hospital_id = ?;
SELECT COUNT(*) FROM Appointment WHERE appointment_date >= CURDATE() AND doctor_id IN (SELECT doctor_id FROM Doctor WHERE hospital_id = ?);
SELECT COUNT(*) FROM Medical_test WHERE hospital_id = ?;
SELECT appointment_status, COUNT(*) as count FROM Appointment WHERE doctor_id IN (SELECT doctor_id FROM Doctor WHERE hospital_id = ?) GROUP BY appointment_status;
SELECT CONCAT(d.first_name, ' ', d.last_name) as doctor_name, CONCAT(p.first_name, ' ', p.last_name) as patient_name, r.rating, r.comment, r.review_date FROM Reviews r JOIN Doctor d ON r.doctor_id = d.doctor_id JOIN Patient p ON r.patient_id = p.patient_id WHERE d.hospital_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC LIMIT 5;
SELECT doctor_id, display_name, specialty, rating, review_count, license_number FROM v_doctor_search WHERE hospital_id = ? ORDER BY last_name, first_name;
SELECT test_name, description, price FROM Medical_test WHERE hospital_id = ? ORDER BY test_name;
SELECT appointment_id, patient_name, doctor_name, specialty_name, appointment_date, appointment_time, appointment_status FROM v_appointment_details WHERE hospital_id = ? ORDER BY appointment_date DESC, appointment_time DESC;
SELECT CONCAT(d.first_name, ' ', d.last_name) as doctor_name, CONCAT(p.first_name, ' ', p.last_name) as patient_name, r.rating, r.comment, r.review_date FROM Reviews r JOIN Doctor d ON r.doctor_id = d.doctor_id JOIN Patient p ON r.patient_id = p.patient_id WHERE d.hospital_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC;
SELECT hospital_name, hospital_bio, address, website, latitude, longitude FROM Hospital WHERE hospital_id = ?;
UPDATE Hospital SET hospital_name = ?, hospital_bio = ?, address = ?, website = ? WHERE hospital_id = ?;
INSERT INTO Medical_test (hospital_id, test_name, price, description) VALUES (?, ?, ?, ?);
UPDATE Medical_test SET test_name = ?, price = ?, description = ? WHERE test_name = ? AND hospital_id = ?;
DELETE FROM Medical_test WHERE test_name = ? AND hospital_id = ?;
SELECT doctor_id, display_name, specialty, hospital_name, license_number FROM v_doctor_search WHERE (hospital_id IS NULL OR hospital_id != ?) AND display_name LIKE ?;
SELECT request_id FROM AffiliationRequest WHERE hospital_id = ? AND doctor_id = ? AND request_status = 'Pending';
INSERT INTO AffiliationRequest (hospital_id, doctor_id, request_status) VALUES (?, ?, 'Pending');
SELECT * FROM v_hospital_details WHERE hospital_id = ?;

-- HospitalManageProfileServlet.java
SELECT h.* FROM Hospital h WHERE h.hospital_id = ?;
UPDATE Hospital SET hospital_name=?, website=?, address=?, hospital_bio=? WHERE hospital_id=?;
DELETE FROM User_Contact WHERE user_id = ? AND contact_type = ?;
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no);

-- MedicalTest.java
INSERT INTO Medical_test (hospital_id, test_name, price, description) VALUES (?, ?, ?, ?);
UPDATE Medical_test SET price=?, description=? WHERE hospital_id=? AND test_name=?;
SELECT * FROM Medical_test WHERE hospital_id = ? AND test_name = ?;
DELETE FROM Medical_test WHERE hospital_id = ? AND test_name = ?;
SELECT * FROM Medical_test ORDER BY test_name;
SELECT * FROM Medical_test WHERE hospital_id = ? ORDER BY test_name;
SELECT * FROM Medical_test WHERE test_name LIKE ? OR description LIKE ? ORDER BY test_name;
SELECT * FROM Medical_test WHERE price >= ? AND price <= ? ORDER BY price;

-- MockDataGenerator.java
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?);
SELECT patient_id FROM Patient;
SELECT doctor_id FROM Doctor;
SELECT hospital_id FROM Hospital;
INSERT INTO Specialties (specialty_name) VALUES (?) ON DUPLICATE KEY UPDATE specialty_name=specialty_name;
INSERT INTO Admin (admin_id, first_name, last_name) VALUES (?, ?, ?);
INSERT INTO Hospital (hospital_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?);
SELECT hospital_id FROM Hospital;
SELECT specialty_id FROM Specialties;
INSERT INTO Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
INSERT INTO Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) VALUES (?, ?, ?, ?, ?);
SELECT patient_id FROM Patient;
SELECT doctor_id FROM Doctor;
INSERT INTO Reviews (patient_id, doctor_id, rating, comment, review_date) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE rating = VALUES(rating);
INSERT INTO Doctor_schedule (doctor_id, visiting_day, start_time, end_time) VALUES (?, ?, ?, ?);
INSERT INTO Medical_test (hospital_id, test_name, price, description) VALUES (?, ?, ?, ?);
INSERT INTO AffiliationRequest (hospital_id, doctor_id, request_status) VALUES (?, ?, ?);
INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?);
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE AffiliationRequest;
TRUNCATE TABLE Medical_test;
TRUNCATE TABLE Doctor_schedule;
TRUNCATE TABLE Reviews;
TRUNCATE TABLE Appointment;
TRUNCATE TABLE User_Contact;
TRUNCATE TABLE Doctor;
TRUNCATE TABLE Patient;
TRUNCATE TABLE Admin;
TRUNCATE TABLE Hospital;
TRUNCATE TABLE Specialties;
TRUNCATE TABLE Users;
SET FOREIGN_KEY_CHECKS = 1;

-- PastVisitsServlet.java
SELECT * FROM v_appointment_details WHERE user_id = ? AND appointment_status = 'Completed' ORDER BY appointment_date DESC, appointment_time DESC;
SELECT doctor_id FROM Reviews WHERE patient_id = ?;

-- Patient.java
INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude);
SELECT * FROM Patient WHERE patient_id = ?;

-- PatientViewDoctorProfileServlet.java
SELECT * FROM v_doctor_search WHERE doctor_id = ?;
SELECT r.*, p.first_name, p.last_name FROM Reviews r JOIN Patient p ON r.patient_id = p.patient_id WHERE r.doctor_id = ? AND r.is_moderated = TRUE ORDER BY r.review_date DESC;

-- ProfileServlet.java
SELECT contact_no FROM User_Contact WHERE user_id = ? AND contact_type = 'Primary' LIMIT 1;
SELECT COUNT(*) as total FROM Appointment WHERE patient_id = ?;

-- SearchHospitalDetails.java
SELECT COUNT(DISTINCT h.hospital_id) FROM Hospital h;
SELECT h.*, u.email, u.user_id JOIN Users u ON h.hospital_id = u.user_id;

-- SearchPageDetails.java
SELECT COUNT(DISTINCT d.doctor_id) FROM Doctor d LEFT JOIN Specialties s ON d.specialty_id = s.specialty_id;
SELECT d.doctor_id, u.user_id, CONCAT(d.first_name, ' ', d.last_name) as display_name, d.first_name, d.last_name, d.gender, d.license_number, d.exp_years as experience, d.bio, d.fee, d.address, d.latitude, d.longitude, d.rating, d.review_count, s.specialty_name as specialty, s.specialty_id, h.hospital_name, h.hospital_id, h.address as hospital_address, u.email, uc.contact_no AS appointment_contact;

-- SignUpServlet.java
SELECT specialty_id, specialty_name FROM Specialties ORDER BY specialty_name;
INSERT INTO Users (email, password, user_type) VALUES (?, ?, ?);
INSERT INTO Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
SELECT specialty_id FROM Specialties WHERE specialty_name = ?;
INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
INSERT INTO Hospital (hospital_id, hospital_name, hospital_bio, address, website, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?);
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?);

-- SubmitReviewServlet.java
INSERT INTO Reviews (patient_id, doctor_id, rating, comment, review_date, is_moderated) VALUES (?, ?, ?, ?, ?, ?);
SELECT patient_id FROM Patient WHERE user_id = ?;

-- UpdateProfileServlet.java
SELECT contact_no FROM User_Contact WHERE user_id = ? AND contact_type = 'Primary' LIMIT 1;
UPDATE Users SET email = ? WHERE user_id = ?;
INSERT INTO Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address);
DELETE FROM User_Contact WHERE user_id = ? AND contact_type = ?;
INSERT INTO User_Contact (user_id, contact_no, contact_type) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE contact_no = VALUES(contact_no);

-- User.java
SELECT user_id, user_type, password FROM Users WHERE email = ?;
SELECT email, user_type FROM Users WHERE user_id = ?;