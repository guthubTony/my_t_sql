USE TimeSheet
GO
declare @trun_name varchar(8000)
set @trun_name=''
select @trun_name=@trun_name + 'truncate table ' + [name] + ' ' from sysobjects where xtype='U' and name LIKE '%TS%' 
exec (@trun_name)
--游标操作
declare @trun_name varchar(50)
declare name_cursor cursor for
select 'truncate table ' + name from sysobjects where xtype='U' and status > 0
open name_cursor
fetch next from name_cursor into @trun_name
while @@FETCH_STATUS = 0
begin
  exec (@trun_name)
 print 'truncated table ' + @trun_name
 fetch next from name_cursor into @trun_name
end
close name_cursor
deallocate name_cursor

2005 以上 字符串合并
SELECT STUFF((SELECT ','+[ReciverGuid] FROM 
Sup_Reciver  WHERE RectGuid=Sup_Reciver.RectGuid FOR XML PATH('')), 1, 1, '')

declare @city_id varchar(50)
declare my_cursor cursor for
select  CityID from dbo.S_City 
open my_cursor
fetch next from my_cursor into @city_id
while @@FETCH_STATUS = 0
begin
 INSERT INTO dbo.S_District 
         ( DistrictID ,
           DistrictName ,
           DistrictEnglishName ,
           CityID ,
           DateCreated ,
           DateUpdated
         )
 VALUES  ( (SELECT MAX(DistrictID)+1 FROM dbo.S_District)  , -- DistrictID - bigint
           N'--' , -- DistrictName - nvarchar(50)
           NULL , -- DistrictEnglishName - nvarchar(100)
           @city_id , -- CityID - bigint
           (SELECT  getdate()) , -- DateCreated - datetime
           (SELECT  getdate())  -- DateUpdated - datetime
         )
print 'add ' + @city_id
fetch next from my_cursor into @city_id
end
close my_cursor
deallocate my_cursor
