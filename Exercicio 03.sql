CREATE DATABASE ex03

USE ex03

CREATE TABLE TB_FUNCIONARIO (
	MATRICULA INT NOT NULL,
	NM_FUNCIONARIO VARCHAR(40) NOT NULL,
	ESTADO CHAR(2) NOT NULL,
	SALARIO NUMERIC (10,2)
)

CREATE TABLE TB_FUNCIONARIO_SE (
	MATRICULA INT NOT NULL,
	NM_FUNCIONARIO VARCHAR(40) NOT NULL,
	ESTADO CHAR(2) CHECK(ESTADO = 'SE'),
	SALARIO NUMERIC (10,2)
)

CREATE TABLE TB_FUNCIONARIO_PB (
	MATRICULA INT NOT NULL,
	NM_FUNCIONARIO VARCHAR(40) NOT NULL,
	ESTADO CHAR(2) CHECK(ESTADO = 'PB'),
	SALARIO NUMERIC (10,2)
)

CREATE TABLE TB_FUNCIONARIO_AL (
	MATRICULA INT NOT NULL,
	NM_FUNCIONARIO VARCHAR(40) NOT NULL,
	ESTADO CHAR(2) CHECK(ESTADO = 'AL'),
	SALARIO NUMERIC (10,2)
)

CREATE VIEW VW_FUNCIONARIOS
AS
SELECT * FROM TB_FUNCIONARIO_SE
UNION ALL
SELECT * FROM TB_FUNCIONARIO_PB
UNION ALL
SELECT * FROM TB_FUNCIONARIO_AL

INSERT INTO VW_FUNCIONARIOS (MATRICULA, NM_FUNCIONARIO, ESTADO, SALARIO)
VALUES (1, 'JOS�', 'SE', 4500.00)