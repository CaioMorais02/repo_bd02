create database cursor04

use cursor04

create table tb_cliente(
	matricula	int				not null		primary key,
	nome		varchar(50)		not null,
	telefone	varchar(10)		not null
)

---------------------------------------------------------------------------------------

create procedure sp_inclui_cliente
	(@matricula int, @nome varchar(50), @telefone varchar(10)) AS
insert into tb_cliente(matricula, nome, telefone) values (@matricula, @nome, @telefone)

exec sp_inclui_cliente 1, 'João', '4002-8922'
exec sp_inclui_cliente 2, 'Roberto', '4003-8923'
exec sp_inclui_cliente 3, 'Ricardo', '4004-8924'

----------------------------------------------------------------------------------------

create procedure sp_altera_cliente
	(@matricula int, @nome varchar(50), @telefone varchar(10)) AS
update tb_cliente
set nome = @nome, telefone = @telefone
where matricula = @matricula

exec sp_altera_cliente 2, 'Roberto', '4005-8925'
exec sp_altera_cliente 3, 'Ricardo', '4006-8926'

-----------------------------------------------------------------------------------------

create procedure sp_remove_cliente (@matricula int, @resultado int output)
AS
	delete from tb_cliente
	where matricula = @matricula
	select @resultado = @@rowcount

declare @resultado int
exec sp_remove_cliente 4, @resultado output
if @resultado = 1
	print 'cliente removido'
else
	print 'cliente não encontrado'

-----------------------------------------------------------------------------------------

alter procedure sp_altera_cliente (@matricula int, @nome varchar(50), @telefone varchar(10)) AS
	if @matricula is null or @nome is null or @telefone is null
		print 'Um dos atributos é nulo'
	else
		update tb_cliente
		set nome = @nome, telefone = @telefone
		where matricula = @matricula

exec sp_altera_cliente 2, null, '4007-8927'
exec sp_altera_cliente 3, 'Robertão', '6666-6666'

select * from tb_cliente