Select *
From PortfolioProject.dbo.HiringData

--Standardized Date Formating

--Approved
SELECT Approved, CONVERT(date,Approved)
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET Approved = CONVERT(Date,Approved)

SELECT Approved, CONVERT(Date,Approved)
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add ApprovedConverted Date;

UPDATE HiringData
SET ApprovedConverted = CONVERT(Date,Approved)

--Souring Date
SELECT [Sourcing start], CONVERT(Date,[Sourcing start])
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET [Sourcing start] = CONVERT(Date,[Sourcing start])

SELECT [Sourcing start], CONVERT(Date,[Sourcing start])
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [Sourcing start converted] Date;

UPDATE HiringData
SET [Sourcing start converted] = CONVERT(Date,[Sourcing start])

--Interview Start
SELECT [Interview start], CONVERT(Date,[Interview start])
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET [Interview start] = CONVERT(Date,[Interview start])

SELECT [Interview start], CONVERT(Date,[Interview start])
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [Interview start converted] Date;

UPDATE HiringData
SET [Interview start converted] = CONVERT(Date,[Interview start])

--Interview End
SELECT [Interview end], CONVERT(Date,[Interview end])
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET [Interview end] = CONVERT(Date,[Interview end])

SELECT [Interview end], CONVERT(Date,[Interview end])
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [Interview end converted] Date;

UPDATE HiringData
SET [Interview end converted] = CONVERT(Date,[Interview end])

--Offer Date
SELECT Offered, CONVERT(Date,Offered)
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET Offered = CONVERT(Date,Offered)

SELECT Offered, CONVERT(Date,Offered)
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [Offered converted] Date;

UPDATE HiringData
SET [Offered converted] = CONVERT(Date,Offered)

--Filled Date
SELECT Filled, CONVERT(Date,Filled)
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET Filled = CONVERT(Date,Filled)

SELECT Filled, CONVERT(Date,Filled)
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [Filled converted] Date;

UPDATE HiringData
SET [Filled converted] = CONVERT(Date,Filled)

--On Hold Date
SELECT [On hold], CONVERT(Date,[On hold])
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET [On hold] = CONVERT(Date,[On hold])

SELECT [On hold], CONVERT(Date,[On hold])
FROM PortfolioProject.dbo.HiringData

ALTER TABLE HiringData
Add [On Hold converted] Date;

UPDATE HiringData
SET [On Hold converted] = CONVERT(Date,[On hold])

--Change of 'F' and 'P' to 'Full Time' and 'Part Time'
SELECT FP,
CASE When FP = 'F' THEN 'Full Time'
	When FP = 'P' THEN 'Part Time'
	ELSE FP
	END
FROM PortfolioProject.dbo.HiringData

UPDATE HiringData
SET FP =
CASE When FP = 'F' THEN 'Full Time'
	When FP = 'P' THEN 'Part Time'
	ELSE FP
	END

-- Where FP is Full Time and is Fulfilled
SELECT  ID, FP, [BU Region],Filled
From PortfolioProject.dbo.HiringData
WHERE 
FP = 'full time' and
filled is not null
order by filled;

--Where an Offered was given for Part Time but not fulfilled
SELECT  ID, FP, [BU Region],Offered,Filled
From PortfolioProject.dbo.HiringData
WHERE 
FP = 'part time' and
Offered is not null and 
filled is null
Order by Offered;

--IDs sourced after 11/01/2014 and reveiced an offer
SELECT  *
From PortfolioProject.dbo.HiringData
WHERE Sourcingstart > '2014-11-01'
and Offered is not null
Order by Offered;

--Count part time vs full time
Select FP, COUNT(FP) 
From PortfolioProject.dbo.HiringData
Group By FP

--Offered vs Filled rate
Select Count(Filled) as 'Position Filled', count(Offered) as 'Offered',FP, 
cast(count(filled) as decimal(7,2))/cast(count(offered) as decimal(7,2))*100 as 'Hiring Rate'
From PortfolioProject.dbo.HiringData
Where Offered is not null
Group by FP

--Deleting and renaming coloumns
SELECT *
FROM PortfolioProject.dbo.HiringData

ALTER TABLE PortfolioProject.dbo.Hiringdata
DROP Column [On hold]

USE PortfolioProject


exec sp_rename 'HiringData.[On hold Converted]', 'OnHold';

