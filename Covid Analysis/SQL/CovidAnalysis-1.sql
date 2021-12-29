USE Portfolio Project;


Select * from CovidDeaths
ORDER BY 3,4

---Select the data that we are going to work
Select location,date,total_cases,new_cases,total_deaths,population 
from CovidDeaths
ORDER BY 1,2

---Total Cases VS Total Deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
from CovidDeaths
WHERE location like '%India%'
ORDER BY 1,2

---Total Population VS Total Cases
Select location,date,population,total_cases,(total_cases/population)*100 AS DeathPercentage
from CovidDeaths
--WHERE location like '%India%'
ORDER BY 1,2

--Highest Country Effected
Select location,population,date, MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population))*100 AS PerPopulationInfected
from CovidDeaths
--Where location like '%states%'
Group By location,population,date
ORDER BY PerPopulationInfected desc

--Highest Country Total Deaths
Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is null
Group By location
ORDER BY TotalDeathCount desc

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is not null
Group By continent
ORDER BY TotalDeathCount desc

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is null
and location not in ('World','European Union','International')
Group By location
ORDER BY TotalDeathCount desc	




--Global Numbers

Select Sum(new_cases) as Totalcases, SUM(cast(new_deaths as int)) as TotalDeaths, 
Sum(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
from CovidDeaths
Where continent is not null
--Group By date
ORDER BY DeathPercentage Desc


---Total Population vs Total Vac
---Join Tables, using CTE


With PopvsVac (continent,date,population,location,new_vaccinations,RollingPeopleVaccinated)
as
(
Select da.continent,da.date,da.population,da.location,va.new_vaccinations,
SUM(CAST(VA.new_vaccinations as bigint)) OVER (Partition By DA.location ORDER BY DA.location,DA.date) as RollingPeopleVaccinated
from CovidDeaths as DA
Join CovidVaccinations as VA
ON DA.location = VA.location and DA.date = VA.date
WHERE da.continent is not null
--ORDER BY 2,3
)

Select *,(RollingPeopleVaccinated/population)*100 
From PopvsVac;



---Temp Table
DROP TABLE PercentPopulationVaccinated

Create Table PercentPopulationVaccinated
(
Continent nvarchar (255),
Date datetime,
Population numeric,
Location nvarchar(255),
NewVacinations numeric,
RollingPeopleVaccinated numeric
)
Insert into PercentPopulationVaccinated
Select da.continent,da.date,da.population,da.location,va.new_vaccinations,
SUM(CAST(VA.new_vaccinations as bigint)) OVER (Partition By DA.location ORDER BY DA.location,DA.date) as RollingPeopleVaccinated
from CovidDeaths as DA
Join CovidVaccinations as VA
ON DA.location = VA.location and DA.date = VA.date
WHERE da.continent is not null
--ORDER BY 2,3

Select * , (RollingPeopleVaccinated/Population)*100
from PercentPopulationVaccinated


---Creating Views 
Create View PopulationVac as 
Select da.continent,da.date,da.population,da.location,va.new_vaccinations,
SUM(CAST(VA.new_vaccinations as bigint)) OVER (Partition By DA.location ORDER BY DA.location,DA.date) as RollingPeopleVaccinated
from CovidDeaths as DA
Join CovidVaccinations as VA
ON DA.location = VA.location and DA.date = VA.date
WHERE da.continent is not null

Select * from PopulationVac




------------------------------------------------------------------------------------------------------------------------------
---Housing Data Analysis

Select * from Housingdata

---Standardize Date Format---
















