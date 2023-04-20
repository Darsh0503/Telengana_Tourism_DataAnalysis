--  1)List down the top 10 districts that have the highest    number  of Domestic Visitors overall (2016-2019).


select district,sum(visitors) as visitors from domestic_visitors
group by district
order by visitors desc
limit 10



--  2) List down the top 3 districts based on compounded annual growth rate (CAGR) of visitors between 2016-2019.
 

Select district, avg(cagr) as CAGR_domestic
from
(
select district, year, visitors, visitors/prev_visitors - 1 as cagr
from
   (select *, lag(visitors, 1) over 
              (partition by district order by year) as prev_visitors
    from domestic_visitors ) t
) t1
group by district
order by CAGR_domestic asc
limit 3;


select district, avg(cagr) as CAGR_domestic
from
(
select district, year, visitors, visitors/prev_visitors - 1 as cagr
from
   (select *, lag(visitors, 1) over 
              (partition by district order by year) as prev_visitors
    from domestic_visitors ) t
) t1
group by district
order by CAGR_domestic desc
limit 3;



--  3) List down the Bottom 3 districts based on compounded annual growth rate (CAGR) of visitors between 2016-2019.



select district, avg(cagr) as CAGR_foreign
from
(
select district, year, visitors, visitors/prev_visitors - 1 as cagr
from
   (select *, lag(visitors, 1) over 
              (partition by district order by year) as prev_visitors
    from foreign_visitors ) t
) t1
group by district
order by CAGR_foreign desc
limit 3;

select district, avg(cagr) as CAGR_foreign
from
(
select district, year, visitors, visitors/prev_visitors - 1 as cagr
from
   (select *, lag(visitors, 1) over 
              (partition by district order by year) as prev_visitors
    from foreign_visitors ) t
) t1
group by district
order by CAGR_foreign asc
limit 3;


select month, sum(visitors) as Visitors from domestic_visitors
where district = "Hyderabad"
group by month
order by Visitors desc;

--  4) What are the peak and low season months for Hyderabad.

select month, sum(visitors) as Visitors from foreign_visitors
where district = "Hyderabad"
group by month
order by Visitors desc;



-- 5) Show the top & bottom 3 districts with high domestic to foreign tourist ratio.



With
CTEdomestic
as (
select district, sum(visitors) as tourist1 from domestic_visitors
group by district
order by tourist1 desc
),
CTEforeign
as 
(
select district, sum(visitors) as tourist2 from foreign_visitors
group by district
order by tourist2 desc
)

select district, round(tourist1/tourist2) as ratio
from CTEdomestic inner join
CTEforeign
using(district)
order by ratio desc



-- 6)  Show the Population to Policestation Ratio



With
CTEpolice_station
as (
select Districts,PoliceStations 
from domestic_visitors
),

CTEdemographic
as(
select Districts,sum(Males), sum(Females), sum(Males)+sum(Females) as Population from demographics
group by Districts
)

Select CTEpolice_station.Districts,CTEpolice_station.Polisce Stations, Population, (Poplation/PolisceStations) as Ratio
from CTEpolice_station
join
CTEdemographic
on CTEpolice_station.Districts = CTEdemographic.Districts
order by Ratio desc




-- 7) List down the top and bottom 5 districts based on “population to tourists footfall ratio in 2019.



With
CTEdomestic
as (
select district, sum(visitors) as tourist1 from domestic_visitors
where year = 2019
group by district
order by tourist1 desc
),
CTEforeign
as 
(
select district, sum(visitors) as tourist2 from foreign_visitors
where year = 2019
group by district
order by tourist2 desc
),
CTEdemographic
as
(
select Districts,sum(Males), sum(Females), round(sum(Males)+sum(Females)) as Population from demographics
group by Districts
)

Select CTEdomestic.district,round(tourist1+tourist2) as TotalVisitors, Population, (round(tourist1+tourist2)/population) as Footfall
from CTEdomestic 
join
CTEforeign
on CTEdomestic.district=CTEforeign.district
join
CTEdemographic
on CTEdomestic.district = CTEdemographic.Districts
order by Footfall desc



