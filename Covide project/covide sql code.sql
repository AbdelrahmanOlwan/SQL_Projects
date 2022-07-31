--select * 
--from PortofolioProject..CovidVaccinations

select * 
from PortofolioProject..CovidDeaths
where continent is not null
order by 3,4

-- select the data 
select location, date, total_cases, new_cases, total_deaths, population
from PortofolioProject..CovidDeaths
where continent is not null
order by 1,2

-- total cases VS total death 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPersentage
from PortofolioProject..CovidDeaths
where continent is not null
order by 1,2

-- total cases VS population 
select location, date, total_cases, population, (total_cases/population)*100 as total_casesPersentage
from PortofolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at countries with highest infection Rate compare to population
select location,population, max (total_cases) as HighestInfection, max((total_cases/population))*100 as MaxCasesPersentage
from PortofolioProject..CovidDeaths
where continent is not null
group by  location, population
order by 4 desc


--countries with highest Death Count per popultion
select location,population, max(cast(total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths
where continent is not null
group by  location, population
order by TotalDeathCount desc


--continent with highest Death Count per popultion
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths
where continent is not null
group by  continent
order by TotalDeathCount desc


select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths
where continent is  null
group by  location
order by TotalDeathCount desc


--Global Numbers

select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as totalDeath, sum(cast(new_deaths as int))/ sum(new_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
where continent is not null
group by  date
order by DeathPercentage desc


select  sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as totalDeath, sum(cast(new_deaths as int))/ sum(new_cases)*100 as DeathPercentage
from PortofolioProject..CovidDeaths
where continent is not null
--group by  date
order by DeathPercentage desc


--Tootal poopulation VS Tootal Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date) as RolingPeopleVaccination
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccinations  vac
on dea.date = vac.date
and dea.location = vac.location
where dea.continent is not null
order by 2,3


































