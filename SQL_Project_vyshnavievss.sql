SELECT * FROM Assignment.hr_data;

/* 1. Data Cleaning Male to 'M', Female to 'F', DataScientist to Data Scientist, Marketinganalyst to Marketing Analyst
2. change LastPromotionDate format
3. Age Groups- <= 30 years & >30 years
4. Salary categories
	1- 50k-60k
	2- 60k-70k
    3- 80k-90k
5. Department wise Avg salary and Total avg salary
6. Calculate department wise attirition rate, M and F attrition rate
7. comapare avg salary VS attiririton rate
8. Years of exp VS promotion
9. Training hours , satisfactionscore VS attirition rate
10.Training hours VS promotion
11. Gender vs other factors
12. check promotion and attrition count
13. years of service and count of attirirtion
14. cur-years of service -- promotion
15 check no of people in marketing as their salary < total average salary
*/

DROP TABLE IF EXISTS hrdata;

CREATE TABLE hrdata AS
SELECT 
EmployeeID,
Age,
CASE
	WHEN Age<=30 THEN '<= 30 years'
    ELSE '> 30 years'
END AS Agegroup,
REPLACE (REPLACE (Gender, 'Male','M'), 'Female','M') AS Gender,
Department,
REPLACE (REPLACE (Position, 'DataScientist','Data Scientist'),'Marketinganalyst','Marketing Analyst') AS Position,
YearsOfService,
Salary,
CASE
    WHEN Salary >= 90000 THEN ' 90k-100k'
	WHEN Salary >= 80000 THEN ' 80k-90k'
    WHEN Salary >= 70000 THEN ' 70k-80k'
    WHEN Salary >= 60000 THEN ' 60k-70k'
ELSE '50k-60k' 
END AS Salarybucket,
PerformanceRating,
WorkHours,
Attrition,
Promotion,
TrainingHours,
SatisfactionScore,
LastPromotionDate
FROM hr_data;

SELECT * FROM hrdata;

-- overal ccalculations
SELECT 
    Attrition, COUNT(*) AS Total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*))*100,2) AS Attrition_Count,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Total_Active_employees,
    ROUND(AVG(Age),0) AS AvgAge,
    ROUND(AVG(YearsOfService),0) AS AvgYearsOfService,
    ROUND(AVG(Salary),0) AS AvgSalary,
    ROUND(AVG(SatisfactionScore),0) AS AvgSatisfactionScore,
    ROUND(AVG(WorkHours),0) AS AvgWorkHours,
    ROUND(AVG(TrainingHours),0) AS AvgTrainingHours
FROM hrdata
GROUP BY Attrition;

SELECT 
    COUNT(*) AS Total_employees,
    ROUND(AVG(Age),0) AS AvgAge,
    ROUND(AVG(YearsOfService),0) AS AvgYearsOfService,
    ROUND(AVG(Salary),0) AS AvgSalary,
    ROUND(AVG(SatisfactionScore),0) AS AvgSatisfactionScore,
    ROUND(AVG(PerformanceRating),0) AS AvgPerformanceRating,
    ROUND(AVG(WorkHours),0) AS AvgWorkHours,
    ROUND(AVG(TrainingHours),0) AS AvgTrainingHours
FROM hrdata;


-- AGE GROUP
SELECT 
    Agegroup,Department,COUNT(*) AS Total_employees,
    ROUND(AVG(YearsOfService),0) AS AvgYearsOfService,
    ROUND(AVG(Salary),0) AS AvgSalary,
    ROUND(AVG(SatisfactionScore),0) AS AvgSatisfactionScore,
    ROUND(AVG(WorkHours),0) AS AvgWorkHours,
    ROUND(AVG(TrainingHours),0) AS AvgTrainingHours
FROM hrdata
GROUP BY Agegroup,Department;

SELECT Agegroup,Department,COUNT(*) AS Total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attritioncount_Yes,
SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Attritioncount_No,
ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountYes,
ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountNo
FROM hrdata
GROUP BY Agegroup,Department;

-- Department wise attrition

SELECT Department,COUNT(*) AS Total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attritioncount_Yes,
SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Attritioncount_No,
ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountYes,
ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountNo
FROM hrdata
GROUP BY Department;

-- Position wise attrition
SELECT Position,COUNT(*) AS Total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attritioncount_Yes,
SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Attritioncount_No,
ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountYes,
ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountNo,
AVG(Salary)
FROM hrdata
GROUP BY Position;

-- PerformanceRating
SELECT EmployeeID,Department,Position,Attrition
FROM hrdata
WHERE PerformanceRating<(SELECT AVG(PerformanceRating) FROM hrdata) AND Attrition = 'Yes';

-- salary bucket
SELECT Salarybucket,COUNT(*) AS Total_employees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attritioncount_Yes,
SUM(CASE WHEN Attrition='No' THEN 1 ELSE 0 END) AS Attritioncount_No,
ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountYes,
ROUND((SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_CountNo
FROM hrdata
GROUP BY Salarybucket;

Select Salary, EmployeeID,Department,Position,promotion,Attrition
FROM hrdata
WHERE Salary>=90000 ;

-- I have checked empoyees whose salary is < the avg salary and their attrition rate=yes

SELECT EmployeeID,Salary,YearsOfService,Attrition 
FROM hrdata
WHERE Salary< (SELECT AVG(Salary) FROM hrdata) AND Attrition = 'Yes'  ;


-- 17  memeber have left the company as their salary is < avg salary and their experience is >= 4 years
-- the employees with 2 and 3 years experience has same salary as >=4 years this might be the reson 

-- Department wise attrition rate and total attrition rate
SELECT * FROM hrdata
WHERE Attrition= 'Yes';
-- total count= 54
SELECT Department, COUNT(DISTINCT EmployeeID)
FROM hrdata
WHERE Attrition='Yes'
GROUP BY Department;
/*
'Finance','15'
'HR','6'
'IT','18'
'Marketing','10'
'Sales','5'
*/ 

-- Department wise average salary

SELECT Department,Avg(Salary),COUNT(DISTINCT EmployeeID) FROM hrdata
WHERE Salary<(SELECT AVG(Salary) FROM hrdata) AND Attrition='Yes'
GROUP BY Department;
-- In the above query it is observed that employees salary from IT and HR department is less than depatment average salary so this might be the reason for attrition

SELECT Department, COUNT(*)
FROM hrdata
WHERE Salary < (SELECT AVG(Salary) FROM hrdata) AND ATTRITION='YES'
GROUP BY Department;

SELECT EmployeeID,Department,salary,Attrition
FROM hrdata 
WHERE Salary<(SELECT AVG(Salary) FROM hrdata) AND Attrition='Yes';
-- or
WITH Avgsal AS (
SELECT AVG(Salary) AS deptavgsalary  FROM hrdata )
SELECT EmployeeID,Attrition,Salary,Department
FROM hrdata
WHERE Salary < (SELECT deptavgsalary FROM Avgsal) AND Attrition='Yes';

-- working hours,salary, attrition,
SELECT AVG(WorkHours) FROM hrdata;

SELECT EmployeeID, Department, Salary,WorkHours,YearsOfService,Promotion ,Attrition
FROM hrdata
WHERE Salary< (SELECT AVG(Salary) FROM hrdata) AND Attrition='Yes' AND Promotion='No' AND YearsOfService>3 AND WorkHours>(SELECT AVG(WorkHours) FROM hrdata) ;


SELECT EmployeeID, Department, Salary,WorkHours,YearsOfService,Promotion ,Attrition
FROM hrdata
WHERE  WorkHours>(SELECT AVG(WorkHours) FROM hrdata) AND Attrition='Yes';

-- From the above analysis it is observed that the people whose experience is more than 3 years and their working hours is more than the average no of working hours still 
-- their salary is less than avg salary which might be the reason for attrition

-- Years of experience VS Promotion
SELECT  AVG(YearsOfService) 
FROM hrdata;

SELECT EmployeeID,Department,Position,YearsOfService,Promotion,Attrition
FROM hrdata
WHERE YearsOfService > (SELECT  AVG(YearsOfService) FROM hrdata)AND Attrition='Yes' AND Promotion='No';
-- 22 members have left the company as their experience is more than the average and they did'nt get the promotion

-- Training hours , satisfactionscore VS attirition rate

SELECT ROUND(AVG(TrainingHours),0) FROM hrdata; -- 20 hours

SELECT EmployeeID,Department,Position,TrainingHours,Promotion,Attrition
FROM hrdata
WHERE TrainingHours<(SELECT AVG(TrainingHours) FROM hrdata) AND Attrition='Yes' AND Promotion='No';

-- It is observed that 33 employees have less training hours than the average and they did'nt get the promotion, so this is the reason for attrition

SELECT 
    COUNT(*) AS Total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeID))*100,2) AS Attrition_Count
FROM hrdata
WHERE  TrainingHours<(SELECT AVG(TrainingHours) FROM hrdata) AND Attrition='Yes' AND Promotion='No';


-- age group

SELECT Age, Attrition,Department,Position,TrainingHours,Promotion,YearsOfService,WorkHours
FROM hrdata
WHERE Attrition='Yes' AND Age> 30 AND Salary<(SELECT AVG(Salary) FROM hrdata) AND Promotion='No';


SELECT Agegroup, Attrition,Department,Position,TrainingHours,Promotion,YearsOfService,WorkHours
FROM hrdata
WHERE Attrition='Yes'  AND Salary<(SELECT AVG(Salary) FROM hrdata) AND Promotion='No';



-- years of service VS promotion

SELECT YearsOfService,Attrition,
SUM(CASE WHEN Promotion='Yes' THEN 1 ELSE 0 END) AS Promoted,
SUM(CASE WHEN Promotion='No' THEN 1 ELSE 0 END) AS NotPromoted
FROM hrdata
GROUP BY YearsOfService,Attrition;


SELECT YearsOfService,Attrition,count(*),
SUM(CASE WHEN Promotion='Yes' THEN 1 ELSE 0 END) AS Promoted,
SUM(CASE WHEN Promotion='No' THEN 1 ELSE 0 END) AS NotPromoted
FROM hrdata
WHERE Attrition='Yes'
GROUP BY YearsOfService,Attrition;

-- years of service VS promotion, salary
WITH Avgsal AS
(SELECT AVG(Salary) FROM hrdata)
SELECT YearsOfService,Attrition,
SUM(CASE WHEN Promotion='Yes' THEN 1 ELSE 0 END) AS Promoted,
SUM(CASE WHEN Promotion='No' THEN 1 ELSE 0 END) AS NotPromoted
FROM hrdata
WHERE Attrition='Yes' AND  Salary< (SELECT AVG(Salary) FROM hrdata)
GROUP BY YearsOfService,Attrition;


SELECT YearsOfService, AVG(Salary)
FROM hrdata
GROUP BY  YearsOfService;

-- position vs avg salary
SELECT Position, AVG(Salary)
FROM hrdata
GROUP BY  Position;

WITH Positionavgsal AS(
SELECT  AVG(Salary) AS POAV
FROM hrdata ) 
SELECT Position,YearsOfService,SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS Attritioncount_Yes
FROM hrdata
WHERE Promotion='No' AND Attrition='Yes' AND Salary<(SELECT POAV FROM Positionavgsal )
GROUP BY Position,YearsOfService;
/*
SELECT Position, AVG(Salary)
FROM hrdata
WHERE Promotion='No' AND Attrition='Yes' AND Salary<(SELECT AVG(Salary) FROM hrdata )
GROUP BY Position;

SELECT Position,COUNT(DISTINCT EmployeeID),YearsOfService, COUNT(*)
FROM hrdata
WHERE  Attrition='Yes'
GROUP BY Position,YearsOfService;

SELECT Position, YearsOfService, AVG(Salary)
FROM hrdata
GROUP BY Position, YearsOfService;


SELECT Position, YearsOfService, AVG(Salary)
FROM hrdata
WHERE Promotion='No' AND Attrition='Yes' AND Salary<(SELECT AVG(Salary) FROM hrdata )
GROUP BY Position, YearsOfService; */

SELECT EmployeeID,Department,Position,SatisfactionScore,Promotion,Attrition
FROM hrdata
WHERE SatisfactionScore<(SELECT AVG(SatisfactionScore) FROM hrdata) AND Attrition='Yes' AND Promotion='No';


SELECT EmployeeID,Department,Position,PerformanceRating,Promotion,Attrition
FROM hrdata
WHERE PerformanceRating<(SELECT AVG(PerformanceRating) FROM hrdata) AND Attrition='Yes' AND Promotion='No';

-- Training efffectiveness
-- did the trining for the employees have increase in their performance?
SELECT AVG(PerformanceRating) FROM hrdata;


SELECT TrainingHours,AVG(PerformanceRating),COUNT(*) AS Total_employees
FROM hrdata
WHERE Attrition='Yes'
GROUP BY TrainingHours;


SELECT TrainingHours,COUNT(*) AS Attrition_Yes
FROM hrdata
WHERE Attrition='Yes' AND Promotion='No'
GROUP BY TrainingHours;

SELECT TrainingHours,Promotion,COUNT(*) AS total_employees
FROM hrdata
WHERE Attrition='Yes' AND Promotion= 'No' AND TrainingHours >= (SELECT ROUND(AVG(TrainingHours)) FROM hrdata)
GROUP BY TrainingHours,Promotion;