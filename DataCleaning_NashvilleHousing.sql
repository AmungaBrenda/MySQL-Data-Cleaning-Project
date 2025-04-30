/* Cleaning Data in SQL Queries */

USE PortfolioProjects;

SELECT * FROM nashvilleHousingData;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate FROM nashvilleHousingData;

-- Add a new column for standardized date
ALTER TABLE nashvilleHousingData
 ADD COLUMN SaleDate_Converted DATE;

-- Update the new column with converted dates

SET SQL_SAFE_UPDATES = 0;

UPDATE nashvilleHousingData 
SET SaleDate_Converted = STR_TO_DATE(SaleDate, '%M %d, %Y');

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Missing Property Address Data

SELECT * FROM nashvilleHousingData;

SELECT * FROM nashvilleHousingData
WHERE PropertyAddress IS NOT NULL
ORDER BY ParcelID;

SELECT 
  a.ParcelID, 
  a.PropertyAddress AS a_Address,
  b.ParcelID,
  b.PropertyAddress AS b_Address,
  IFNULL(a.PropertyAddress,b.PropertyAddress) AS FilledAddress
  FROM nashvilleHousingData a
  JOIN nashvilleHousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID  <> b.UniqueID 
WHERE a.PropertyAddress IS NULL;

UPDATE nashvilleHousingData a
JOIN nashvilleHousingData b 
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- Step 1: View PropertyAddress column
SELECT PropertyAddress
FROM nashvilleHousingData;

-- Step 2: Extract Address and City from PropertyAddress (MySQL doesn't support CHARINDEX or LEN; use LOCATE and LENGTH instead)
SELECT
  SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) AS Address,
  SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) AS City
FROM nashvilleHousingData;

-- Step 3: Add columns to store split values
ALTER TABLE nashvilleHousingData
  ADD COLUMN PropertySplitAddress VARCHAR(255);
  
ALTER TABLE nashvilleHousingData
  ADD COLUMN PropertySplitCity VARCHAR(255);
  

-- Step 1: Update PropertySplitAddress (extract before the comma)
UPDATE nashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

-- Step 2: Update PropertySplitCity (extract after the comma)
UPDATE nashvilleHousingData
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1));

----

-- View full table
SELECT * FROM nashvilleHousingData;

-- View the OwnerAddress column
SELECT OwnerAddress FROM nashvilleHousingData;

-- Add columns for split values
ALTER TABLE nashvilleHousingData
  ADD COLUMN OwnerSplitAddress VARCHAR(255),
  ADD COLUMN OwnerSplitCity VARCHAR(255),
  ADD COLUMN OwnerSplitState VARCHAR(255);

-- Update OwnerSplitAddress (Street)
UPDATE nashvilleHousingData
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);

-- Update OwnerSplitCity (City)
UPDATE nashvilleHousingData
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

-- Update OwnerSplitState (State)
UPDATE nashvilleHousingData
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- View final results
SELECT * FROM nashvilleHousingData;


--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field
-- Step 1
SELECT SoldAsVacant, COUNT(*) AS Count
FROM nashvilleHousingData
GROUP BY SoldAsVacant
ORDER BY Count;

-- Step 2 Preview changes with CASE
SELECT SoldAsVacant,
  CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END AS CleanedValue
FROM nashvilleHousingData;

-- Step 3 Update The Table
UPDATE nashvilleHousingData
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
  END;


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
-- Step 1: Identify Duplicate Rows Using ROW_NUMBER()
WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
           ORDER BY UniqueID
         ) AS row_num
  FROM nashvilleHousingData
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

-- Creating BackUp of Data before deleting duplicates

CREATE TABLE nashvilleHousingData_backup AS
SELECT * FROM nashvilleHousingData;

-- Deleting Duplicates
DELETE nh
FROM nashvilleHousingData nh
JOIN (
  SELECT UniqueID
  FROM (
    SELECT UniqueID,
           ROW_NUMBER() OVER (
             PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
             ORDER BY UniqueID
           ) AS row_num
    FROM nashvilleHousingData
  ) AS RowNumCTE
  WHERE row_num > 1
) dup
ON nh.UniqueID = dup.UniqueID;



-- View final results
SELECT * FROM nashvilleHousingData;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- 1.View the table
SELECT * FROM nashvilleHousingData;

-- 2.Drop multiple columns 
ALTER TABLE nashvilleHousingData
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;


-- 3.View final results
SELECT * FROM nashvilleHousingData;

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

