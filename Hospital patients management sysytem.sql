CREATE SCHEMA hospital;
IF OBJECT_ID('hosp.appointments') IS NOT NULL DROP TABLE hosp.appointments;
IF OBJECT_ID('hosp.admissions') IS NOT NULL DROP TABLE hosp.admissions;
IF OBJECT_ID('hosp.invoices') IS NOT NULL DROP TABLE hosp.invoices;
IF OBJECT_ID('hosp.staff') IS NOT NULL DROP TABLE hosp.staff;
IF OBJECT_ID('hosp.patients') IS NOT NULL DROP TABLE hosp.patients;
IF OBJECT_ID('hosp.departments') IS NOT NULL DROP TABLE hosp.departments;
CREATE TABLE hosp.departments (
    dept_id INT IDENTITY(1,1) PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE hosp.patients (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    gender VARCHAR(10),
    city VARCHAR(50)
)CREATE TABLE hosp.staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    role VARCHAR(20),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES hosp.departments(dept_id)
);
CREATE TABLE hosp.appointments (
    appt_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    dept_id INT,
    appt_datetime DATETIME,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES hosp.patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES hosp.staff(staff_id),
    FOREIGN KEY (dept_id) REFERENCES hosp.departments(dept_id)
)
CREATE TABLE hosp.admissions (
    admission_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    admit_datetime DATETIME,
    discharge_datetime DATETIME,
    dept_id INT,
    FOREIGN KEY (patient_id) REFERENCES hosp.patients(patient_id),
    FOREIGN KEY (dept_id) REFERENCES hosp.departments(dept_id)
);
CREATE TABLE hosp.invoices (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    invoice_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (patient_id) REFERENCES hosp.patients(patient_id)
);
INSERT INTO hosp.departments (dept_name) VALUES
('Cardiology'),('Neurology'),('Orthopedics'),
('Pediatrics'),('General Medicine'),
('Dermatology'),('ICU'),('Radiology'),
('ENT'),('Oncology');
INSERT INTO hosp.patients (first_name,last_name,dob,gender,city) VALUES
('Riya','Sharma','2000-04-12','F','Delhi'),
('Arjun','Patel','1998-10-05','M','Mumbai'),
('Neha','Khan','1985-07-20','F','Pune'),
('Rahul','Das','1995-03-10','M','Bangalore'),
('Priya','Singh','1992-06-15','F','Chennai');
INSERT INTO hosp.staff (first_name,last_name,role,dept_id) VALUES
('Asha','Verma','DOCTOR',1),
('Rohan','Iyer','DOCTOR',2),
('Meera','Das','DOCTOR',3),
('Kiran','Rao','DOCTOR',4),
('Sneha','Nair','DOCTOR',5);
INSERT INTO hosp.appointments (patient_id,doctor_id,dept_id,appt_datetime,status) VALUES
(1,1,1,GETDATE(),'COMPLETED'),
(2,2,2,GETDATE(),'NO_SHOW'),
(3,1,1,GETDATE(),'SCHEDULED'),
(4,3,3,GETDATE(),'COMPLETED'),
(5,4,4,GETDATE(),'COMPLETED');
INSERT INTO hosp.admissions (patient_id,admit_datetime,dept_id) VALUES
(1,GETDATE(),1),
(2,GETDATE(),2),
(3,GETDATE(),3);
INSERT INTO hosp.invoices (patient_id,amount,status) VALUES
(1,5000,'PAID'),
(2,8000,'PENDING'),
(3,3000,'PAID'),
(4,7000,'PENDING'),
(5,6000,'PAID');
SELECT * FROM hosp.patients;
SELECT doctor_id, COUNT(*) AS total
FROM hosp.appointments
GROUP BY doctor_id;
SELECT dept_id, COUNT(*) AS total
FROM hosp.appointments
GROUP BY dept_id;
SELECT * FROM hosp.invoices
WHERE status = 'PENDING';
SELECT patient_id, SUM(amount) AS total_spent
FROM hosp.invoices
GROUP BY patient_id
ORDER BY total_spent DESC;
INSERT INTO hosp.patients (first_name,last_name,dob,gender,city)
SELECT 
  'Patient'+CAST(number AS VARCHAR),
  'Test',
  DATEADD(YEAR, -(20 + number%30), GETDATE()),
  CASE WHEN number%2=0 THEN 'M' ELSE 'F' END,
  'City'+CAST(number AS VARCHAR)
FROM master..spt_values
WHERE type='P' AND number BETWEEN 1 AND 50;
INSERT INTO hosp.staff (first_name,last_name,role,dept_id)
SELECT 
  'Doctor'+CAST(number AS VARCHAR),
  'Test',
  'DOCTOR',
  (number%10)+1
FROM master..spt_values
WHERE type='P' AND number BETWEEN 1 AND 20;
INSERT INTO hosp.appointments (patient_id,doctor_id,dept_id,appt_datetime,status)
SELECT 
  ABS(CHECKSUM(NEWID()))%50 +1,
  ABS(CHECKSUM(NEWID()))%20 +1,
  ABS(CHECKSUM(NEWID()))%10 +1,
  DATEADD(DAY, -ABS(CHECKSUM(NEWID()))%30, GETDATE()),
  CASE 
    WHEN ABS(CHECKSUM(NEWID()))%5=0 THEN 'NO_SHOW'
    ELSE 'COMPLETED'
  END
FROM master..spt_values
WHERE type='P' AND number BETWEEN 1 AND 200;
INSERT INTO hosp.invoices (patient_id,amount,status)
SELECT 
  ABS(CHECKSUM(NEWID()))%50 +1,
  ABS(CHECKSUM(NEWID()))%10000,
  CASE 
    WHEN ABS(CHECKSUM(NEWID()))%2=0 THEN 'PAID'
    ELSE 'PENDING'
  END
FROM master..spt_values
WHERE type='P' AND number BETWEEN 1 AND 100;
SELECT dept_id, COUNT(*) AS visits
FROM hosp.appointments
GROUP BY dept_id
ORDER BY visits DESC;
SELECT FORMAT(appt_datetime,'yyyy-MM') AS month, COUNT(*)
FROM hosp.appointments
GROUP BY FORMAT(appt_datetime,'yyyy-MM');
SELECT SUM(amount) AS pending_amount
FROM hosp.invoices
WHERE status='PENDING';



