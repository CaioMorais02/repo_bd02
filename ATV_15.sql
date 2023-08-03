CREATE DATABASE ATV_15

USE ATV_15

-- QUESTÃO 1

set language Brazilian

CREATE OR ALTER FUNCTION dbo.SF_DataCompleta(@DATA DATE)
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN LTRIM(STR(DAY(@DATA))) + ' de ' + LTRIM(DATENAME(mm, @DATA)) + ' de ' + LTRIM(STR(YEAR(@DATA)))
END

DECLARE @DATE VARCHAR(100)
EXEC @DATE = dbo.Sf_DataCompleta '2023-07-31'
PRINT @DATE

-- QUESTÃO 2

CREATE OR ALTER FUNCTION dbo.sf_lpad(@String varchar(8000), @Tamanho int, @Caracter varchar(1))
returns varchar(8000)
as
begin
	declare @prench int, @char varchar(8000)
	if @Tamanho < len(@String)
		return substring(@String, 1, @Tamanho)

	else
		set @prench = @Tamanho - len(@String)
		set @char = replicate(@Caracter, @prench)
		set @String = @char + @String
		return @String
end

declare @teste varchar(8000)

exec @teste = dbo.sf_lpad 'tech', 7,' '
print @teste

select dbo.sf_lpad('tech', 2,' ');
select dbo.sf_lpad('tech', 8, '0'); retornaria '0000tech'
select dbo.sf_lpad('tech on the net', 15, 'z'); retornaria 'tech on the net'
select dbo.sf_lpad('tech on the net', 16, 'z'); retornaria 'ztech on thenet'