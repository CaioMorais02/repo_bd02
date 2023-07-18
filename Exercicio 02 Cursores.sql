CREATE TABLE TB_FUNCIONARIO (
  MATRICULA INT NOT NULL PRIMARY KEY,
  NOME VARCHAR(50) NOT NULL
) 

CREATE TABLE TB_DEPENDENTES (
  ID_DEPENDENTE INT NOT NULL IDENTITY(1,1),
  MATRICULA INT NOT NULL REFERENCES TB_FUNCIONARIO(MATRICULA),
  NOME VARCHAR(50) NOT NULL
  PRIMARY KEY (ID_DEPENDENTE, MATRICULA)
)

INSERT INTO TB_FUNCIONARIO VALUES (1, 'JOSÉ RICARDO')
INSERT INTO TB_FUNCIONARIO VALUES (2, 'ANA MILLER')

INSERT INTO TB_DEPENDENTES VALUES (1, 'ROBERTA'),
                                  (1, 'RITA'),
				  (1, 'GABRIELA')

INSERT INTO TB_DEPENDENTES VALUES (2, 'GUSTAVO'),
                                   (2, 'MARIANA')

----------------------------------------------------------------

declare @matricula int, @nm_funcionario varchar(50), @nm_dependente varchar(50)

PRINT '            FUNCIONARIOS E DEPENDENTES'
PRINT ''
PRINT ' MATRICULA	NOME				NOME DEPENDENTE'

declare c_func cursor for
select matricula, nome from TB_FUNCIONARIO

open c_func
fetch c_func into @matricula, @nm_funcionario
while (@@FETCH_STATUS = 0)
	begin
		print replicate('-', 60)
		print str(@matricula, 2) + replicate(char(9), 3) + @nm_funcionario

		declare c_depen cursor for
		select nome from TB_DEPENDENTES where MATRICULA = @matricula

		open c_depen
		fetch c_depen into @nm_dependente
		while (@@FETCH_STATUS = 0)
			begin
				print replicate(' ', 32) + @nm_dependente
				fetch c_depen into @nm_dependente
			end
		close c_depen
		deallocate c_depen

		fetch c_func into @matricula, @nm_funcionario
	end
close c_func
deallocate c_func