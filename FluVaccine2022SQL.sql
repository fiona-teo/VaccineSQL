/* 
Below are a series of query statements that will assist in building a Tableau Dashboard to visualize 2022 flu vaccine information. 
All patients displayed are "active" at the hospital.

Components to consider
-Total % of patients that recieved a flu vaccine stratified by age, race, county, and overall
-Running total of flu vaccines over the course of 2022
-Total number of flu vaccines given in 2022
-List of patients that show whether or not they recieved the flu vaccine
*/

WITH active_patients AS
(
	SELECT DISTINCT patient 
	FROM encounters AS e
	JOIN patients AS pat
		ON e.patient = pat.id
	WHERE start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
		AND pat.deathdate IS null
		AND EXTRACT (month FROM age('2022-12-31', pat.birthdate)) >= 6
),

flu_shot_2022 AS
(
SELECT patient, min(date) AS earliest_flu_shot_2022 
FROM immunizations
WHERE code = '5302'
	AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
GROUP BY patient
) 

SELECT pat.birthdate,
	pat.race,
	pat.county,
	pat.id,
	pat.first,
	pat.last,
	flu.earliest_flu_shot_2022,
	flu.patient,
	CASE WHEN flu.patient IS NOT null THEN 1
	else 0
	END AS flu_shot_2022
FROM patients AS pat
LEFT JOIN flu_shot_2022 as flu
	ON pat.id = flu.patient
WHERE 1=1 
	AND pat.id IN (
		SELECT patient 
		FROM active_patients
)



