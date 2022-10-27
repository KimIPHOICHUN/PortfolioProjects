SELECT*
FROM PortfolioProject..CovidDeaths
WHERE  continent is not null
order by 3,4


--SELECT*
--FROM PortfolioProject..CovidVaccinations
-- WHERE  continent is not null
--order by 3,4

-- select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE  continent is not null
ORDER by 1,2

-- Looking at Total cases vs Total Deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE  continent is not null
ORDER by 1,2


-- Looking at Total cases vs Total Deaths in Japan
-- Show likehood of dying if you contract covid in Japan
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
Where Location = 'Japan' and continent is not null
ORDER by 1,2

-- Looking at Total cases vs Total Deaths in Canada
-- Show likehood of dying if you contract covid in Canada
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
Where Location = 'Canada' and continent is not null
ORDER by 1,2



-- Looking at the Total cases vs Population in JAPAN
--Show the % of population got COVID in JAPAN
-- Few rows are showing scientific numbers
SELECT Location, date, population, total_cases, (total_cases/population) *100 AS COVID_Percentage
FROM PortfolioProject..CovidDeaths
Where Location = 'Japan' and continent is not null
ORDER by 1,2

-- Looking at the Total cases vs Population in Canada
--Show the % of population got COVID in Canada
-- Few rows are showing scientific numbers
SELECT Location, date, population, total_cases, (total_cases/population) *100 AS COVID_Percentage
FROM PortfolioProject..CovidDeaths
Where Location = 'Canada' and continent is not null
ORDER by 1,2


-- Looking at contries with Highest Infection Rate vs Population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population) *100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--Where Location = 'Canada'
Group by location, population
ORDER by 4 DESC



-- LET'S BREAK THINGS DOWN BY CONTINENT
-- more accurate
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
Group by location
ORDER by 2 DESC




--Showing Country with Highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--Where Location = 'Canada'
WHERE continent is not null
Group by location
ORDER by 2 DESC


-- Showing contintents with the highest death count perpopulation
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
Group by continent
ORDER by 2 DESC

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY date
ORDER by 1,2

-- Global Total Cases
SELECT SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
--GROUP BY date
ORDER by 1,2




--***************** Vaccinations Table*******************

-- JOINING TABLE
SELECT * 
FROM PortfolioProject..CovidDeaths
JOIN PortfolioProject..CovidVaccinations
	ON CovidDeaths.location = CovidVaccinations.location
	AND CovidDeaths.date = CovidVaccinations.date


-- Looking at Total Population vs Vacinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
	, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



----USE CTE

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
	, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *,(RollingPeopleVaccinated/Population) * 100
FROM PopvsVac
ORDER BY 2,3



-- TEMP TABLE

CREATE Table #PercentPopulationVaccinated2
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vacciinations numeric,
RollingPeopleVaccinated numeric
) 

INSERT INTO #PercentPopulationVaccinated2
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
	, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3


SELECT *,(RollingPeopleVaccinated/Population) * 100
FROM #PercentPopulationVaccinated2
ORDER BY 2,3


-- DROP Table 
DROP Table if exists #PercentPopulationVaccinated


--CREATE Views to store date for later visulizations
Create View PercentPopulationVaccinated as

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
	, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3