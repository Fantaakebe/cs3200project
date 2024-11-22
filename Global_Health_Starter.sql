-- Create database
CREATE DATABASE IF NOT EXISTS global_healthcare;
USE global_healthcare;

-- Create tables
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

-- Create revised table with simpler structure
CREATE TABLE skilled_birth_attendance (
    IndicatorCode VARCHAR(50),
    Indicator VARCHAR(255),
    ValueType VARCHAR(50),
    ParentLocationCode VARCHAR(50),
    ParentLocation VARCHAR(100),
    LocationType VARCHAR(50),
    SpatialDimValueCode VARCHAR(50),
    Location VARCHAR(100),
    PeriodType VARCHAR(50),
    Period VARCHAR(20),
    IsLatestYear VARCHAR(10),
    FactValueNumeric DECIMAL(10,2),
    Value VARCHAR(20),
    Language VARCHAR(10),
    DateModified VARCHAR(50)
);