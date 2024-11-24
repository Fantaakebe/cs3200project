-- Query One: Countries with Highest and Lowest Mortality Rates
SELECT GEO_NAME_SHORT AS country, RATE_PER_100000_N AS maternal_mortality_rate
FROM maternal_mortality
WHERE RATE_PER_100000_N IS NOT NULL
ORDER BY maternal_mortality_rate DESC
LIMIT 5;

SELECT GEO_NAME_SHORT AS country, RATE_PER_100000_N AS maternal_mortality_rate
FROM maternal_mortality
WHERE RATE_PER_100000_N IS NOT NULL
ORDER BY maternal_mortality_rate ASC
LIMIT 5;

-- TEST COMMMENT 