CREATE DATABASE mydataproject;

SELECT * FROM mydataproject.ocd_patient;
USE mydataproject;

-- 1. count number of patient by gender & their average obs score--
SELECT 
	 Gender,
       COUNT(`Patient ID`) AS patient_count,
       ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) AS avg_obs_score
FROM ocd_patient
GROUP BY Gender;

-- 2.From above, calculate the patient_count percentage--

WITH gender_count AS 
	 (SELECT 
		  Gender,
		  COUNT(`Patient ID`) AS patient_count,
		  ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) AS avg_obs_score
	 FROM ocd_patient
	 GROUP BY Gender),
total AS 
	 (SELECT 
		  SUM(patient_count)AS total_count
       FROM gender_count)
SELECT 
	 g.Gender,
       g.patient_count,
       g.avg_obs_score,
       ROUND((patient_count/t.total_count)*100, 2) AS percentage 
FROM gender_count g
JOIN total t; 

-- 3.count number of patient Mom 
set sql_safe_updates = 0;

SELECT `OCD Diagnosis Date` FROM ocd_patient
LIMIT 10;

SELECT 
	 DATE_FORMAT(`OCD Diagnosis Date`,'%Y-%m-01 00:00:00') AS month,
       COUNT(`Patient ID`) AS patient_count
FROM ocd_patient
WHERE `OCD Diagnosis Date` IS NOT NULL
GROUP BY month
ORDER BY month;
       
-- 4.find the most common obsesion type and its average obsession score

SELECT `Obsession Type`,
COUNT(`Patient ID`) AS patient_count,
ROUND(AVG(`Y-BOCS Score (Obsessions)`),2) AS avg_obs_score
FROM ocd_patient
WHERE `Obsession Type` IS NOT NULL 
GROUP BY `Obsession Type`
ORDER BY patient_count DESC
LIMIT 1;


-- 5.find the most common compulsion type and its average compulsion score--
SELECT `Compulsion Type`,
COUNT(`Patient ID`) AS patient_count,
ROUND(AVG(`Y-BOCS Score (Compulsions)`),2) AS avg_obs_score
FROM ocd_patient
WHERE `Compulsion Type` IS NOT NULL 
GROUP BY `Compulsion Type`
ORDER BY patient_count DESC
LIMIT 1;

