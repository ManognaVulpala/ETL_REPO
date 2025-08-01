CREATE OR REPLACE FUNCTION safe_to_date(p_dob IN VARCHAR2)
RETURN DATE
IS
  v_date DATE;
BEGIN
  BEGIN
    -- Checks if DOB matches MM/DD/YYYY or DD/MM/YYYY
    IF REGEXP_LIKE(TRIM(p_dob), '^\d{2}/\d{2}/\d{4}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'MM/DD/YYYY');
    
    --  Checks if DOB matches YYYY-MM-DD (e.g. 1984-01-24)
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^\d{4}-\d{2}-\d{2}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'YYYY-MM-DD');
    
    -- Checks if DOB matches MM-DD-YYYY (e.g. 07-27-1989)
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^\d{2}-\d{2}-\d{4}$') THEN
      v_date := TO_DATE(TRIM(p_dob), 'MM-DD-YYYY');
    
    -- Checks if DOB matches Month DD, YYYY (e.g. October 20, 1970)
    ELSIF REGEXP_LIKE(TRIM(p_dob), '^[A-Za-z]+ \d{2}, \d{4}$') THEN
      v_date := TO_DATE(INITCAP(TRIM(p_dob)), 'Month DD, YYYY');
    
    ELSE
      RETURN NULL;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- If it is a invalid date, return NULL 
      RETURN NULL;
  END;
  RETURN v_date;
END;
/

CREATE TABLE PATIENT_CLEANED_DATA AS
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
  phone
FROM raw_patient_data;
drop table  PATIENT_CLEANED_DATA;
select * from PATIENT_CLEANED_DATA;