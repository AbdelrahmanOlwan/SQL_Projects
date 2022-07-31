/*
Cleaning Data in SQL Queries
*/


Select *
From PortofolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format




Select SaleDateConverted
From PortofolioProject..NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
------------------------------------------------------------


-- Populate Property Address data

Select *
     
From PortofolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject.dbo.NashvilleHousing a
JOIN PortofolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject.dbo.NashvilleHousing a
JOIN PortofolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as adress
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as city

from PortofolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

-------------------

select OwnerAddress
from PortofolioProject..NashvilleHousing
where OwnerAddress is not null


select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)

from PortofolioProject..NashvilleHousing
where OwnerAddress is not null




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)


select *
from PortofolioProject..NashvilleHousing
where OwnerAddress is not null

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select 
(
CASE when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end
) 
from PortofolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = 
CASE when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
	 else SoldAsVacant
	 end

select 
SoldAsVacant
from PortofolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortofolioProject..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--delete
--From RowNumCTE
--Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From  PortofolioProject..NashvilleHousing


ALTER TABLE  PortofolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









