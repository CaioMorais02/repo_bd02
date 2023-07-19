create database ps_06

use ps_06

create table tb_funcionario(
	matricula int not null primary key,
	nome varchar(50) not null,
	telefone varchar(11),
	endereco varchar(20),
	salario float,
	pendencia varchar(16)
)

delete from tb_funcionario
where matricula = 2

insert into tb_funcionario (matricula, nome, telefone, endereco, salario)
values (1, 'Caio', '4002-8922', 'Francolino', 660.00),
	   (2, 'João', null, null, null)

drop procedure sp_pendencia

create procedure sp_pendencia AS
	declare @matricula int, @nome varchar(50), @telefone varchar(11), @endereco varchar(20), @salario float, @pendencia varchar(16)
	declare c_pendencia cursor for
	select matricula, telefone, endereco, salario from tb_funcionario

	open c_pendencia
	fetch c_pendencia into @matricula,@telefone, @endereco, @salario

	while (@@FETCH_STATUS = 0)
		begin
			set @pendencia = 'sem pendência'
			if @telefone is null or @endereco is null or @salario is null
				set @pendencia = 'existe pendência'
			update tb_funcionario
			set pendencia = @pendencia
			where matricula = @matricula
			fetch c_pendencia into @matricula,@telefone, @endereco, @salario
		end
	close c_pendencia
	deallocate c_pendencia

exec sp_pendencia 

select * from tb_funcionario