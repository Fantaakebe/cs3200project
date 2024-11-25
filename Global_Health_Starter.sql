-- database
CREATE DATABASE IF NOT EXISTS global_healthcare;
USE global_healthcare;


-- tables
DROP TABLE IF EXISTS healthcare_workforce;
CREATE TABLE IF NOT EXISTS healthcare_workforce (
    country VARCHAR(100) PRIMARY KEY,
    medical_doctors_per_10k DECIMAL(10,2),
    medical_doctors_year INT,
    nursing_midwifery_per_10k DECIMAL(10,2),
    nursing_midwifery_year INT,
    dentists_per_10k DECIMAL(10,2),
    dentists_year INT,
    pharmacists_per_10k DECIMAL(10,2),
    pharmacists_year INT
);


CREATE TABLE IF NOT EXISTS maternal_mortality (
    IND_ID VARCHAR(50),
    IND_CODE VARCHAR(50),
    IND_UUID VARCHAR(50),
    IND_PER_CODE VARCHAR(50),
    DIM_TIME INT,
    DIM_TIME_TYPE VARCHAR(20),
    DIM_GEO_CODE_M49 VARCHAR(20),
    DIM_GEO_CODE_TYPE VARCHAR(20),
    DIM_PUBLISH_STATE_CODE VARCHAR(20),
    IND_NAME VARCHAR(100),
    GEO_NAME_SHORT VARCHAR(100),
    RATE_PER_100000_N DECIMAL(10,2),
    RATE_PER_100000_NL DECIMAL(10,2),
    RATE_PER_100000_NU DECIMAL(10,2),
    PRIMARY KEY (IND_ID, DIM_TIME, GEO_NAME_SHORT)
);

DROP TABLE IF EXISTS skilled_personnel_cleaned;
CREATE TABLE skilled_personnel_cleaned (
    IndicatorCode VARCHAR(50) NOT NULL,         
    Indicator VARCHAR(255) NOT NULL,           
    ValueType VARCHAR(50),                     
    ParentLocationCode VARCHAR(50),           
    ParentLocation VARCHAR(100),        
    LocationType VARCHAR(50),                  
    SpatialDimValueCode VARCHAR(50),           
    Location VARCHAR(100) NOT NULL,            
    PeriodType VARCHAR(50),                  
    Period VARCHAR(20),                        
    IsLatestYear VARCHAR(10),                  
    FactValueNumeric DECIMAL(10,2),            
    Value VARCHAR(50),                         
    FactComments TEXT,                        
    DateModified DATE                         
);


-- Regions Table
CREATE TABLE IF NOT EXISTS regions (
    region_id VARCHAR(50) PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL
);

-- Countries Table
CREATE TABLE IF NOT EXISTS countries (
    geo_code VARCHAR(50) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    region_id VARCHAR(50),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- Indicators Table
CREATE TABLE IF NOT EXISTS indicators (
    indicator_id INT AUTO_INCREMENT PRIMARY KEY,
    indicator_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Country Indicators Table
CREATE TABLE IF NOT EXISTS country_indicators (
    id INT AUTO_INCREMENT PRIMARY KEY,          
    geo_code VARCHAR(50) NOT NULL,              
    indicator_id INT NOT NULL,                 
    indicator_name VARCHAR(255),               
    value DECIMAL(10,2) NOT NULL,               
    data_year INT NOT NULL,                     
    FOREIGN KEY (geo_code) REFERENCES countries(geo_code) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (indicator_id) REFERENCES indicators(indicator_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE skilled_personnel_cleaned
ADD CONSTRAINT fk_skilled_countries
FOREIGN KEY (Location) REFERENCES countries(geo_code);

