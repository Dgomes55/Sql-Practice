--Queries done by Dylan Gomes

--Q1 "Show unique birth years from patients and order them by ascending."
SELECT DISTINCT YEAR(birth_date)

FROM patients

ORDER BY birth_date

--Q2 "Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output."
SELECT first_name

FROM patients

GROUP BY first_name

HAVING COUNT(first_name) = 1;

--Q3 "Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long."
SELECT patient_id,
first_name

FROM patients

WHERE first_name LIKE '%s'
AND first_name LIKE 's%'
AND LEn(first_name) >= 6

--Q4 "Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table."
SELECT patients.patient_id,
first_name,
last_name

FROM patients

JOIN admissions ON admissions.patient_id = patients.patient_id

WHERE diagnosis = 'Dementia'

--Q5 "Display every patient's first_name. Order the list by the length of each name and then by alphbetically"
SELECT first_name

FROM patients

ORDER BY LEN(first_name),
first_name

--Q6 "Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row."
SELECT
(SELECT COUNT(*) FROM patients WHERE gender = 'M') as count_of_males,
(SELECT COUNT(*) FROM patients WHERE gender = 'F') AS count_of_females

--Q7 "Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name."
SELECT first_name,
last_name,
allergies

FROM patients

WHERE allergies IN ('Penicillin', 'Morphine')

ORDER BY allergies,
first_name,
last_name

--Q8 "Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis."
SELECT patient_id,
diagnosis

FROM admissions

GROUP BY patient_id,
diagnosis

HAVING COUNT(*) > 1;

--Q9 "Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending."
SELECT city,
count(*) AS num_patients

FROM patients

GROUP BY city

ORDER BY num_patients DESC,
city ASC

--Q10 "Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor""
SELECT first_name,last_name,'Patient' AS role from patients
UNION ALL
SELECT first_name,last_name,'Doctor' fROM doctors

--Q11 "Show all allergies ordered by popularity. Remove NULL values from query."
SELECT allergies,
Count(*) AS total_diagnosis

FROM patients

WHERE allergies is not NULL

GROUP BY allergies

ORDER BY total_diagnosis DESC

--Q12 ""