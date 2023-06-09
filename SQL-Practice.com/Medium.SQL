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

--Q12 "Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date."
SELECT first_name,
last_name,
birth_date

FROM patients

WHERE YEAR(birth_date) between 1970 AND 1979

ORDER BY birth_date ASC

--Q13 "We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane"
SELECT
concat (upper(last_name), ',',LOWER(first_name)) as full_name

FROM patients

ORDER BY first_name DESC

--Q14 "Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000."
SELECT province_id,
SUM(height) as sum_height

FROM patients

group by province_id
Having sum_height >= 7000

--Q15 "Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'"
SELECT (max(weight) - min(weight)) as weight_difference

FROM patients

WHERE last_name = 'Maroni'

--Q16 "Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions."
SELECT DAY(admission_date)as day_number,
COUNT(*) as admissions_per_day

FROM admissions

GROUP BY day_number
ORDER BY admissions_per_day DESC

--Q17 "Show all columns for patient_id 542's most recent admission_date."
select *

FROM admissions

WHERE patient_id = 542

GROUP BY patient_id

ORDER BY MAX(admission_date)

--Q18 "Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria: 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19. 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters."
SELECT patient_id,
attending_doctor_id,
diagnosis

FROM admissions

WHERE (
attending_doctor_id IN (1,5,19) AND patient_id % 2 <> 0
)
OR
(
attending_doctor_id LIKE '%2%' AND len(patient_id) = 3
)

--Q19 "Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor."
SELECT first_name,
last_name,
count(*) AS admissions_total

FROM admissions

JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id

GROUP BY doctor_id

--Q20 "For each doctor, display their id, full name, and the first and last admission date they attended."
SELECT doctor_id,
CONCAT(first_name, ' ', last_name) AS full_name,
MIN(admission_date) AS first_admission,
MAX(admission_date) AS last_admission

FROM admissions

JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id

GROUP BY doctor_id

--Q21 "Display the total amount of patients for each province. Order by descending."
SELECT count(*) AS patients_count,
province_name

FROM patients

JOIN province_names ON province_names.province_id = patients.province_id

GROUP BY province_name
ORDER by patients_count DESC

--Q22 "For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem."
SELECT CONCAT(patients.first_name,' ',patients.last_name) AS patient_full_name,
diagnosis,
CONCAT(doctors.first_name,' ', doctors.last_name) AS doctor_full_name

FROM patients

JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id
JOIN admissions ON admissions.patient_id = patients.patient_id

--Q23 "display the number of duplicate patients based on their first_name and last_name."
SELECT first_name,
last_name,
count(*) AS count_of_dupes

FROM patients

GROUP BY
first_name,
last_name

HAVING COUNT(*) > 1

--Q24 "Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205."
SELECT CONCAT(first_name,' ', last_name) as full_name,
ROUND(height / 30.48, 1) as height_feet,
ROUND(weight * 2.205, 0) AS weight_pounds,
birth_date,

CASE
	WHEN gender = 'M' THEN 'MALE'
    ELSE 'FEMALE'
END AS gender_type

FROM patients
