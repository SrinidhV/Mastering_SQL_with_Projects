-- Saving our original table
CREATE TABLE layoffs_original AS  --  Choose a clear name for your backup table (e.g., original table name + '_original' or '_backup' suffix)
SELECT *
FROM layoffs; --  Replace 'layoffs' with the name of your *original* table


SELECT * FROM layoffs_original


--1) task 1- Understanding DATA 
 SELECT * FROM layoffs
 LIMIT 20

-- -------------------------------------------------

 --2) task 2- Remove Null's
 -- location/ company -- We have no  null's in the location column
 SELECT *
 FROM layoffs
 WHERE location IS NULL

 -- industry -- The industry has null and '' values so I'll convert all ' ' to null's

 SELECT *
 FROM layoffs
 WHERE industry IS NULL OR industry = ''

SELECT * 
FROM layoffs
WHERE company IN ('Airbnb', 'Bally''s Interactive', 'Juul', 'Carvana')
ORDER BY company ASC

UPDATE layoffs
SET industry = NULL
WHERE industry = ''

-- I wanna replace the null's of repeated rows with their previous values
-- Starting the transaction
BEGIN;
-- First checking null values
SELECT * 
FROM layoffs
WHERE company IN ('Airbnb', 'Bally''s Interactive', 'Juul', 'Carvana')
ORDER BY company ASC

-- Updating the null values
UPDATE layoffs as t1
SET industry = t2.industry
FROM layoffs t2
WHERE t2.company = t1.company
AND t2.industry IS NOT NULL
AND t1.industry IS NULL
-- Checking if it worked

SELECT * 
FROM layoffs
WHERE industry IS NULL

-- commiting the change

COMMIT;

-- Checking stage null's
SELECT * FROM layoffs WHERE stage IS NULL

SELECT * FROM layoffs
WHERE company IN ('Verily','Relevel','Advata','Spreetail','Gatherly','Zapp')

-- We made sure that neither location,company,country,industry have any nulls that need modification
SELECT * FROM layoffs
WHERE stage IS NULL OR stage = ''

--

SELECT COUNT(*) FROM layoffs WHERE location = '';  -- Check for empty strings in location
SELECT COUNT(*) FROM layoffs WHERE company = '';   -- Check for empty strings in company
SELECT COUNT(*) FROM layoffs WHERE country = '';   -- Check for empty strings in country

-- NULL's in numeric columns

SELECT *
FROM layoffs
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL

-- We don't need rows where both the total and percentage laid off are null

BEGIN;

DELETE FROM layoffs
WHERE total_laid_off IS NULL and percentage_laid_off is NULL

Commit;

SELECT *
FROM layoffs
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL

-- 3) Removing Duplicates

WITH cte AS(SELECT * , ROW_NUMBER() OVER(PARTITION BY company,location,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions) as row_num
FROM layoffs)
DELETE FROM layoffs
WHERE ctid IN (SELECT ctid FROM cte WHERE row_num >1);

-- 





