SELECT *
FROM public.nashville

--populate property_address data

SELECT *
FROM public.nashville
WHERE property_address IS NULL

SELECT a.parcel_id, a.property_address, b.parcel_id, b.property_address, COALESCE (a.property_address,b.property_address)
FROM public.nashville a
JOIN public.nashville b
	ON a.parcel_id = b.parcel_id
	AND a.unique_id != b.unique_id
WHERE a.property_address is null

UPDATE public.nashville
SET property_address = COALESCE(a.property_address,b.property_address)
FROM public.nashville a
JOIN public.nashville b
	ON a.parcel_id = b.parcel_id
	AND a.unique_id != b.unique_id
WHERE a.property_address is null


--Breaking out property_address into individual columns (street, state)
SELECT property_address
FROM public.nashville


SELECT 
  substring(property_address, 1, strpos(property_address, ',') - 1) AS street_address,
  substring(property_address, strpos(property_address, ',') + 1) AS state_address
FROM public.nashville;

ALTER TABLE public.nashville
ADD COLUMN property_address_street varchar(50)

ALTER TABLE public.nashville
ADD COLUMN property_address_state varchar(50)

SELECT *
FROM public.nashville

UPDATE public.nashville
SET property_address_street = substring(property_address, 1, strpos(property_address, ',') - 1);

UPDATE public.nashville
SET property_address_state = substring(property_address, strpos(property_address, ',') + 1);

--Breaking out owner_address into individual columns (street, city, state)
SELECT owner_address 
FROM public.nashville

ALTER TABLE public.nashville
ADD COLUMN owner_address_street varchar(50)

ALTER TABLE public.nashville
ADD COLUMN owner_address_city varchar(50)

ALTER TABLE public.nashville
ADD COLUMN owner_address_state varchar (50)

UPDATE public.nashville
SET (owner_address_street, owner_address_city, owner_address_state) = 
    (split_part(owner_address, ',', 1), 
     split_part(owner_address, ',', 2), 
     split_part(owner_address, ',', 3))


--removing irrelevant columns

SELECT *
FROM public.nashville

ALTER TABLE public.nashville
DROP COLUMN owner_address

ALTER TABLE public.nashville
DROP COLUMN property_address

 
 
 
 ------------------------------------------------------------------------------------------------------------------------------
 --importing the data set
 CREATE TABLE public.nashville(
unique_id integer PRIMARY KEY,
parcel_id varchar(28),
land_use text,
property_address varchar(50),
sale_date date,
sale_price varchar(50),
legal_reference varchar(50),
sold_as_vacant BOOLEAN,
owner_name varchar(60),
owner_address varchar (60),
acreage double precision,
tax_district text,
land_value integer,
building_value integer,
total_value integer,
year_built integer,
bedrooms integer,
full_bath integer,
half_bath integer
	);

--click refresh on the public schema
--click import/export on the table, chose file, set delimiter and turn on header, then click import


