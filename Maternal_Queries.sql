-- Query One: Countries with Highest and Lowest Mortality Rates
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


-- CS3200 project 
-- Query 2

-- Query 2: Compare skilled birth attendance rates with maternal mortality. - Fanta Kébé
-- Join SkilledBirthAttendance and MaternalMortality


DROP PROCEDURE IF EXISTS compare_attendance_mortality;

DELIMITER //
CREATE PROCEDURE compare_attendance_mortality(
    IN year_param INT,            -- Optional: Year filter
    IN country_param VARCHAR(100) -- Optional: Country filter
)
BEGIN
    -- Validate inputs
    IF year_param IS NULL THEN
        SET year_param = 0; -- Default to 0 to ignore year filter
    END IF;
    IF country_param IS NULL THEN
        SET country_param = ''; -- Default to empty string to ignore country filter
    END IF;
    
    -- Join tables and compare metrics
    SELECT 
        s.Location AS Country,
        s.FactValueNumeric AS SkilledBirthAttendanceRate,
        m.RATE_PER_100000_N AS MaternalMortalityRate,
        s.Period AS AttendanceYear,
        m.DIM_TIME AS MortalityYear
    FROM 
        skilled_birth_attendance s
    JOIN 
        maternal_mortality m
    ON 
        s.Location = m.GEO_NAME_SHORT
    WHERE 
        (year_param = 0 OR s.Period = year_param)  -- Apply year filter if provided
        AND (country_param = '' OR s.Location = country_param)  -- Apply country filter if provided
        AND s.FactValueNumeric IS NOT NULL 
        AND m.RATE_PER_100000_N IS NOT NULL
    ORDER BY 
        MaternalMortalityRate DESC; -- Order by mortality rate for better comparison
END //
DELIMITER ;

INSERT INTO skilled_birth_attendance (Location, FactValueNumeric, Period)
VALUES 
('United States', 98.5, 2020),
('Nigeria', 43.2, 2020);

INSERT INTO maternal_mortality (IND_ID, DIM_TIME, GEO_NAME_SHORT, RATE_PER_100000_N)
VALUES 
('MM_USA', 2020, 'United States', 23.8),
('MM_NGA', 2020, 'Nigeria', 917.0);


-- Query 3
DROP PROCEDURE IF EXISTS identify_low_density_regions;

DELIMITER //
CREATE PROCEDURE identify_low_density_regions(
    IN year_param INT,              -- Optional: Year filter
    IN limit_param INT              -- Number of regions to return
)
BEGIN
    -- Handle default values
    IF year_param IS NULL THEN
        SET year_param = 0; -- Default to 0 to ignore year filter
    END IF;
    
    IF limit_param IS NULL THEN
        SET limit_param = 5; -- Default to 5 if not provided
    END IF;

    -- Aggregate healthcare workforce density by region
    SELECT 
        h.region AS Region,
        AVG(h.medical_doctors_per_10k) AS AvgDoctorsPer10k,
        AVG(h.nursing_midwifery_per_10k) AS AvgNursesPer10k,
        (AVG(h.medical_doctors_per_10k) + AVG(h.nursing_midwifery_per_10k)) AS TotalWorkforceDensity
    FROM 
        healthcare_workforce h
    WHERE 
        (year_param = 0 OR h.medical_doctors_year = year_param)  -- Apply year filter if provided
    GROUP BY 
        h.region
    ORDER BY 
        TotalWorkforceDensity ASC  -- Lowest density first
    LIMIT 
        limit_param; -- Limit the number of regions returned
END //
DELIMITER ;


-- QUERY 6
-- Order region by highest mortality rate ratio
SELECT 
    sp.ParentLocation AS Region,
    MAX(mm.RATE_PER_100000_N) AS Highest_Maternal_Mortality_Rate
FROM 
    Skilled_Personnel_cleaned sp
JOIN 
    Maternal_Mortality_Rate_cleaned mm
ON 
    sp.Location = mm.GEO_NAME_SHORT
GROUP BY 
    sp.ParentLocation
ORDER BY 
    Highest_Maternal_Mortality_Rate DESC;

