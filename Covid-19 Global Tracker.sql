

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..COVIDDeaths
order by 1,2

-- Total Cases vs Total Deaths
-- Mortality Rate in each country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS MortalityRate
FROM PortfolioProject..COVIDDeaths
order by 1,2

--Total Cases vs Population
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionRate
FROM PortfolioProject..COVIDDeaths
WHERE location like '%states%'
order by 1,2

--Total Infection Rate of each Country Based on Population
SELECT location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentInfectionRate
FROM PortfolioProject..COVIDDeaths
GROUP BY location, population
order by PercentInfectionRate desc

--Infection Rate of Every Country Based on Population and Date
SELECT location, date, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentInfectionRate
FROM PortfolioProject..COVIDDeaths
GROUP BY location, population, date
order by PercentInfectionRate desc


--Highest Morality Rate Per Capita
SELECT location, population, MAX(cast(total_deaths AS INT)) AS TotalDeaths, MAX((total_deaths/population))*100 AS MoralityRate
FROM PortfolioProject..COVIDDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
order by TotalDeaths desc

--Total Death Count Per Continent
SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeaths
FROM PortfolioProject..COVIDDeaths
WHERE continent IS NULL and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income','Lower middle income', 'Low income')
GROUP BY location
order by TotalDeaths desc

-- Global Total of Covid Cases/Deaths
SELECT date, SUM (new_cases) AS TotalCases, SUM(cast(new_deaths AS INT)) AS TotalDeaths, (SUM(cast(new_deaths AS INT))/SUM(new_cases))*100 as TotalMoralityRate
FROM PortfolioProject..COVIDDeaths
WHERE continent is not null
GROUP BY date
order by 1,2

--Total Global Vaccination Percentage
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..COVIDDeaths dea
JOIN PortfolioProject..COVIDVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
ORDER BY 2,3

--Vacciantion to Date
with popvsvac (continent, location, date, population, new_vaccinations, vaccinationtodate)
as 
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS VaccinationToDate
FROM PortfolioProject..COVIDDeaths dea
JOIN PortfolioProject..COVIDVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null)

--CTE
SELECT *, ((vaccinationtodate/population)*100) AS VaccinationPercentage
FROM popvsvac

--Temp Table
DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
VaccinationToDate numeric
)
INSERT INTO #PercentPopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS VaccinationtoDate
FROM PortfolioProject..COVIDDeaths dea
JOIN PortfolioProject..COVIDVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null

	SELECT *, ((vaccinationtodate/population)*100) AS VaccinationPercentage
FROM #PercentPopulationVaccinated

--Views

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS VaccinationtoDate
FROM PortfolioProject..COVIDDeaths dea
JOIN PortfolioProject..COVIDVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
	
	SELECT * FROM PercentPopulationVaccinated


CREATE VIEW GlobalDeathstoCovidCases as
SELECT date, SUM (new_cases) AS TotalCases, SUM(cast(new_deaths AS INT)) AS TotalDeaths, (SUM(cast(new_deaths AS INT))/SUM(new_cases))*100 as TotalMoralityRate
FROM PortfolioProject..COVIDDeaths
WHERE continent is not null
GROUP BY date

Select * FROM GlobalDeathstoCovidCases

CREATE VIEW TotalVaccinationsToDate as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(bigint, new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS VaccinationToDate
FROM PortfolioProject..COVIDDeaths dea
JOIN PortfolioProject..COVIDVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null)

	Select * FROM TotalVaccinationsToDate

CREATE VIEW InfectionRatePerCapita as
SELECT location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentInfectionRate
FROM PortfolioProject..COVIDDeaths
GROUP BY location, population

SELECT * FROM InfectionRatePerCapita


CREATE VIEW MortalityRatePerCapita as
SELECT location, population, MAX(cast(total_deaths AS INT)) AS TotalDeaths, MAX((total_deaths/population))*100 AS MoralityRate
FROM PortfolioProject..COVIDDeaths
WHERE continent IS NOT NULL
GROUP BY location, population

SELECT * FROM MortalityRatePerCapita

