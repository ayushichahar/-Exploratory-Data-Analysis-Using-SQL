-- Exploratory Data Analysis

select * from layoffs_staging2;


-- percentage laid off is not useful as we dont know how large the company is, we don't have column which says total number of employees
-- total laid off is useful

-- MAx
select max(total_laid_off)
from layoffs_staging2;


/* There are many companies who became bankrupt as they layoff entire workforce,
 highest laid off can be seen in Katerra (construction) followed by Butler Hospitality */

select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

-- Highest funding of bankrupt company, Britishvolt (transportation) followed by Quibi

select * from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- Which company layoff how many employee
-- Amazon followed by Google

select Company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- laid off start date to end date
-- 2020-03-11 to 2023-03-06
select min(date), max(date)
from layoffs_staging2;

-- which industry hit the most during this time
-- Manufacturing sector least hit
-- Consumer (shops) sector most hit sector

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- Which country layoff most number of employees
-- United States followed by India

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- On which Year layoff is most
-- 2023 saw most layoff
select year(date), sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 desc;

-- Which stage company layoff the most
-- Post IPO has seen the most laoff
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage 
order by 2 desc;


-- percentage laid off represents nothing

select company, sum(percentage_laid_off), avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


-- Progression of layoff/ Rolling sum of layoff

-- grouping layoffs month and year wise
select substring(date, 1,7) as month, sum(total_laid_off)
from layoffs_staging2
where substring(date, 1,7) is not null
group by substring(date, 1,7)
order by 1 asc;

-- Rolling sum of this
-- Month by month progression from year 2020 of layoff
With Rolling_Total as(
select substring(date, 1,7) as month, sum(total_laid_off) as Total_Off
from layoffs_staging2
where substring(date, 1,7) is not null
group by substring(date, 1,7)
order by 1 asc)
select month, total_off,
sum(Total_Off) over(order by month) as rolling_total
from Rolling_Total;

-- how much a company layoff per year


select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
order by company asc;

-- Rank which year a company laid off most employee, highest being 1

With Company_Year (company, years, total_laid_off) as
(
select company, year(date), sum(total_laid_off)
from layoffs_staging2
group by company, year(date)
), Company_Year_Rank as
(select *, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_year_Rank
where Ranking <= 5;
