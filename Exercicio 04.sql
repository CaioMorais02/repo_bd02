CREATE DATABASE TG_04

USE TG_04

CREATE TABLE TB_FUNCIONARIO (
	MATRICULA INT NOT NULL PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL,
	DEPARTAMENTO VARCHAR(30) NOT NULL,
	SALARIO NUMERIC(10,2),
	GRATIFICACAO NUMERIC(10,2)
)

INSERT INTO TB_FUNCIONARIO
VALUES (1, 'CAIO', 'TI', 700.00, 300.00)

INSERT INTO TB_FUNCIONARIO
VALUES (2, 'LAIO', 'TI', 700.00, 300.00)

SELECT * FROM TB_FUNCIONARIO

UPDATE TB_FUNCIONARIO
SET SALARIO = 1000.00, GRATIFICACAO = 300.00
WHERE MATRICULA = 1

UPDATE TB_FUNCIONARIO
SET SALARIO = 1000.00, GRATIFICACAO = 400.00
WHERE MATRICULA = 2

CREATE OR ALTER TRIGGER TG_GARANTE_SALARIO
ON TB_FUNCIONARIO
AFTER UPDATE
AS
BEGIN
	DECLARE @MATRICULA INT, @SALARIO NUMERIC(10,2), @GRATIFICACAO NUMERIC(10,2), @PORCENTAGEM NUMERIC(10,2), @BRUTO_ANTIGO NUMERIC(10,2), @BRUTO_NOVO NUMERIC (10,2)
	DECLARE C_FUNC CURSOR FOR
	SELECT MATRICULA, SALARIO, GRATIFICACAO FROM DELETED

	OPEN C_FUNC
	FETCH C_FUNC INTO @MATRICULA, @SALARIO, @GRATIFICACAO

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @BRUTO_ANTIGO = @SALARIO + @GRATIFICACAO
		SET @BRUTO_NOVO = (SELECT (SALARIO + GRATIFICACAO) FROM INSERTED WHERE MATRICULA = @MATRICULA)
		SET @PORCENTAGEM = (100 * @BRUTO_NOVO / @BRUTO_ANTIGO) - 100
		IF @PORCENTAGEM < 30
		BEGIN
			PRINT 'ATUALIZA��O OCORRIDA COM SUCESSO'
		END

		ELSE
		BEGIN
			RAISERROR('SAL�RIO INV�LIDO',1 ,1)
			ROLLBACK
		END

		FETCH C_FUNC INTO @MATRICULA, @SALARIO, @GRATIFICACAO 
	END

	CLOSE C_FUNC
	DEALLOCATE C_FUNC
END