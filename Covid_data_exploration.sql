--Selecting data to use
select location, date, total_cases, total_deaths, population
from covid_datas
WHERE continent is not null


--Comparing total death and total cases in percentages
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 Death_Percentage
FROM covid_datas
WHERE continent is not null

--Comparing total cases and population in percentages
SELECT location, date, total_cases, population, (total_cases/population)*100 Cases_Percentage
FROM covid_datas
WHERE continent is not null

--Checking out the highest infected countries
SELECT location,population, MAX(total_cases) Highest_infected_countries, population, MAX((total_cases/population))*100 Percentage_of_infected_countries
FROM covid_datas
WHERE continent is not null
GROUP BY location,population
ORDER BY Percentage_of_infected_countries DESC


--Checking out countries with highest death rate
SELECT location, MAX(cast(total_deaths as int)) Death_rate
FROM covid_datas
WHERE continent is not null
GROUP BY location
ORDER BY Death_rate DESC

--Checking out the diffreence between population and maximum death rate per country(P.S D.R=Deaths rate while PP=Population)
SELECT location,Population, MAX(cast(total_deaths as int)) Death_rate, (Population-MAX(cast(total_deaths as int))) Diffrence_btw_DR_and_PP
FROM covid_datas
WHERE continent is not null
GROUP BY location, Population
ORDER BY Death_rate DESC

--Checking out continents with highest death rate
SELECT continent, MAX(cast(total_deaths as int)) Death_rate
FROM covid_datas
WHERE continent is not null
GROUP BY continent
ORDER BY Death_rate DESC

--comparing new cases and new deaths
SELECT date, SUM(new_cases) Total_cases,  SUM(cast(new_deaths as int)) Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 Cases_Percentage
FROM covid_datas
WHERE continent is not null
GROUP BY date

--Checking out the number of vaccination distributed by country and cummulative of vaccinations ditributed
SELECT continent, location, date, population, new_vaccinations
,SUM(cast(new_vaccinations as bigint)) over(order by location,date ROWS UNBOUNDED PRECEDING) Cummulative_vaccination
FROM covid_datas
WHERE continent is not null

--Checking out total vaccination against total cases and total deaths
SELECT continent, location, population,date, total_cases, total_vaccinations,total_deaths
FROM covid_datas
WHERE continent is not null
GROUP BY continent, location, population,date, total_cases, total_vaccinations, total_deaths

--Checking the total of perople vaccinated by location
SELECT continent, location, date, population, total_vaccinations, (total_vaccinations/population) People_Vaccinated
FROM covid_datas
WHERE continent is not null
GROUP BY continent, location, date, population,total_vaccinations

--Checking population against vaccinations(PP=population and VAC=vaccination)
WITH PPvsVAC (continent, location, date, population, new_vaccinations, Cummulative_vaccination)
as(
SELECT continent, location, date, population, new_vaccinations
,SUM(cast(new_vaccinations as bigint)) over(order by location,date ROWS UNBOUNDED PRECEDING) Cummulative_vaccination
FROM covid_datas
WHERE continent is not null
)
SELECT *, (Cummulative_vaccination/population) percentage_of_people_vaccinated
FROM PPvsVAC

--Creating views
Create view percentage_of_people_vaccinated as
WITH PPvsVAC (continent, location, date, population, new_vaccinations, Cummulative_vaccination)
as(
SELECT continent, location, date, population, new_vaccinations
,SUM(cast(new_vaccinations as bigint)) over(order by location,date ROWS UNBOUNDED PRECEDING) Cummulative_vaccination
FROM covid_datas
WHERE continent is not null
)
SELECT *, (Cummulative_vaccination/population) percentage_of_people_vaccinated
FROM PPvsVAC

CREATE VIEW People_Vaccinated as
SELECT continent, location, date, population, total_vaccinations, (total_vaccinations/population) People_Vaccinated
FROM covid_datas
WHERE continent is not null
GROUP BY continent, location, date, population,total_vaccinations

CREATE VIEW Comparison_between_cases_vaccinations_and_deaths as 
SELECT continent, location, population,date, total_cases, total_vaccinations,total_deaths
FROM covid_datas
WHERE continent is not null
GROUP BY continent, location, population,date, total_cases, total_vaccinations, total_deaths

CREATE VIEW Cummulative_vaccination as
SELECT continent, location, date, population, new_vaccinations
,SUM(cast(new_vaccinations as bigint)) over(order by location,date ROWS UNBOUNDED PRECEDING) Cummulative_vaccination
FROM covid_datas
WHERE continent is not null

CREATE VIEW Cases_Percentage AS
SELECT date, SUM(new_cases) Total_cases,  SUM(cast(new_deaths as int)) Total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 Cases_Percentage
FROM covid_datas
WHERE continent is not null
GROUP BY date

CREATE VIEW Death_rate as
SELECT continent, MAX(cast(total_deaths as int)) Death_rate
FROM covid_datas
WHERE continent is not null
GROUP BY continent
--ORDER BY Death_rate DESC

CREATE VIEW Diffrence_btw_DR_and_PP as
SELECT location,Population, MAX(cast(total_deaths as int)) Death_rate, (Population-MAX(cast(total_deaths as int))) Diffrence_btw_DR_and_PP
FROM covid_datas
WHERE continent is not null
GROUP BY location, Population
--ORDER BY Death_rate DESC

CREATE VIEW Death_rate_by_location as
SELECT location, MAX(cast(total_deaths as int)) Death_rate
FROM covid_datas
WHERE continent is not null
GROUP BY location
--ORDER BY Death_rate DESC


