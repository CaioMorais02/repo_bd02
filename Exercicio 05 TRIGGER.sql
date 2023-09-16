CREATE TABLE TB_VENDAS (
   CD_VENDA INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   DT_VENDA DATETIME NOT NULL,
   CD_PRODUTO INT NOT NULL,
   QUANTIDADE INT NOT NULL,
   VALOR NUMERIC(10,2) NOT NULL
)


/* Tabela para log de alterações na tabela de Vendas. As alterações podem
   ser de três tipos: (I - Inclusao, A - Alteracao, R - Remocao). O Log
   sempre armazena os valores antigos e os novos valores. Somente os 
   os atributos QUANTIDADE e VALOR podem ser alterados para uma venda. */

CREATE TABLE TB_LOG_VENDAS (
    CD_LOG 		INT IDENTITY (1,1) NOT NULL,
    DT_LOG 		DATETIME NOT NULL,     -- Data em que o log foi registrado
    TIPO_OPERACAO 	CHAR(1) CHECK (TIPO_OPERACAO IN ('I','A','R')),	
    CD_VENDA 		INT NULL,
    CD_PRODUTO 		INT NULL,
    DT_VENDA 		DATETIME NULL,
    QUANTIDADE_ANTIGA   INT NULL,
    VALOR_ANTIGO	NUMERIC(10,2) NULL,
    QUANTIDADE_NOVA	INT NULL,
    VALOR_NOVO		NUMERIC(10,2) NULL 
)

CREATE OR ALTER TRIGGER TG_LOG_INCLUIR_VENDA
ON TB_VENDAS
AFTER INSERT
AS
BEGIN
	DECLARE @CD_VENDA INT, @DT_VENDA DATETIME, @CD_PRODUTO INT, @QUANTIDADE INT, @VALOR NUMERIC(10,2)

	DECLARE C_VENDA CURSOR FOR
	SELECT * FROM INSERTED

	OPEN C_VENDA
	FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE, @VALOR

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO TB_LOG_VENDAS(DT_LOG, TIPO_OPERACAO, CD_VENDA, CD_PRODUTO, DT_VENDA, QUANTIDADE_NOVA, VALOR_NOVO)
		VALUES (GETDATE(), 'I', @CD_VENDA, @CD_PRODUTO, @DT_VENDA, @QUANTIDADE, @VALOR)
		
		FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE, @VALOR
	END

	CLOSE C_VENDA
	DEALLOCATE C_VENDA
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER TG_LOG_UPDATE_VENDA
ON TB_VENDAS
AFTER UPDATE
AS
BEGIN
	DECLARE @CD_VENDA INT, @DT_VENDA DATETIME, @CD_PRODUTO INT,@QUANTIDADE_ANTIGA INT, @VALOR_ANTIGO NUMERIC(10,2), @QUANTIDADE_NOVA INT, @VALOR_NOVO NUMERIC(10,2)

	DECLARE C_VENDA CURSOR FOR
	SELECT * FROM INSERTED

	OPEN C_VENDA
	FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE_NOVA, @VALOR_NOVO

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @QUANTIDADE_ANTIGA = (SELECT QUANTIDADE FROM DELETED WHERE CD_VENDA = @CD_VENDA)
		SET @VALOR_ANTIGO = (SELECT VALOR FROM DELETED WHERE CD_VENDA = @CD_VENDA)
		
		INSERT INTO TB_LOG_VENDAS (DT_LOG, TIPO_OPERACAO, CD_VENDA, CD_PRODUTO, DT_VENDA, QUANTIDADE_ANTIGA, VALOR_ANTIGO, QUANTIDADE_NOVA, VALOR_NOVO)
		VALUES (GETDATE(), 'A', @CD_VENDA, @CD_PRODUTO, @DT_VENDA, @QUANTIDADE_ANTIGA, @VALOR_ANTIGO, @QUANTIDADE_NOVA, @VALOR_NOVO)
		
		FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE_NOVA, @VALOR_NOVO
	END

	CLOSE C_VENDA
	DEALLOCATE C_VENDA
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER TG_LOG_INCLUIR_VENDA
ON TB_VENDAS
AFTER DELETE
AS
BEGIN
	DECLARE @CD_VENDA INT, @DT_VENDA DATETIME, @CD_PRODUTO INT, @QUANTIDADE INT, @VALOR NUMERIC(10,2)

	DECLARE C_VENDA CURSOR FOR
	SELECT * FROM DELETED

	OPEN C_VENDA
	FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE, @VALOR

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		INSERT INTO TB_LOG_VENDAS(DT_LOG, TIPO_OPERACAO, CD_VENDA, CD_PRODUTO, DT_VENDA, QUANTIDADE_ANTIGA, VALOR_ANTIGO)
		VALUES (GETDATE(), 'R', @CD_VENDA, @CD_PRODUTO, @DT_VENDA, @QUANTIDADE, @VALOR)
		
		FETCH C_VENDA INTO @CD_VENDA, @DT_VENDA, @CD_PRODUTO, @QUANTIDADE, @VALOR
	END

	CLOSE C_VENDA
	DEALLOCATE C_VENDA
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM TB_VENDAS

SELECT * FROM TB_LOG_VENDAS

-- Exemplo de inserção de uma venda
INSERT INTO TB_VENDAS (DT_VENDA, CD_PRODUTO, QUANTIDADE, VALOR)
VALUES ('2023-09-16 14:30:00', 1, 5, 100.00);

-- Exemplo de outra inserção de venda
INSERT INTO TB_VENDAS (DT_VENDA, CD_PRODUTO, QUANTIDADE, VALOR)
VALUES ('2023-09-17 10:45:00', 2, 10, 150.50);

-- Mais um exemplo de inserção de venda
INSERT INTO TB_VENDAS (DT_VENDA, CD_PRODUTO, QUANTIDADE, VALOR)
VALUES ('2023-09-18 16:20:00', 3, 8, 200.00);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Atualizar a quantidade e o valor da primeira venda (CD_VENDA = 8)
UPDATE TB_VENDAS
SET QUANTIDADE = 7,
    VALOR = 120.00
WHERE CD_VENDA = 8;

-- Atualizar a quantidade e o valor da segunda venda (CD_VENDA = 9)
UPDATE TB_VENDAS
SET QUANTIDADE = 12,
    VALOR = 160.00
WHERE CD_VENDA = 9;

-- Atualizar a quantidade e o valor da terceira venda (CD_VENDA = 10)
UPDATE TB_VENDAS
SET QUANTIDADE = 9,
    VALOR = 220.00
WHERE CD_VENDA = 10;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Reverter a atualização na primeira venda (CD_VENDA = 8)
DELETE FROM TB_VENDAS
WHERE CD_VENDA = 8;

-- Reverter a atualização na primeira venda (CD_VENDA = 9)
DELETE FROM TB_VENDAS
WHERE CD_VENDA = 9;

-- Reverter a atualização na primeira venda (CD_VENDA = 10)
DELETE FROM TB_VENDAS
WHERE CD_VENDA = 10;
