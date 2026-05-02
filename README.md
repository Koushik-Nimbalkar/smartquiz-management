# Smart Quiz & Academic Performance Management System

## Project Overview
A production-ready full-stack web application designed for colleges and universities to manage secure quizzes and analyze academic performance.

## Technology Stack
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5, Chart.js
- **Backend**: Java (JSP + Servlets), JDBC
- **Database**: MySQL 8.0+
- **Server**: Apache Tomcat 9/10
- **IDE**: Eclipse IDE for Enterprise Java Web Developers

## Deployment Guide

### 1. Database Setup
1. Open **MySQL Workbench**.
2. Connect to your local database (user: `root`, password: `1234` or as per your config).
3. Open the `database/schema.sql` file provided in this project.
4. Run the entire script to create the `smartquiz_db` database and all required tables.
5. The script automatically inserts a default admin account:
   - **Email**: admin@smartquiz.com
   - **Password**: (You must register a new admin or hash a password. For testing, just register a new account on the UI and change its role to `ADMIN` in the database).

### 2. Eclipse Project Setup
1. Open **Eclipse**.
2. Go to **File > Import > General > Existing Projects into Workspace** (if `.project` exists) OR create a new **Dynamic Web Project** named `quizz management`.
3. If creating a new project:
   - Copy the `src` folder from this directory into your project.
   - Copy the contents of `src/main/webapp` into the `WebContent` or `src/main/webapp` folder of your Eclipse project.
4. **Dependencies**:
   - Download the **MySQL Connector/J** jar (`mysql-connector-java-8.x.x.jar`).
   - Place the `.jar` file into `src/main/webapp/WEB-INF/lib/` (or `WebContent/WEB-INF/lib/`).
   - Add the JAR to your build path: Right-click project > Build Path > Configure Build Path > Libraries > Add JARs.

### 3. Running Locally on Tomcat
1. Ensure Apache Tomcat is configured in Eclipse (Servers tab > New > Server > Apache Tomcat).
2. Right-click the project folder in Eclipse > **Run As > Run on Server**.
3. Select your Tomcat instance and click Finish.
4. The application will launch at `http://localhost:8080/quizz_management/index.jsp`.

### 4. Cloud Deployment (Production)
To deploy this to a live server (e.g., AWS, Heroku, DigitalOcean):
1. **Database**: Host your MySQL database on AWS RDS or ClearDB. Update the `DBConnection.java` URL, username, and password to point to the live database.
2. **War File**: Right-click project in Eclipse > **Export > WAR file**.
3. **Hosting**: 
   - Deploy the `.war` file to an AWS Elastic Beanstalk Tomcat environment.
   - Or deploy to any VPS with Tomcat installed by placing the `.war` into the `[tomcat]/webapps` folder.

## Key Features
- **Anti-Cheat Engine**: Tab-switch detection, right-click disable, keyboard shortcut blocking.
- **Smart Analytics**: Chart.js integration for student progress tracking.
- **Role-Based Access**: Secure routing via Servlet Filters for Students, Faculty, and Admins.
