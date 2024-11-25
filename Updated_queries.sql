use global_healthcare;

-- Identify countries with the highest skilled birth attendance rates
SELECT 
    s.Location AS Country,
    s.ParentLocation AS Region,
    s.FactValueNumeric AS Birth_Attendance_Rate,
    s.Period AS Year
FROM skilled_birth_attendance s
WHERE 
    s.FactValueNumeric IS NOT NULL 
    AND s.Location IS NOT NULL
    AND s.Period >= '2020'  -- recent 2020+
ORDER BY s.FactValueNumeric DESC
LIMIT 10;

-- Compare maternal mortality with healthcare workforce density
SELECT 
    hw.country,
    hw.medical_doctors_per_10k AS Doctors_per_10k,
    hw.nursing_midwifery_per_10k AS Nurses_per_10k,
    (hw.medical_doctors_per_10k + hw.nursing_midwifery_per_10k) AS Total_Healthcare_Workers_per_10k,
    mm.RATE_PER_100000_N AS Maternal_Mortality_Rate,
    mm.DIM_TIME AS Data_Year
FROM healthcare_workforce hw
JOIN maternal_mortality mm ON hw.country = mm.GEO_NAME_SHORT
WHERE 
    hw.medical_doctors_per_10k IS NOT NULL 
    AND hw.nursing_midwifery_per_10k IS NOT NULL
    AND mm.RATE_PER_100000_N IS NOT NULL
    -- Get the most recent year for each country
    AND mm.DIM_TIME = (
        SELECT MAX(DIM_TIME) 
        FROM maternal_mortality mm2 
        WHERE mm2.GEO_NAME_SHORT = mm.GEO_NAME_SHORT
    )
ORDER BY Total_Healthcare_Workers_per_10k DESC;


-- Countries with Highest and Lowest Mortality Rates
SELECT DISTINCT GEO_NAME_SHORT AS country, RATE_PER_100000_N AS maternal_mortality_rate
FROM maternal_mortality
WHERE RATE_PER_100000_N IS NOT NULL
ORDER BY maternal_mortality_rate DESC
LIMIT 5;

SELECT DISTINCT GEO_NAME_SHORT AS country, RATE_PER_100000_N AS maternal_mortality_rate
FROM maternal_mortality
WHERE RATE_PER_100000_N IS NOT NULL
ORDER BY maternal_mortality_rate ASC
LIMIT 5;


-- Rank countries by their overall healthcare metrics (doctors + nurses + skilled birth attendance)
SELECT 
    hw.country AS Country,
    hw.medical_doctors_per_10k AS Doctors_Per_10k,
    sba.FactValueNumeric AS Births_Attended_By_Skilled_Personnel,
    mm.RATE_PER_100000_N AS Maternal_Mortality_Rate
FROM 
    healthcare_workforce hw
JOIN 
    maternal_mortality mm
ON 
    hw.country = mm.GEO_NAME_SHORT
JOIN 
    skilled_birth_attendance sba
ON 
    hw.country = sba.Location
ORDER BY 
    hw.country;

-- Query 5: Correlate healthcare workforce density with maternal mortality.Create a calculated column showing ratios and join HealthWorkforce with MaternalMortality.
SELECT
    hw.country,
    hw.medical_doctors_per_10k,
    hw.nursing_midwifery_per_10k,
    hw.dentists_per_10k,
    hw.pharmacists_per_10k,
    (hw.medical_doctors_per_10k + hw.nursing_midwifery_per_10k + hw.dentists_per_10k + hw.pharmacists_per_10k) AS total_healthcare_workforce_per_10k,
    mm.RATE_PER_100000_N AS maternal_mortality_rate
FROM
    healthcare_workforce hw
JOIN
    maternal_mortality mm
ON
    hw.country = mm.GEO_NAME_SHORT
    limit 5;

-- Order regions by highest mortality rate ratio with duplicate handling
SELECT 
    sp.ParentLocation AS Region,
    sp.Location AS Country,
    MAX(DISTINCT mm.RATE_PER_100000_N) AS Highest_Maternal_Mortality_Rate
FROM 
    skilled_birth_attendance sp
LEFT JOIN 
    maternal_mortality mm ON sp.Location = mm.GEO_NAME_SHORT
    AND mm.RATE_PER_100000_N IS NOT NULL
    -- Consider only the most recent year for each country
    AND mm.DIM_TIME = (
        SELECT MAX(DIM_TIME)
        FROM maternal_mortality mm2
        WHERE mm2.GEO_NAME_SHORT = mm.GEO_NAME_SHORT
    )
WHERE 
    sp.ParentLocation IS NOT NULL
    AND sp.ParentLocation != ''
GROUP BY 
    sp.ParentLocation,
    sp.Location
HAVING 
    Highest_Maternal_Mortality_Rate IS NOT NULL
ORDER BY 
    Highest_Maternal_Mortality_Rate DESC;

