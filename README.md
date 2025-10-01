# DocAid - Healthcare Management System

DocAid is a comprehensive web application designed to bridge the gap between patients, doctors, and hospitals. It provides a seamless platform for patients to find doctors, book appointments, and manage their healthcare, while offering robust dashboards for doctors, hospitals, and administrators to manage their respective activities.

## Key Features

### For Patients
- **Advanced Doctor Search**: Find doctors by name, specialty, or location.
- **Dynamic Filtering & Sorting**: Filter results by rating and availability, and sort by relevance, rating, name, or distance.
- **Geolocation**: Automatically uses the patient's location to calculate and sort by distance.
- **Appointment Booking**: Schedule appointments with available doctors.
- **User Profiles**: Manage personal profile and view past visits.
- **Doctor & Hospital Reviews**: Read and submit reviews and ratings for doctors.

### For Doctors
- **Dashboard**: View appointments and manage schedules.
- **Profile Management**: Update professional bio, experience, fees, and more.
- **Affiliation Requests**: Request to be affiliated with hospitals on the platform.
- **Review Management**: View patient feedback.

### For Hospitals
- **Dashboard**: Get an overview of hospital activities, appointments, and affiliated doctors.
- **Doctor Management**: Search for and manage doctors affiliated with the hospital.
- **Profile Management**: Update hospital details, bio, and contact information.
- **Medical Test Management**: List and manage medical tests offered by the hospital.

### For Administrators
- **System Monitoring**: View activity logs and system metrics.
- **User Management**: Oversee all users (Patients, Doctors, Hospitals).
- **Review Moderation**: Manage and moderate patient reviews.
- **Specialty Management**: Add or remove medical specialties from the platform.

## Technology Stack

- **Backend**: Java 21, Jakarta Servlets, JSP, JDBC
- **Frontend**: HTML, CSS, JavaScript, Bootstrap 5, jQuery
- **Database**: MySQL 8
- **Build Tool**: Apache Maven
- **Server**: Apache Tomcat

## Project Structure

```
D:\DocAid/
├── pom.xml                 # Maven configuration file
├── src/
│   ├── main/
│   │   ├── java/classes/     # Java source code (Servlets, Models, DB logic)
│   │   ├── resources/
│   │   │   └── db.properties # Database connection configuration
│   │   ├── webapp/           # Web application root
│   │   │   ├── ADMIN/        # JSP files for Admin dashboard
│   │   │   ├── DOCTOR/       # JSP files for Doctor dashboard
│   │   │   ├── HOSPITAL/     # JSP files for Hospital dashboard
│   │   │   ├── PATIENT/      # JSP files for Patient dashboard
│   │   │   ├── assets/       # CSS, JavaScript, and images
│   │   │   └── WEB-INF/      # Deployment descriptors (web.xml)
│   │   └── schema.sql        # Full database schema and sample data
│   └── test/                 # Test sources
└── README.md               # This file
```

## Getting Started

Follow these instructions to get a local copy of the project up and running.

### Prerequisites

- **Java Development Kit (JDK)**: Version 21 or newer.
- **Apache Maven**: To build the project.
- **MySQL Server**: To host the application database.
- **Apache Tomcat**: Or any other Jakarta-compatible servlet container.

### 1. Database Setup

1.  Open your MySQL client and create a new database.
    ```sql
    CREATE DATABASE docaid_db;
    ```
2.  Use the new database.
    ```sql
    USE docaid_db;
    ```
3.  Execute the `src/main/schema.sql` script. This will create all the necessary tables, views, triggers, and populate the database with sample data.
    ```sql
    -- In your MySQL client, run:
    source path/to/your/project/src/main/schema.sql;
    ```
4.  Configure the database connection by editing `src/main/resources/db.properties`. Update the `db.url`, `db.user`, and `db.password` to match your MySQL setup.
    ```properties
    db.url=jdbc:mysql://localhost:3306/docaid_db
    db.user=your_mysql_user
    db.password=your_mysql_password
    ```

### 2. Build the Project

1.  Open a terminal or command prompt in the root directory of the project (`D:\DocAid`).
2.  Run the following Maven command to build the project and create a WAR file.
    ```sh
    mvn clean install
    ```
3.  This will generate a `docaid.war` file in the `target/` directory.

### 3. Deployment

1.  Copy the `target/docaid.war` file to the `webapps/` directory of your Apache Tomcat installation.
2.  Start the Apache Tomcat server.
3.  The application will be deployed and accessible at `http://localhost:8080/docaid/`.

### 4. Sample Users

You can use the following sample credentials from the `schema.sql` file to log in and test the different roles. The password for all users is `123456`.

- **Admin**: `admin1@hospital.com`
- **Hospital**: `hospital1@medical.com`
- **Doctor**: `doctor1@medical.com`
- **Patient**: `patient1@email.com`