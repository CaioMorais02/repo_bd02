create database ps_08

use ps_08

create or alter procedure sp_aumenta_salario (@ano_admissao int, @salario_atual numeric(10,2), @salario_novo numeric(10,2) output) AS
	
	if @ano_admissao < 2010
		set @salario_novo = @salario_atual + (@salario_atual * 30/100)

	else if @ano_admissao >= 2010 and @ano_admissao < 2015
		set @salario_novo = @salario_atual + (@salario_atual * 20/100)

	else if @ano_admissao >= 2015
		set @salario_novo = @salario_atual + (@salario_atual * 10/100)

declare @salario_novo numeric(10,2)
exec sp_aumenta_salario 2018, 1000, @salario_novo output
select @salario_novo

-----------------------------------------------------------------------------------------------------------

create table tb_funcionario(
	matricula int not null primary key,
	nm_funcionario varchar(50) not null,
	ano_admissao int not null,
	salario numeric(10,2) not null
)

INSERT INTO tb_funcionario (matricula, nm_funcionario, ano_admissao, salario)
VALUES (1, 'João da Silva', 2015, 5000.00);
INSERT INTO tb_funcionario (matricula, nm_funcionario, ano_admissao, salario)
VALUES 
    (2, 'Maria Souza', 2018, 4500.00),
    (3, 'Pedro Oliveira', 2020, 6000.00),
    (4, 'Ana Pereira', 2019, 5200.00);

INSERT INTO tb_funcionario (matricula, nm_funcionario, ano_admissao, salario)
VALUES (5, 'Carlos Santos', 2008, 4800.00);

INSERT INTO tb_funcionario (matricula, nm_funcionario, ano_admissao, salario)
VALUES 
    (6, 'Mariana Costa', 2007, 5500.00),
    (7, 'Ricardo Mendes', 2009, 5100.00),
    (8, 'Juliana Lima', 2005, 6200.00);

-------------------------------------------------------------------------------------------------

create or alter procedure sp_aumentasso AS
	declare @matricula int, @ano_admissao int, @salario numeric(10, 2), @salario_novo numeric(10, 2)
	declare c_func cursor for
	select matricula, ano_admissao, salario from tb_funcionario

	open c_func
	fetch c_func into @matricula, @ano_admissao, @salario
	while (@@FETCH_STATUS = 0)
		begin
			exec sp_aumenta_salario @ano_admissao, @salario, @salario_novo output
			update tb_funcionario
			set salario = @salario_novo
			where matricula = @matricula
			fetch c_func into @matricula, @ano_admissao, @salario
		end
	close c_func
	deallocate c_func

select * from tb_funcionario

exec sp_aumentasso