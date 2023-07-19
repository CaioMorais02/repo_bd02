create database ps_05

use ps_05

create procedure sp_calc_imposto (@renda float, @imposto float output) AS
if @renda <= 1372.81
	set @imposto = @renda
else if @renda > 1372.81 and @renda <= 2743.25
	set @imposto = (@renda * 15.0/100.0) - 205.82
else
	set @imposto = (@renda * 27.5/100.0) - 548.82

declare @imposto float
exec sp_calc_imposto 4000.0, @imposto output
select ROUND(@imposto, 2) AS 'IMPOSTO'