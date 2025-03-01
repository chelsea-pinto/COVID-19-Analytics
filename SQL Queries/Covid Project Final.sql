--FINAL PROJECT

-- new_deaths and new_cases columns contain a few negative values. Deaths and cases cannot be negative hence assuming these are data entry errors, we convert them into a positive values.

-- Validating if rows have negative deaths and cases
SELECT continent, location, date, new_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL  AND new_deaths < 0

SELECT continent, location, date, new_cases
FROM CovidDeaths
WHERE continent IS NOT NULL  AND new_cases < 0

-- Converting negative values into positive
UPDATE CovidDeaths
SET new_deaths = ABS(new_deaths)

UPDATE CovidDeaths
SET new_cases = ABS(new_cases)


-- CASE FATALITY RATE (INDIA AND GLOBAl)
-- Note: new_cases will be lagged by 9 days as we assume that death from a set number of new_cases will occur 9 days ps being infected.


-- Daily Case Fatality Rate (Not Cumulative) for a specific country
WITH CFR AS (
SELECT continent, location, date, LAG(new_cases,9) OVER(PARTITION BY location ORDER BY date) lagged_new_cases_9,new_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL AND location = 'India' 
)

SELECT *,(new_deaths/lagged_new_cases_9)*100 daily_case_fatality_rate
FROM CFR
WHERE lagged_new_cases_9 >0


-- Monthly Case Fatality Rate (Not Cumulative) for a specific country 
WITH CFR as(
SELECT location, CAST(FORMAT(date, 'Y')AS DATETIME) Month_Year, new_deaths, LAG(new_cases,9) OVER(PARTITION BY location ORDER BY date) lagged_new_cases_9
FROM CovidDeaths
WHERE continent IS NOT NULL AND location LIKE 'India'
)

SELECT location, FORMAT(Month_Year, 'Y') date, SUM(lagged_new_cases_9) total_monthly_cases, SUM(CAST(new_deaths AS INT)) total_monthly_deaths, SUM(CAST(new_deaths AS INT))/ SUM(lagged_new_cases_9)*100  monthly_case_fatality_rate
FROM CFR
GROUP BY location, Month_Year
order by location, Month_Year


-- Global Daily Case Fatality Rate (Not Cumulative)
WITH GCFR AS(
SELECT date,location, new_cases daily_cases,LAG(new_cases,9) OVER(PARTITION BY location ORDER BY date) as lagged_daily_cases_9, CAST(new_deaths AS INT) daily_deaths
FROM CovidDeaths
WHERE continent is not NULL
)

SELECT date, SUM(daily_cases) global_daily_cases,SUM(lagged_daily_cases_9) global_lagged_daily_cases_9, SUM(daily_deaths) global_daily_deaths, SUM(daily_deaths)/SUM(lagged_daily_cases_9)*100	global_daily_case_fatality_rate
FROM GCFR
WHERE lagged_daily_cases_9 > 0
GROUP BY date
ORDER BY date


-- Global Monthly Case Fatality Rate (Not Cumulative)
WITH GCFR AS(
SELECT CAST(FORMAT(date, 'Y') AS DATETIME) Month_Year, new_cases daily_cases,LAG(new_cases,9) OVER(PARTITION BY location ORDER BY date) lagged_daily_cases_9, CAST(new_deaths AS INT) daily_deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
)

SELECT FORMAT(Month_Year,'Y') date , SUM(daily_cases) global_monthly_cases,SUM(lagged_daily_cases_9) global_lagged_monthly_cases_9, SUM(daily_deaths) global_monthly_deaths, SUM(daily_deaths )/SUM(lagged_daily_cases_9)*100 global_monthly_case_fatality_rate
from GCFR
GROUP BY Month_Year
HAVING SUM(lagged_daily_cases_9) <> 0
ORDER BY Month_Year


--INCIDENCE RATE (INDIA AND GLOBAl)

-- Daily Incidence Rate (Not Cumulative) for a specific country  
SELECT date, continent, location, population, new_cases, new_cases/ population*100 daily_incidence_rate
FROM CovidDeaths
WHERE continent IS  NOT NULL AND location = 'India'
ORDER BY 3,1

-- Weekly Incidence Rate (Not Cumulative) for a specific country  
WITH IR AS(
SELECT DATEPART(YEAR, date) AS year, Datepart(WEEK, date) AS week, location, SUM(new_cases) new_cases, AVG(population) population
FROM CovidDeaths
WHERE continent IS NOT NULL AND location = 'India' 
GROUP BY location, DATEPART(YEAR, date),(Datepart(WEEK, date))
)

SELECT DATEADD(WEEK, week - 1, DATEADD(YEAR, year - 1900, 0)) AS date, location, new_cases, population, new_cases/population*100 as weekly_incidence_rate
FROM IR
ORDER BY location, date


-- Monthly Incidence Rate (Not Cumulative) for a specific country  
WITH IR AS(
SELECT DATEPART(YEAR, date) AS year, Datepart(MONTH, date) as month, location, SUM(new_cases) new_cases, AVG(population) population
FROM CovidDeaths
WHERE continent IS NOT NULL AND location = 'India'
GROUP BY location, DATEPART(YEAR, date),(Datepart(MONTH, date))
)

SELECT DATEADD(MONTH, month - 1, DATEADD(YEAR, year - 1900, 0)) AS date, location, new_cases, population, new_cases/population*100 as monthly_incidence_rate
FROM IR
ORDER BY location, date


--Global Daily Incidence Rate (Not Cumulative)
SELECT date, SUM(population) global_population, SUM(new_cases) global_daily_cases, SUM(new_cases)/ SUM(population)*100 global_daily_incidence_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
HAVING  SUM(new_cases) IS NOT NULL
ORDER BY date

--Global Weekly Incidence Rate (Not Cumulative)
WITH GIR AS(
SELECT DATEPART(WEEK, date) week, DATEPART(YEAR,date) year,SUM(new_cases) global_weekly_cases, SUM(DISTINCT(population)) global_population
FROM CovidDeaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
GROUP BY DATEPART(WEEK, date), DATEPART(YEAR,date)
)

SELECT DATEADD(WEEK, week - 1, DATEADD(YEAR, year - 1900, 0)) date, global_weekly_cases, global_population, global_weekly_cases/global_population *100 global_weekly_incidence_rate
FROM GIR
ORDER BY date

--Global Monthly Incidence Rate (Not Cumulative)

WITH GIR AS(
SELECT DATEPART(MONTH, date) month, DATEPART(YEAR,date) year, SUM(new_cases) global_monthly_cases, SUM(DISTINCT(population)) global_population
FROM CovidDeaths
WHERE continent IS NOT NULL and new_cases IS NOT NULL 
GROUP BY DATEPART(YEAR,date), DATEPART(MONTH, date)
)

SELECT DATEADD(MONTH, month - 1, DATEADD(YEAR, year - 1900, 0)) date,  global_monthly_cases,global_population, global_monthly_cases/global_population *100 global_monthly_incidence_rate
FROM GIR
ORDER BY date

-- Proportion of Vaccinated Population (INDIA AND GLOBAl)

--Proportion of Partially Vaccinated Population (Cumulative) for a specific country
SELECT d.date, d.continent, d.location, population, people_vaccinated cum_partially_vaccinated, (people_vaccinated/population)*100  percent_partially_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v 
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL AND population IS NOT NULL AND people_vaccinated IS NOT NULL AND d.location = 'India'
ORDER BY d.location, d.date

--Proportion of Fully Vaccinated Population (Cumulative) for a specific country
SELECT d.date, d.continent, d.location, population, people_fully_vaccinated cum_fully_vaccinated, (people_fully_vaccinated/population)*100  percent_fully_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v 
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL AND population IS NOT NULL AND people_fully_vaccinated IS NOT NULL AND d.location = 'India'
ORDER BY location, d.date


-- Total Global Population (where people_vaccinated data is provided)
SELECT SUM(DISTINCT(population))
FROM CovidDeaths d
JOIN CovidVaccinations v 
ON d.date = v.date
WHERE d.continent IS NOT NULL AND people_vaccinated IS NOT NULL

--Proportion of Partially Vaccinated Population Globally (Cumulative)
WITH DATA AS(
SELECT d.date, d.location, population, people_vaccinated,(CAST(people_vaccinated AS INT)- LAG(CAST(people_vaccinated AS INT),1) OVER(PARTITION BY d.location ORDER BY d.date)) new_people_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v 
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL AND people_vaccinated IS NOT NULL
),
GVP AS(
SELECT date, SUM(population) population, SUM(new_people_vaccinated) new_people_vaccinated
FROM DATA
GROUP BY date
)

SELECT date,population,new_people_vaccinated, SUM(new_people_vaccinated) OVER(order BY date) running_total_people_partially_vaccinated, SUM(new_people_vaccinated) OVER(ORDER BY date)/7758538199 *100 global_partially_vaccinated_population
FROM GVP
ORDER BY date

--Proportion of fully Vaccinated Population Globally (Cumulative)
WITH DATA AS(
SELECT d.date, d.location, people_fully_vaccinated, (CAST(people_fully_vaccinated AS INT)- LAG(CAST(people_fully_vaccinated AS INT),1) OVER(PARTITION BY d.location ORDER BY d.date)) new_people_fully_vaccinated
FROM CovidDeaths d
JOIN CovidVaccinations v 
ON d.date = v.date
AND d.location = v.location
WHERE d.continent IS NOT NULL AND people_fully_vaccinated IS NOT NULL
),
GVP AS(
SELECT date, SUM(new_people_fully_vaccinated) new_people_fully_vaccinated
FROM DATA
GROUP BY date
)

SELECT date,new_people_fully_vaccinated, SUM(new_people_fully_vaccinated) OVER(order BY date) running_total_people_fully_vaccinated, SUM(new_people_fully_vaccinated) OVER(ORDER BY date)/7758538199 *100 global_fully_vaccinated_population
FROM GVP
ORDER BY date

--Locations with Maximum Cases
SELECT location, AVG(population) population, SUM(new_cases) total_cases
FROM CovidDeaths
WHERE continent IS NOT NULL AND new_cases IS NOT NULL
GROUP BY location
ORDER BY total_cases DESC
