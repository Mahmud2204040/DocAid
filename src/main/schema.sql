-- Healthcare Management System Database

-- 1. USERS table
create table Users (
    user_id int primary key auto_increment,
    email varchar(255) unique not null,
    password varchar(255) not null,
    user_type enum('Admin', 'Doctor', 'Hospital', 'Patient') not null
);


-- 2. SPECIALTIES table 
create table Specialties (
    specialty_id int primary key auto_increment,
    specialty_name varchar(100) unique not null
);

-- 3. HOSPITAL table (User Type)
create table Hospital (
    hospital_id int primary key,
    hospital_name varchar(255) not null,
    hospital_bio text,
    address text not null,
    website varchar(255),
    latitude decimal(10, 8),
    longitude decimal(11, 8),
    foreign key (hospital_id) references Users(user_id) on delete cascade
);

-- 4. ADMIN table (User Type)
create table Admin (
    admin_id int primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    foreign key (admin_id) references Users(user_id) on delete cascade
);


-- 5. PATIENT table (User Type)
create table Patient (
    patient_id int primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    gender enum('Male', 'Female') not null,
    date_of_birth date not null,
    blood_type enum('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    address text not null,
    latitude decimal(10, 8),
    longitude decimal(11, 8),
    foreign key (patient_id) references Users(user_id) on delete cascade
);

-- 6. DOCTOR table (User Type)
create table Doctor (
    doctor_id int primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    gender enum('Male', 'Female') not null,
    license_number varchar(50) unique not null,
    exp_years int not null check (exp_years >= 0),
    bio text,
    fee decimal(10, 2) not null check (fee >= 0),
    address text not null,
    latitude decimal(10, 8),
    longitude decimal(11, 8),
    specialty_id int,
    hospital_id int,

    rating decimal(3, 2) default 0.00,
    review_count int default 0,

    foreign key (doctor_id) references Users(user_id) on delete cascade,
    foreign key (specialty_id) references Specialties(specialty_id) on delete set null,
    foreign key (hospital_id) references Hospital(hospital_id) on delete set null
);

-- 7. USER CONTACT table (merged)
create table User_Contact (
    contact_id int primary key auto_increment,
    user_id int not null,
    contact_no varchar(20) not null,
    contact_type enum('Primary', 'Emergency', 'Appointment') not null,
    foreign key (user_id) references Users(user_id) on delete cascade,
    unique key unique_user_contact (user_id, contact_type)
);

-- 8. APPOINTMENT table
create table Appointment (
    appointment_id int primary key auto_increment,
    patient_id int not null,
    doctor_id int not null,
    appointment_date date not null,
    appointment_time time not null,
    appointment_status enum('Scheduled', 'Confirmed', 'Completed', 'Cancelled', 'No-Show') default 'Scheduled',
    foreign key (patient_id) references Patient(patient_id) on delete cascade,
    foreign key (doctor_id) references Doctor(doctor_id) on delete cascade,
    unique key unique_appointment (doctor_id, appointment_date, appointment_time)
);

-- 9. REVIEWS table
create table Reviews (
    review_id int primary key auto_increment,
    patient_id int not null,
    doctor_id int not null,
    admin_id int,
    rating int not null check (rating >= 1 and rating <= 5),
    comment text,
    review_date date not null,
    is_moderated boolean default false,
    foreign key (patient_id) references Patient(patient_id) on delete cascade,
    foreign key (doctor_id) references Doctor(doctor_id) on delete cascade,
    foreign key (admin_id) references Admin(admin_id) on delete set null,
    unique key unique_patient_doctor_review (patient_id, doctor_id)
);


-- 10. DOCTOR SCHEDULE table
create table Doctor_schedule (
    schedule_id int primary key auto_increment,
    doctor_id int not null,
    visiting_day enum('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') not null,
    start_time time not null,
    end_time time not null,
    foreign key (doctor_id) references Doctor(doctor_id) on delete cascade,
    unique key unique_doctor_day_time (doctor_id, visiting_day, start_time),
    check (start_time < end_time)
);

-- 11. MEDICAL TEST table
create table Medical_test (
    hospital_id int not null,
    test_name varchar(255) not null,
    price decimal(10, 2) not null check (price >= 0),
    description text,
    foreign key (hospital_id) references Hospital(hospital_id) on delete cascade,
    primary key (hospital_id, test_name)
);


-- 12. MONITORS table
create table Monitors (
    monitor_id int primary key auto_increment,
    admin_id int not null,
    foreign key (admin_id) references Admin(admin_id) on delete cascade
);

-- 13. AFFILIATION REQUEST table
create table AffiliationRequest (
    request_id int primary key auto_increment,
    hospital_id int not null,
    doctor_id int not null,
    request_status enum('Pending', 'Approved', 'Denied') default 'Pending',
    foreign key (hospital_id) references Hospital(hospital_id) on delete cascade,
    foreign key (doctor_id) references Doctor(doctor_id) on delete cascade,
    unique key unique_hospital_doctor_pending_request (hospital_id, doctor_id, request_status)
);



delimiter //

-- Trigger for Admin table
create trigger trg_admin_user_type_check
    before insert on Admin
    for each row
begin
    if (select user_type from Users where user_id = NEW.admin_id) != 'Admin' then
        signal sqlstate '45000' 
            set MESSAGE_TEXT = 'User type must be Admin for Admin table';
    end if;
end//

-- Trigger for Doctor table
create trigger trg_doctor_user_type_check
    before insert on Doctor
    for each row
begin
    if (select user_type from Users where user_id = NEW.doctor_id) != 'Doctor' then
        signal sqlstate '45000' 
            set MESSAGE_TEXT = 'User type must be Doctor for Doctor table';
    end if;
end//

-- Trigger for Hospital table
create trigger trg_hospital_user_type_check
    before insert on Hospital
    for each row
begin
    if (select user_type from Users where user_id = NEW.hospital_id) != 'Hospital' then
        signal sqlstate '45000' 
            set MESSAGE_TEXT = 'User type must be Hospital for Hospital table';
    end if;
end//

-- Trigger for Patient table
create trigger trg_patient_user_type_check
    before insert on Patient
    for each row
begin
    if (select user_type from Users where user_id = NEW.patient_id) != 'Patient' then
        signal sqlstate '45000' 
            set MESSAGE_TEXT = 'User type must be Patient for Patient table';
    end if;
end//

delimiter ;


-- SAMPLE DATA insert

insert into Specialties (specialty_name) values 
('Cardiology'), ('Dermatology'), ('Neurology'), ('Gynaecology'), ('Orthopedics');

insert into Users (email, password, user_type) values
('admin.dhanmondi@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Admin'),
('admin.gulshan@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Admin'),
('square.hospital@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Hospital'),
('evercare.hospital@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Hospital'),
('dr.rahim@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Doctor'),
('dr.fatima@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Doctor'),
('patient.karim@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Patient'),
('patient.anika@docaid.com', 'e10adc3949ba59abbe56e057f20f883e', 'Patient');

insert into Admin (admin_id, first_name, last_name) values
(1, 'Abdullah', 'Al Mamun'),
(2, 'Sadia', 'Afroze');

insert into Hospital (hospital_id, hospital_name, hospital_bio, address, website, latitude, longitude) values
(3, 'Square Hospital', 'A leading private hospital in Dhaka', '18/F, Bir Uttam Qazi Nuruzzaman Sarak, Panthapath, Dhaka 1205', 'www.squarehospital.com', 23.7508, 90.3842),
(4, 'Evercare Hospital Dhaka', 'A multi-disciplinary super-specialty tertiary care hospital', 'Plot: 81, Block: E, Bashundhara R/A, Dhaka 1229', 'www.evercarebd.com', 23.8163, 90.4247);

insert into Doctor (doctor_id, first_name, last_name, gender, license_number, exp_years, bio, fee, address, latitude, longitude, specialty_id, hospital_id) values
(5, 'Rahim', 'Uddin', 'Male', 'BMDC12345', 12, 'Cardiologist with a decade of experience', 1200.00, 'House 1, Road 2, Dhanmondi, Dhaka', 23.7465, 90.3765, 1, 3),
(6, 'Fatima', 'Begum', 'Female', 'BMDC67890', 7, 'Gynaecologist specializing in high-risk pregnancies', 1000.00, 'House 3, Road 4, Gulshan, Dhaka', 23.7925, 90.4078, 4, 4);

insert into Patient (patient_id, first_name, last_name, gender, date_of_birth, blood_type, address, latitude, longitude) values
(7, 'Karim', 'Hossain', 'Male', '1990-05-20', 'O+', 'House 5, Road 6, Mirpur, Dhaka', 23.8223, 90.3654),
(8, 'Anika', 'Tabassum', 'Female', '1995-11-12', 'B+', 'House 7, Road 8, Uttara, Dhaka', 23.8759, 90.3907);

insert into User_Contact (user_id, contact_no, contact_type) values
(7, '+8801712345678', 'Primary'),
(8, '+8801812345679', 'Primary'),
(5, '+8801912345680', 'Primary'),
(5, '+8801612345681', 'Appointment'),
(6, '+8801512345682', 'Primary'),
(6, '+8801312345683', 'Appointment'),
(3, '+88028144400', 'Primary'),
(3, '+8801713377775', 'Emergency'),
(4, '+88028431661', 'Primary'),
(4, '+8801713333337', 'Emergency');

insert into Appointment (patient_id, doctor_id, appointment_date, appointment_time, appointment_status) values
(7, 5, '2025-10-10', '11:00:00', 'Scheduled'),
(8, 6, '2025-10-12', '15:00:00', 'Confirmed');

insert into Reviews (patient_id, doctor_id, admin_id, rating, comment, review_date) values
(7, 5, 1, 5, 'very good doctor', '2025-09-15'),
(8, 6, null, 4, 'very experienced doctor.', '2025-09-18');

insert into Doctor_schedule (doctor_id, visiting_day, start_time, end_time) values
(5, 'Sunday', '10:00:00', '18:00:00'),
(5, 'Tuesday', '10:00:00', '18:00:00'),
(6, 'Monday', '09:00:00', '17:00:00'),
(6, 'Wednesday', '09:00:00', '17:00:00');

insert into Medical_test (hospital_id, test_name, price, description) values
(3, 'Complete Blood Count (CBC)', 500.00, 'A complete blood count (CBC) is a blood test used to evaluate your overall health and detect a wide range of disorders'),
(3, 'Chest X-Ray', 800.00, 'A chest X-ray is a fast and painless imaging test that produces images of the structures in and around your chest.'),
(4, 'MRI of Brain', 7000.00, 'Magnetic resonance imaging (MRI) of the brain is a safe and painless test that uses a magnetic field and radio waves to produce detailed images of the brain and the brain stem.');




-- TRIGGERS for RATING

delimiter //
create trigger trg_update_doctor_rating
    after insert on Reviews
    for each row
begin
    update Doctor 
    set rating = (
        select avg(rating) 
        from Reviews 
        where doctor_id = NEW.doctor_id
    ),
    review_count = (
        select count(*) 
        from Reviews 
        where doctor_id = NEW.doctor_id
    )
    where doctor_id = NEW.doctor_id;
end//


create trigger trg_update_doctor_rating_on_update
    after update on Reviews
    for each row
begin
    update Doctor 
    set rating = (
        select avg(rating) 
        from Reviews 
        where doctor_id = NEW.doctor_id
    ),
    review_count = (
        select count(*) 
        from Reviews 
        where doctor_id = NEW.doctor_id
    )
    where doctor_id = NEW.doctor_id;
end//

create trigger trg_update_doctor_rating_on_delete
    after delete on Reviews
    for each row
begin
    update Doctor
    set rating = ifnull((select avg(rating) from Reviews where doctor_id = OLD.doctor_id), 0),
        review_count = (select count(*) from Reviews where doctor_id = OLD.doctor_id)
    where doctor_id = OLD.doctor_id;
end//
delimiter ;



create view v_doctor_search as
select 
    d.doctor_id,
    d.doctor_id as user_id,
    concat(d.first_name, ' ', d.last_name) as display_name,
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
    d.rating,
    d.review_count,
    s.specialty_name as specialty,
    s.specialty_id,
    h.hospital_name,
    h.hospital_id,
    h.address as hospital_address,
    u.email,
    uc.contact_no as appointment_contact
from Doctor d
left join Specialties s on d.specialty_id = s.specialty_id
left join Hospital h on d.hospital_id = h.hospital_id
join Users u on d.doctor_id = u.user_id
left join User_Contact uc on d.doctor_id = uc.user_id and uc.contact_type = 'Appointment'
where u.user_type = 'Doctor';


create view v_appointment_details as
select 
    ap.appointment_id,
    p.patient_id as user_id,
    concat(p.first_name, ' ', p.last_name) as patient_name,
    concat(d.first_name, ' ', d.last_name) as doctor_name,
    h.hospital_id,
    h.hospital_name,
    s.specialty_name,
    ap.appointment_date,
    ap.appointment_time,
    ap.appointment_status
from Appointment ap
join Patient p on ap.patient_id = p.patient_id
join Doctor d on ap.doctor_id = d.doctor_id
left join Hospital h on d.hospital_id = h.hospital_id
left join Specialties s on d.specialty_id = s.specialty_id;


create view v_hospital_details as
select 
    h.hospital_id,
    h.hospital_id as user_id,
    h.hospital_name,
    h.hospital_bio,
    h.address,
    h.website,
    h.latitude,
    h.longitude,
    u.email,
    primary_uc.contact_no as primary_contact,
    emergency_uc.contact_no as emergency_contact
from Hospital h
join Users u on h.hospital_id = u.user_id
left join User_Contact primary_uc on h.hospital_id = primary_uc.user_id and primary_uc.contact_type = 'Primary'
left join User_Contact emergency_uc on h.hospital_id = emergency_uc.user_id and emergency_uc.contact_type = 'Emergency'
where u.user_type = 'Hospital';