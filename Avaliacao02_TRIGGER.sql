create database avl02

use avl02

create table tb_surfista (
   id_surfista int not null,
   nome_surfista varchar(100) not null
)

insert into tb_surfista values(10, 'GABRIEL MEDINA')
insert into tb_surfista values(17, 'JULIAN WILSON')
insert into tb_surfista values(12, 'KELLY SLATER')
insert into tb_surfista values(15, 'FILIPE TOLEDO')


create table tb_bateria (
   id_bateria int not null primary key identity(1,1),
   id_surfista_1 int not null,
   id_surfista_2 int not null
)

insert into tb_bateria values (10,17)

create table tb_ondas_bateria (
   id_onda int not null primary key identity(1,1),
   id_bateria int not null,
   id_surfista int not null,
   nota_1  numeric(10,2) check (nota_1 >=0 and nota_1 <=10),
   nota_2  numeric(10,2) check (nota_2 >=0 and nota_2 <=10),
   nota_3  numeric(10,2) check (nota_3 >=0 and nota_3 <=10),
   nota_4  numeric(10,2) check (nota_4 >=0 and nota_4 <=10)
)


-- Primeira onda Gabriel
insert into tb_ondas_bateria values (1, 10, 9, 9.5, 9.3, 9.2)

-- Segunda onda Gabriel
insert into tb_ondas_bateria values (1, 10, 5, 5, 5, 5)

-- Terceira onda Gabriel
insert into tb_ondas_bateria values (1, 10, 10, 10, 10, 10)

-- Primeira Onda Julian
insert into tb_ondas_bateria values (1, 17, 8.7, 8, 8.3, 8.1)

-- Segunda Onda Julian
insert into tb_ondas_bateria values (1, 17, 9.4, 9, 9.1, 9.2)


create table tb_ondas_placar (
   id_bateria int not null,
   id_surfista int not null,
   nm_surfista varchar(100) not null,
   nota_final_onda1 numeric(10,2) null default(0.0),
   nota_final_onda2 numeric(10,2) null default(0.0),
   nota_total numeric(10,2) null default (0.0),
   primary key (id_bateria, id_surfista)
)

-- Questão 1

create or alter trigger tg_ondas_placar
on tb_bateria
after insert
as
begin
	declare @id_bateria int, @id_surf1 int, @id_surf2 int, @nm_surf1 varchar(100), @nm_surf2 varchar(100)

	declare c_bateria cursor for
	select * from inserted

	open c_bateria
	fetch c_bateria into @id_bateria, @id_surf1, @id_surf2

	while (@@FETCH_STATUS = 0)
	begin
		set @nm_surf1 = (select nome_surfista from tb_surfista where id_surfista = @id_surf1)
		set @nm_surf2 = (select nome_surfista from tb_surfista where id_surfista = @id_surf2)

		insert into tb_ondas_placar (id_bateria, id_surfista, nm_surfista)
		values (@id_bateria, @id_surf1, @nm_surf1)

		insert into tb_ondas_placar (id_bateria, id_surfista, nm_surfista)
		values (@id_bateria, @id_surf2, @nm_surf2)

		fetch c_bateria into @id_bateria, @id_surf1, @id_surf2
	end
	
	close c_bateria
	deallocate c_bateria
end

select * from tb_bateria
select * from tb_ondas_placar

-- Questão 2

create or alter trigger tg_remove_ondas_placar
on tb_bateria
after delete
as
begin
	declare @id_bateria int, @id_surf1 int, @id_surf2 int

	declare c_bateria cursor for
	select * from deleted

	open c_bateria
	fetch c_bateria into @id_bateria, @id_surf1, @id_surf2

	while(@@FETCH_STATUS = 0)
	begin
		delete from tb_ondas_placar
		where id_surfista = @id_surf1

		delete from tb_ondas_placar
		where id_surfista = @id_surf2

		fetch c_bateria into @id_bateria, @id_surf1, @id_surf2 
	end
	
	close c_bateria
	deallocate c_bateria
end

select * from tb_bateria
select * from tb_ondas_placar

delete from tb_bateria
where id_bateria = 4

-- Questão 3

create or alter trigger tg_atualizar_placar
on tb_ondas_bateria
after insert
as
begin
	declare @id_bateria int, @id_surfista int, @nota_1 numeric(10,2), @nota_2 numeric(10,2), @nota_3 numeric(10,2), @nota_4 numeric(10,2), @nota_final numeric(10,2)

	declare c_onda_bateria cursor for
	select id_bateria, id_surfista, nota_1, nota_2, nota_3, nota_4 from inserted

	open c_onda_bateria
	fetch c_onda_bateria into @id_bateria, @id_surfista, @nota_1, @nota_2, @nota_3, @nota_4

	while (@@FETCH_STATUS = 0)
	begin
		set @nota_final = (@nota_1 + @nota_2 + @nota_3 + @nota_4) / 4

		declare @id_bateria_placar int, @id_surfista_placar int, @nota_final_1 numeric(10,2), @nota_final_2 numeric(10,2), @aux numeric(10,2)
		
		declare c_onda_placar cursor for
		select id_bateria, id_surfista, nota_final_onda1, nota_final_onda2 from tb_ondas_placar

		open c_onda_placar
		fetch c_onda_placar into @id_bateria_placar, @id_surfista_placar, @nota_final_1, @nota_final_2

		while (@@FETCH_STATUS = 0)
		begin
			if (@id_bateria = @id_bateria_placar) and (@id_surfista = @id_surfista_placar)
			begin
				if (@nota_final_2 > @nota_final_1)
				begin
					if (@nota_final > @nota_final_1)
					begin
						update tb_ondas_placar
						set nota_final_onda1 = @nota_final
						where id_surfista = @id_surfista
					end
				end
				
				else
				begin
					if (@nota_final > @nota_final_2)
					begin
						update tb_ondas_placar
						set nota_final_onda2 = @nota_final
						where id_surfista = @id_surfista
					end
				end

				update tb_ondas_placar
				set nota_total = (nota_final_onda1 + nota_final_onda2) /2
				where id_surfista = @id_surfista

			end

			fetch c_onda_placar into @id_bateria_placar, @id_surfista_placar, @nota_final_1, @nota_final_2
		end

		fetch c_onda_bateria into @id_bateria, @id_surfista, @nota_1, @nota_2, @nota_3, @nota_4

		close c_onda_placar
		deallocate c_onda_placar
	end

	close c_onda_bateria
	deallocate c_onda_bateria
end

select * from tb_ondas_bateria
select * from tb_ondas_placar

-- Primeira onda Gabriel
insert into tb_ondas_bateria values (1, 10, 9, 9.5, 9.3, 9.2)

-- Segunda onda Gabriel
insert into tb_ondas_bateria values (1, 10, 5, 5, 5, 5)

-- Terceira onda Gabriel
insert into tb_ondas_bateria values (1, 10, 10, 10, 10, 10)

-- Primeira Onda Julian
insert into tb_ondas_bateria values (1, 17, 8.7, 8, 8.3, 8.1)

-- Segunda Onda Julian
insert into tb_ondas_bateria values (1, 17, 9.4, 9, 9.1, 9.2)