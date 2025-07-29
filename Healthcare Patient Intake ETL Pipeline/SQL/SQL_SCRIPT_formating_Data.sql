--TO CONFIRM ANY OTHER DATE FORMATS ARE THERE THAT ARE MISSED
SELECT DOB FROM raw_patient_data
WHERE NOT (
  REGEXP_LIKE(DOB, '^\d{2}/\d{2}/\d{4}$') OR
  REGEXP_LIKE(DOB, '^\d{4}-\d{2}-\d{2}$') OR
  REGEXP_LIKE(DOB, '^\d{2}-\d{2}-\d{4}$') OR
  REGEXP_LIKE(DOB, '^[A-Za-z]+ \d{2}, \d{4}$')
);

--SUB QUERY TO CONVERT DATE FORMATS
CREATE OR REPLACE FUNCTION safe_to_date(p_dob IN VARCHAR2)
RETURN DATE
IS
  v_date DATE;
BEGIN
  BEGIN
  --CHECKING FOR ALL POSSIBLE DATE FORMATS
    IF REGEXP_LIKE(TRIM(p_dob), '^\d{2}/\d{2}/\d{4}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'MM/DD/YYYY');
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^\d{4}-\d{2}-\d{2}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'YYYY-MM-DD');
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^\d{2}-\d{2}-\d{4}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'MM-DD-YYYY');
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^[A-Za-z]+ \d{2}, \d{4}$') THEN
      v_date := TO_DATE(INITCAP(TRIM(p_dob)), 'Month DD, YYYY');
    ELSE
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  RETURN v_date;
END;
/
-- creating a view with cleaned and formated data using sub sql query for date
CREATE OR REPLACE VIEW PATIENT_DATA AS
SELECT 
  patientid,
  firstname,
  lastname,
  CONCAT(UPPER(firstname), LOWER(lastname)) AS name,
  CASE 
    WHEN UPPER(gender) IN ('MALE','M','MAN') THEN 'MALE'
    WHEN UPPER(gender) IN ('FEMALE','F','WOMAN','WOMEN') THEN 'FEMALE'
    ELSE 'UNKNOWN'
  END AS standard_gender,
  safe_to_date(dob) AS date_of_birth,
  PHONE
FROM raw_patient_data;

SELECT * FROM patient_data;
--creating a new table with cleaned and formated data using sub sql query for date
CREATE TABLE Patient_cleaned_Data AS
SELECT 
  patientid,
  firstname,
  lastname,
  CONCAT(UPPER(firstname), LOWER(lastname)) AS name,
  
  CASE 
    WHEN UPPER(gender) IN ('MALE','M','MAN') THEN 'MALE'
    WHEN UPPER(gender) IN ('FEMALE','F','WOMAN','WOMEN') THEN 'FEMALE'
    ELSE 'UNKNOWN'
  END AS standard_gender,
  
  dob,
  
  safe_to_date(dob) AS date_of_birth
FROM raw_patient_data;
--to drop a table
drop table PatientData;
select * from Patient_cleaned_Data;


--GET THE PATIENT DETAILS WITH firstname
SELECT * FROM Patient_cleaned_Data WHERE firstname='Olivia';

--GET THE PATIENT DETAILS WITH firstname and id 
SELECT * FROM Patient_cleaned_Data WHERE firstname='Olivia' and patientid=1018;

