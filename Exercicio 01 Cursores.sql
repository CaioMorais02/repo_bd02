create database cursor01

use cursor01

create table tb_aluno(
	matricula int not null primary key,
	nome varchar(50) not null,
	dt_nascimento date
)

insert into tb_aluno
values (1, 'JOAO', '1976-08-12'),
	   (2, 'RICARDO', '1970-01-23'),
	   (3, 'ROBERTO', '1989-07-26')

------------------------------------------------------------------------------

declare @id_aluno int, @nm_aluno varchar(50), @dt_nascimento date
declare c_aluno cursor for
select matricula, nome, dt_nascimento from tb_aluno

open c_aluno
fetch c_aluno into @id_aluno, @nm_aluno, @dt_nascimento
print 'MATRICULA    NOME      DATA NASCIMENTO'
print '------------------------------------------'
while (@@FETCH_STATUS = 0)
	begin
		print str(@id_aluno) + '   ' + @nm_aluno + '   ' + cast(@dt_nascimento AS varchar)
		print '------------------------------------------'
		fetch c_aluno into @id_aluno, @nm_aluno, @dt_nascimento
	end
close c_aluno
deallocate c_aluno