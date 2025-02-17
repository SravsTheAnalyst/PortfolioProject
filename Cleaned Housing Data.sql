/*
Cleaning Data in SQl Queries
*/
  
Select * from housing

-------------------------------------------------------------------------------------------------------------------
/* 
Standardize Date Format
*/
  
Select SaleDateConverted, CONVERT(Date, SaleDate)
from housing

update housing
Set SaleDate = CONVERT(Date, SaleDate)

Alter table housing 
Add SaleDateConverted Date;

update housing
Set SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------------------------------------------

-- Populate Property  Address data

Select *
from housing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID , a.PropertyAddress,b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from housing a
join housing b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from housing a
join housing b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null





---------------------------------------------------------------------------------------------

-- Breaking out Address into Individual columns(Address, City , State)


Select PropertyAddress
from housing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, Len(PropertyAddress))as Address

from housing

Alter table housing 
Add PropertySplitAddress Nvarchar(255);

update housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)

Alter table housing 
Add PropertySplitCity Nvarchar(255);

update housing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, Len(PropertyAddress))


Select *
from housing

Select OwnerAddress
from housing

Select
PARSENAME(REPlACE(OwnerAddress,',','.') ,3),
PARSENAME(REPlACE(OwnerAddress,',','.') ,2 ),
PARSENAME(REPlACE(OwnerAddress,',','.') ,1 )
from housing

Alter table housing 
Add OnwerSplitAddress Nvarchar(255);

update housing
Set OnwerSplitAddress = PARSENAME(REPlACE(OwnerAddress,',','.') ,3)

Alter table housing 
Add OnwerSplitCity Nvarchar(255);

update housing
Set OnwerSplitCity = PARSENAME(REPlACE(OwnerAddress,',','.') ,2 )

Alter table housing 
Add OnwerSplitState Nvarchar(255);

update housing
Set OnwerSplitState = PARSENAME(REPlACE(OwnerAddress,',','.') ,1 )

Select *
from housing





----------------------------------------------------------------------------------------------------------------



--- Change Y and N to Yes and No in "Sold as vacant" field

Select Distinct(SoldAsVacant) , COUNT(SoldAsVacant)
from housing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   end
from housing

Update housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
       When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   end


-----------------------------------------------------------------------------------------------------------

-- Remove Dupliactes

With RowNUMCTE AS(
Select *,
ROW_NUMBER() Over (
   PARTITION By ParcelId, 
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
				   UniqueId
				   ) row_num

from housing
--order by ParcelID
)


Select * 
from RowNUMCTE
where row_num > 1
--Order by PropertyAddress








------------------------------------------------------------------------------------------------------------
--  Delete Unused Data

Select *
 from housing

 Alter table housing
 Drop Column OwnerAddress, TaxDistrict , PropertyAddress

  Alter table housing
 Drop Column SaleDate