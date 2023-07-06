--

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%nigeria%'
Order by 1,2

--Looking at total cases vs population

Select Location, date, total_cases, population, total_deaths, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%nigeria%'
Order by 1,2

--Looking at coutry with highest infection rate

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%nigeria%'
group by Location, population
Order by PercentpopulationInfected desc

 --Countries with highest death count per population
 Select Location, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..CovidDeaths
Where location like '%states%'
Group by Location
Order by totalDeathCount desc

Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Breaking it into coninent
Select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
Group by continent
Order by totalDeathCount desc

Select Location, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
Group by Location
Order by totalDeathCount desc

--Showing continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
Group by continent
Order by totalDeathCount desc


--Global Numbers

Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
--Group by date
Order by 1,2

With PopvsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVacinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVacinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacination vac
       On dea.location = vac.location
	   and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac

 --Temp Table
 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar (255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacination vac
       On dea.location = vac.location
	   and dea.date = vac.date
where dea.continent is not null
--order by 2,3

 Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated



 --Creating Views of Data Visuals

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVacinated/Population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacination vac
       On dea.location = vac.location
	   and dea.date = vac.date
where dea.continent is not null
--order by 2,3 

Select *
From PercentPopulationVaccinated