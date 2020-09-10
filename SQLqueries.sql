--Создаём таблицы и наполняем их данными
Create table dbo.Brand (
             BrandID int identity(1,1) NOT NULL,
			 BrandName nvarchar(max),
			 BrandCountry nvarchar(100),
			 constraint PK_Brand_BrandID PRIMARY KEY (BrandID)
			 )

insert into dbo.Brand values ('Mercedes', 'Germany'),
							 ('Audi', 'Germany'),
							 ('Nissan', 'Japan'),
							 ('Honda', 'Japan'),
							 ('SsangYong', 'Korea'),
							 ('Hyundai', 'Korea'),
							 ('Lamborghini', 'Italy'),
							 ('Kia', 'Korea'),
							 ('Lada', 'Russia')

Create table dbo.Auto (
			AutoId int identity (1,1) NOT NULL,
			AutoModel nvarchar(100),
			BrandId int,
			Price decimal,
			constraint FK_Auto_Brand FOREIGN KEY (BrandId)
			references dbo.Brand (BrandID))


Insert into dbo.Auto values ('G-class', 1, 11000000),
							('X-class', 1, 3000000),
							('V-class', 1, 3100000),
							('AMG GT Coupe',1, 15000000),
							('A3',2, 1900000),
							('A6',2, 3080000),
							('Q7',2, 4800000),
							('Qashqai',3, 1267000),
							('X-trail', 3, 1549000),
							('Terrano', 3, 980000),
							('Civic', 4, 720000),
							('CR-V', 4, 2825900),
							('StepWgn', 4, 1150000),
							('Rexton', 5, 1300000),
							('Kyron', 5, 800000),
							('Actyon', 5, 600000),
							('Solaris', 6, 500000),
							('Tucson', 6, 2300000),
							('Santa Fe', 6, 2000000),
							('Urus', 7, 17000000),
							('Aventador', 7, 21000000),
							('Picanto', 8,730000),
							('Seltos', 8 ,1050000),
							('Rio', 8, 600000)
							
select * from dbo.Auto (nolock)

select * from dbo.Brand (nolock)

--1. Используя схему БД автомобильного салона с таблицами Brand – марки автомобилей, Auto – доступные для покупки автомобили.
--   Cоставить запрос для поиска количества и общей стоимости автомобилей каждой марки (в определенный момент времени в салоне может не быть автомобилей конкретной марки)
select BrandName, ISNULL(CAST(SUM(auto.Price) as nvarchar(100)),'No Autos') as totalPrice,count(auto.BrandId) as caramount from dbo.Auto (nolock)
right join dbo.Brand (nolock) on auto.BrandId = brand.BrandID
group by BrandName



--2.1 Марки автомобиля с самой высокой средней стоимостью автомобилей этой марки
select top 3 b.BrandName, avg(Price) as avgprice from dbo. Auto a (nolock)
join dbo.Brand  b  (nolock) on b.BrandID = a.BrandId
group by b.BrandName
order by avgprice desc

--2.2 Количества немецких автомобилей
select b.BrandCountry, count(a.AutoId) as CarCount from dbo.Auto a (nolock)
join dbo.Brand b (nolock) on b.BrandID = a.BrandId
group by b.BrandCountry
having b.BrandCountry = 'Germany'


--2.3 Списка самых дорогих моделей автомобилей каждого бренда
select b.BrandName, a.AutoModel, a.Price from dbo.Auto a (nolock)
join dbo.Brand b (nolock) on b.BrandID=a.BrandId
where a.price in (
select max(price) as maxprice from dbo.Auto 
group by BrandID)


