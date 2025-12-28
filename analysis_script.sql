-- ==========================================
-- 1. DATABASE SETUP & DATA LOADING
-- ==========================================
SET GLOBAL local_infile = 1;

CREATE SCHEMA IF NOT EXISTS ndap;
USE ndap;

CREATE TABLE IF NOT EXISTS FarmersInsuranceData (
     rowID INT PRIMARY KEY,
     srcYear INT,
     srcStateName VARCHAR(255),
     srcDistrictName VARCHAR(255),
     InsuranceUnits INT,
     TotalFarmersCovered INT,
     ApplicationsLoaneeFarmers INT,
     ApplicationsNonLoaneeFarmers INT,
     InsuredLandArea FLOAT,
     FarmersPremiumAmount FLOAT,
     StatePremiumAmount FLOAT,
     GOVPremiumAmount FLOAT,
     GrossPremiumAmountToBePaid FLOAT,
     SumInsured FLOAT,
     PercentageMaleFarmersCovered FLOAT,
     PercentageFemaleFarmersCovered FLOAT,
     PercentageOthersCovered FLOAT,
     PercentageSCFarmersCovered FLOAT,
     PercentageSTFarmersCovered FLOAT,
     PercentageOBCFarmersCovered FLOAT,
     PercentageGeneralFarmersCovered FLOAT,
     PercentageMarginalFarmers FLOAT,
     PercentageSmallFarmers FLOAT,
     PercentageOtherFarmers FLOAT,
     YearCode INT,
     Year_ VARCHAR(255),
     Country VARCHAR(255),
     StateCode INT,
     DistrictCode INT,
     TotalPopulation INT,
     TotalPopulationUrban INT,
     TotalPopulationRural INT,
     TotalPopulationMale INT,
     TotalPopulationMaleUrban INT,
     TotalPopulationMaleRural INT,
     TotalPopulationFemale INT,
     TotalPopulationFemaleUrban INT,
     TotalPopulationFemaleRural INT,
     NumberOfHouseholds INT,
     NumberOfHouseholdsUrban INT,
     NumberOfHouseholdsRural INT,
     LandAreaUrban FLOAT,
     LandAreaRural FLOAT,
     LandArea FLOAT
);

-- Note: Path must be updated to your local directory or a relative path
LOAD DATA LOCAL INFILE "data.csv"
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'           
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS;

-- ==========================================
-- 2. ANALYSIS SOLUTIONS (Q1 - Q26)
-- ==========================================

-- Q1. Retrieve the names of all states (srcStateName) from the dataset.
select distinct(srcStateName) from farmersinsurancedata;

-- Q2. Retrieve the total number of farmers covered (TotalFarmersCovered) 
--     and the sum insured (SumInsured) for each state (srcStateName), ordered by TotalFarmersCovered in descending order.
select sum(TotalFarmersCovered) as state_wise_farmers_covered, sum(SumInsured) as sum_insured, srcStateName
from farmersinsurancedata
group by srcStateName
order by state_wise_farmers_covered desc;

-- Q3. Retrieve all records where Year is '2020'.
select * from farmersinsurancedata where YearCode=2020;

-- Q4. Retrieve all rows where the TotalPopulationRural is greater than 1 million and the srcStateName is 'HIMACHAL PRADESH'.
select * from farmersinsurancedata
where TotalPopulationRural>1000000 and srcStateName='HIMACHAL PRADESH';

-- Q5. Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount for each district in the year 2018, 
-- 		 and display the results ordered by FarmersPremiumAmount in ascending order.
select srcStateName,srcDistrictName,sum(FarmersPremiumAmount) as sum_of_premium_amount
from farmersinsurancedata
where YearCode=2018
group by srcStateName,srcDistrictName
order by sum_of_premium_amount asc;

-- Q6. Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of premiums (GrossPremiumAmountToBePaid) for each state (srcStateName) 
-- 		 where the insured land area (InsuredLandArea) is greater than 5.0 and the Year is 2018.
select sum(TotalFarmersCovered) as sum_of_farmers_covered, sum(GrossPremiumAmountToBePaid) as sum_of_premiums, srcStateName
from farmersinsurancedata
where InsuredLandArea>5.0 and YearCode=2018
group by srcStateName;

-- Q7. Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
select avg(InsuredLandArea) as average_insured_land_area, srcYear
from farmersinsurancedata
group by srcYear;

-- Q8. Calculate the total number of farmers covered (TotalFarmersCovered) for each district (srcDistrictName) where Insurance units is greater than 0.
select sum(TotalFarmersCovered) as sum_of_farmers_covered, srcDistrictName 
from farmersinsurancedata
where InsuranceUnits>0
group by srcDistrictName;

-- Q9. For each state (srcStateName), calculate the total premium amounts (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount) 
-- 		 and the total number of farmers covered (TotalFarmersCovered). Only include records where the sum insured (SumInsured) is greater than 500,000 (remember to check for scaling).
select srcStateName, sum(FarmersPremiumAmount), sum(StatePremiumAmount), sum(GOVPremiumAmount), sum(TotalFarmersCovered)
from farmersinsurancedata
where SumInsured>5
group by srcStateName;

-- Q10. Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation in the year 2020.
select srcDistrictName, sum(TotalPopulation) as district_wise_population 
from farmersinsurancedata
where YearCode=2020
group by srcDistrictName
order by district_wise_population desc
limit 5;

-- Q11. Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts with the lowest non-zero FarmersPremiumAmount, 
-- 		  ordered by insured sum and then the FarmersPremiumAmount.
select srcStateName, srcDistrictName, sum(SumInsured), sum(FarmersPremiumAmount)
from farmersinsurancedata
where FarmersPremiumAmount>0
group by srcDistrictName, srcStateName
order by 3, 4 asc
limit 10;

-- Q12. Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the ratio of insured farmers (TotalFarmersCovered) to the total population (TotalPopulation) is highest. 
-- 		  Sort the results by the ratio in descending order.
select srcStateName, srcYear, sum(TotalFarmersCovered)/sum(TotalPopulation) as ratio
from farmersinsurancedata
group by srcStateName, srcYear
order by ratio desc
limit 3;

-- Q13. Create StateShortName by retrieving the first 3 characters of the srcStateName for each unique state.
select distinct(srcStateName), substring(srcStateName, 1, 3) as StateShortName
from farmersinsurancedata;

-- Q14. Retrieve the srcDistrictName where the district name starts with 'B'.
select srcDistrictName from farmersinsurancedata where srcDistrictName like 'B%';

-- Q15. Retrieve the srcStateName and srcDistrictName where the district name contains the word 'pur' at the end.
select srcStateName, srcDistrictName from farmersinsurancedata where srcDistrictName like '%pur';

-- Q16. Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve the aggregated FarmersPremiumAmount for districts where the district’s Insurance units 
--      for an individual year are greater than 10.
select sum(f1.FarmersPremiumAmount), f1.srcDistrictName 
from farmersinsurancedata f1
inner join farmersinsurancedata f2 on f1.srcDistrictName=f2.srcDistrictName and f1.srcStateName=f2.srcStateName
where f1.InsuranceUnits>10
group by f1.srcDistrictName;

-- Q17. Write a query that retrieves srcStateName, srcDistrictName, Year, TotalPopulation for each district and the the highest recorded FarmersPremiumAmount for that district over all available years
-- 		  Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
select f1.srcStateName, f1.srcDistrictName, f1.srcYear, f1.TotalPopulation, f_max.highest_premium
from farmersinsurancedata f1
inner join (select srcDistrictName, max(FarmersPremiumAmount) as highest_premium from farmersinsurancedata group by srcDistrictName) f_max
on f1.srcDistrictName=f_max.srcDistrictName
where f_max.highest_premium>2000;

-- Q18. Perform a LEFT JOIN to combine the total population statistics with the farmers’ data (TotalFarmersCovered, SumInsured) for each district and state. 
-- 		  Return the total premium amount (FarmersPremiumAmount), and the average population count for each district aggregated over the years, where the total FarmersPremiumAmount is greater than 100 crores.
-- 		  Sort the results by total farmers' premium amount, highest first.
select population_statistics.srcDistrictName, farmers_data.total_premium, population_statistics.avg_population_district_wise 
from (select srcDistrictName, avg(TotalPopulation) as avg_population_district_wise from farmersinsurancedata group by srcDistrictName) population_statistics
left join (select srcDistrictName, sum(FarmersPremiumAmount) as total_premium from farmersinsurancedata group by srcDistrictName) farmers_data
on population_statistics.srcDistrictName=farmers_data.srcDistrictName
where farmers_data.total_premium>10000
order by farmers_data.total_premium desc;

-- Q19. Write a query to find the districts (srcDistrictName) where the TotalFarmersCovered is greater than the average TotalFarmersCovered across all records.
select distinct(srcDistrictname) from farmersinsurancedata 
where TotalFarmersCovered > (select avg(TotalFarmersCovered) from farmersinsurancedata);

-- Q20. Write a query to find the srcStateName where the SumInsured is higher than the SumInsured of the district 
--  		with the highest FarmersPremiumAmount.
select srcStateName from farmersinsurancedata
group by srcStateName
having sum(SumInsured) > (
    select sum(SumInsured) from farmersinsurancedata 
    where srcDistrictName = (select srcDistrictName from farmersinsurancedata order by FarmersPremiumAmount desc limit 1)
    limit 1
);

-- Q21. Write a query to find the srcDistrictName where the FarmersPremiumAmount is higher than the average 
--		  FarmersPremiumAmount of the state that has the highest TotalPopulation.
select distinct(srcDistrictName) from farmersinsurancedata
where FarmersPremiumAmount > (
    select avg(FarmersPremiumAmount) from farmersinsurancedata
    where srcStatename = (select srcStateName from farmersinsurancedata group by srcStateName order by sum(TotalPopulation) desc limit 1)
);

-- Q22. Create a table 'districts' with DistrictCode as the primary key and columns for DistrictName and StateCode. 
-- 		  Create another table 'states' with StateCode as the primary key and a column for StateName.
create table districts(DistrictCode int primary key, DistrictName varchar(30), StateCode int);
create table States(StateCode int primary key, StateName varchar(30));

-- Q23. Add a foreign key constraint to the districts table that references the StateCode column from a states table.
alter table districts add constraint foreign key(StateCode) references states(StateCode);

-- Q24. Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
update farmersinsurancedata set FarmersPremiumAmount=500.0 where rowID=1;

-- Q25. Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
update farmersinsurancedata set srcYear=2021, YearCode=201, Year_=2021 where srcStatename='HIMACHAL PRADESH';

-- Q26. Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
delete from farmersinsurancedata where TotalFarmersCovered<10000 and srcYear=2020;
