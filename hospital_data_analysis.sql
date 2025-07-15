use online_store_books


-- Drop the table if it exists
DROP TABLE IF EXISTS hospital_data_temp;

-- Create the hospital_data table
CREATE TABLE hospital_data_temp (
    hospital_name VARCHAR(100),
    location VARCHAR(100),
    department VARCHAR(100),
    doctor_count INT,
    patients_count INT,
    admission VARCHAR(20),
    discharge VARCHAR(20),
    medical_expenses FLOAT
);



-- View the structure of the table
DESCRIBE hospital_data_temp;

-- View all rows (after importing data)
SELECT * FROM hospital_data_temp;
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.0/Uploads/Hospital_Data.csv'
INTO TABLE hospital_data_temp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select * from hospital_data_temp
#Write an SQL query to find the total number of patients across all hospitals.
select sum(patients_count) as total_patients from hospital_data_temp
#Retrieve the average count of doctors available in each hospital.
select hospital_name,avg(doctor_count) as average_doctors from hospital_data_temp group by hospital_name
#Find the top 3 hospital departments that have the highest number of patients.
SELECT department, SUM(patients_count) AS total_patients
FROM hospital_data_temp
GROUP BY department
ORDER BY total_patients DESC
LIMIT 3;

#Identify the hospital that recorded the highest medical expenses.
select hospital_name from hospital_data_temp order by medical_expenses desc limit 1
#Calculate the average medical expenses per day for each hospital.
select hospital_name,avg(medical_expenses) as avg_medical_expenses from hospital_data_temp group by hospital_name
#Find the patient with the longest stay by calculating the difference between Discharge Date and Admission Date.
select hospital_name,datediff(admission,discharge) as stay_duration from hospital_data_temp order by stay_duration desc limit 1

SELECT hospital_name,
       DATEDIFF(
           STR_TO_DATE(discharge, '%d-%m-%Y'),
           STR_TO_DATE(admission, '%d-%m-%Y')
       ) AS stay_duration
FROM hospital_data_temp
WHERE discharge IS NOT NULL AND admission IS NOT NULL
ORDER BY stay_duration DESC
LIMIT 1;

#Count the total number of patients treated in each city.
select location,sum(patients_count) as total_patients from hospital_data_temp group by location 
#Calculate the average number of days patients spend in each department.
SELECT department, 
       AVG(DATEDIFF(
           STR_TO_DATE(discharge, '%d-%m-%Y'),
           STR_TO_DATE(admission, '%d-%m-%Y')
       )) AS avg_stay_days
FROM hospital_data_temp
WHERE discharge IS NOT NULL AND admission IS NOT NULL
GROUP BY department;
#Find the department with the least number of patients
SELECT department, SUM(patients_count) AS total_patients
FROM hospital_data_temp
GROUP BY department
ORDER BY total_patients ASC
LIMIT 1;
#Group the data by month and calculate the total medical expenses for each month.
SELECT 
    DATE_FORMAT(STR_TO_DATE(admission, '%d-%m-%Y'), '%Y-%m') AS month_year,
    SUM(medical_expenses) AS total_medical_expenses
FROM hospital_data_temp
WHERE admission IS NOT NULL AND medical_expenses IS NOT NULL
GROUP BY month_year
ORDER BY month_year;

