--Standardizing Date Format

select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate);

Select SaleDate , SaledateConverted 
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------

--Populating Property Address Data
Select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


Update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

-------------------------------------------------------------------------------------

-- Seperarting Property Adresss into different columns of Address, city, state, etc.

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

--Splitting Property Address into Using Substring

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
 SUBSTRING(PropertyAddress ,CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

--Adding new Columns PropertySplitAddress and PropertySplitCity and Updating them Using above function

Alter Table PortfolioProject.dbo.NashvilleHousing
add  PropertySplitAddress varchar(255)

Select PropertySplitAddress From PortfolioProject.dbo.NashvilleHousing

Update  PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table PortfolioProject.dbo.NashvilleHousing
add  PropertySplitCity varchar(255)

Update  PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress ,CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress))

Select PropertySplitCity From PortfolioProject.dbo.NashvilleHousing

--Splitting Owner Address Using Parse Name
Select OwnerAddress From PortfolioProject.dbo.NashvilleHousing

Select PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing
-----
Alter Table PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress VARCHAR(256)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

Select OwnerSplitAddress From PortfolioProject.dbo.NashvilleHousing
-----
Alter Table PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity VARCHAR(256)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

Select OwnerSplitCity From PortfolioProject.dbo.NashvilleHousing
-----

Alter Table PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState VARCHAR(256)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

Select OwnerSplitState From PortfolioProject.dbo.NashvilleHousing

--Changing Y & N to Yes & No
Select SoldAsVacant, 
Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET  SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 END

Select SoldAsVacant
From PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------

--Deleting Duplicates From Table
----Creating TempTable ROWCTE to find out Duplicate Rows using ROW_NUMBER()
With ROWCTE AS(
Select *, 
ROW_NUMBER() Over(
Partition By ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By UniqueID) row_num


From PortfolioProject.dbo.NashvilleHousing)

Delete From ROWCTE 
Where row_num >1


-----------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select * From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP Column SaleDate



