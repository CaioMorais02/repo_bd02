CREATE DATABASE BDII_AVALIACAO_II
USE BDII_AVALIACAO_II


CREATE TABLE TB_SOLICITACAO_ABERTURA_CONTA (
   ID_SOLICITACAO INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   NOME VARCHAR(100) NOT NULL,
   CPF VARCHAR(20) NOT NULL,
   EMAIL VARCHAR(100) NOT NULL,
   RENDA_MENSAL NUMERIC(10,2) NULL,
   TELEFONE VARCHAR(20) NULL,
   STATUS VARCHAR(20) DEFAULT('EM CADASTRO') 
   CHECK( STATUS IN ('EM CADASTRO','EM ANALISE',
                     'REPROVADA', 'APROVADA'))
)

CREATE TABLE TB_CLIENTE (
   ID_CLIENTE INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   NOME VARCHAR(100) NOT NULL,
   CPF VARCHAR(20) NOT NULL UNIQUE,
   EMAIL VARCHAR(100) NOT NULL,
   RENDA_MENSAL NUMERIC(10,2) NOT NULL,
   TELEFONE VARCHAR(20) NOT NULL
)

CREATE TABLE TB_CONTA (
    ID_CONTA INT NOT NULL IDENTITY PRIMARY KEY,
	ID_CLIENTE INT NOT NULL REFERENCES TB_CLIENTE(ID_CLIENTE),
	DT_ABERTURA DATETIME DEFAULT(GETDATE()),
	SALDO NUMERIC(10,2) NOT NULL,
	STATUS VARCHAR(10) CHECK (STATUS IN ('ATIVA','BLOQUEADA'))
)

create or alter trigger TG_SOLICITACAO_INSERT_UPDATE
on tb_solicitacao_abertura_conta
after insert, update
as
begin
	declare @id int, @nm varchar(100), @cpf varchar(20), @email varchar(100), 
	@renda numeric(10,2), @telefone varchar(20), @status varchar(20)

	declare c_solicita cursor for
	select * from inserted
	
	open c_solicita
	fetch c_solicita into @id, @nm, @cpf, @email, @renda, @telefone, @status

	while(@@fetch_status = 0)
	begin
		if @status = 'EM CADASTRO'
		begin
			if (isnull(@renda, 0) != 0) and (isnull(@telefone, 0) != 0)
			begin
				update tb_solicitacao_abertura_conta
				set status = 'EM ANALISE'
				where id_solicitacao = @id
			end
		end

		else if @status = 'APROVADA'
		begin
			declare @status_anterior varchar(20)
			set @status_anterior = (select status from deleted where id_solicitacao = @id)
			
			if @status_anterior = 'EM ANALISE'
			begin
				insert into tb_cliente values (@nm, @cpf, @email, @renda, @telefone)
				declare @id_cliente int
				set @id_cliente = (select id_cliente from tb_cliente where cpf = @cpf)
				insert into tb_conta values (@id_cliente, getdate(), 0.0, 'BLOQUEADA')
			end
		end

		fetch c_solicita into @id, @nm, @cpf, @email, @renda, @telefone, @status
	end

	close c_solicita
	deallocate c_solicita
end

insert into TB_SOLICITACAO_ABERTURA_CONTA (NOME, CPF, EMAIL, RENDA_MENSAL, TELEFONE)
values ('Caio', '08810216520', 'caio@gmail.com', 687.25, '40028922')

insert into TB_SOLICITACAO_ABERTURA_CONTA (NOME, CPF, EMAIL, RENDA_MENSAL, TELEFONE)
values ('José', '08810216521', 'jose@gmail.com', null, '40028922')

update TB_SOLICITACAO_ABERTURA_CONTA
set RENDA_MENSAL = 1800.00
where NOME = 'José'

update TB_SOLICITACAO_ABERTURA_CONTA
set STATUS = 'APROVADA'
where NOME = 'Caio'

select * from TB_SOLICITACAO_ABERTURA_CONTA
select * from TB_CLIENTE
select * from TB_CONTA
