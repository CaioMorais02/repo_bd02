CREATE DATABASE PS_09

USE PS_09

CREATE TABLE TB_CLIENTE (
  CD_CLIENTE INT NOT NULL PRIMARY KEY,
  NM_CLIENTE VARCHAR(60) NOT NULL,
  CPF INT NULL,
  DT_NASCIMENTO DATETIME,
  TIPO_CLIENTE VARCHAR(40) NULL
)


CREATE TABLE TB_CONTA (
   NR_CONTA INT NOT NULL PRIMARY KEY,
   CD_CLIENTE INT NOT NULL,
   SALDO NUMERIC(10,2) NOT NULL,
)


INSERT INTO TB_CLIENTE (CD_CLIENTE, NM_CLIENTE, CPF, DT_NASCIMENTO)
VALUES
  (1, 'Jo�o da Silva', 1234, '1985-06-15'),
  (2, 'Maria Santos', 9876, '1990-03-25'),
  (3, 'Carlos Oliveira', 4567, '1980-11-02'),
  (4, 'Ana Pereira', 7894, '2000-08-10'),
  (5, 'Empresa ABC Ltda.', 1122, NULL);

-- Contas do cliente 'Jo�o da Silva'
INSERT INTO TB_CONTA (NR_CONTA, CD_CLIENTE, SALDO) VALUES
  (1, 1, 12000.50),
  (2, 1, 8000.75),
  (3, 1, 5000.20);

-- Contas do cliente 'Maria Santos'
INSERT INTO TB_CONTA (NR_CONTA, CD_CLIENTE, SALDO) VALUES
  (4, 2, 15000.00),
  (5, 2, 7000.90);

-- Contas do cliente 'Carlos Oliveira'
INSERT INTO TB_CONTA (NR_CONTA, CD_CLIENTE, SALDO) VALUES
  (6, 3, 18000.30),
  (7, 3, 9000.45),
  (8, 3, 4000.10);

-- Contas do cliente 'Ana Pereira'
INSERT INTO TB_CONTA (NR_CONTA, CD_CLIENTE, SALDO) VALUES
  (9, 4, 20000.00),
  (10, 4, 6000.50);

-- Conta da empresa 'Empresa ABC Ltda.'
INSERT INTO TB_CONTA (NR_CONTA, CD_CLIENTE, SALDO) VALUES
  (11, 5, 50000.00);

CREATE OR ALTER PROCEDURE SP_CLASSIFICA_CLIENTE (@QTD_CONTA INT, @SALDO_TOTAL NUMERIC (10, 2), @STATUS INT OUTPUT) AS
	IF @SALDO_TOTAL >= 10000
		SET @STATUS = 1 -- CLIENTE VIP

	ELSE IF @SALDO_TOTAL >= 5000 AND @SALDO_TOTAL < 10000 AND @QTD_CONTA > 2
		SET @STATUS = 1 -- CLIENTE VIP

	ELSE
		SET @STATUS = 0 -- CLIENTE NORMAL 

DECLARE @QTD_CONTA INT, @SALDO_TOTAL NUMERIC(10, 2)

SELECT A.CD_CLIENTE, COUNT(B.CD_CLIENTE), SUM(B.SALDO)
FROM TB_CLIENTE A INNER JOIN TB_CONTA B
ON (A.CD_CLIENTE = B.CD_CLIENTE)
GROUP BY A.CD_CLIENTE

---------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE SP_ATUALIZA_CLIENTE AS
	DECLARE @CD_CLIENTE INT, @QTD_CONTA INT, @SALDO_TOTAL NUMERIC(10, 2), @STATUS INT

	DECLARE C_CLIENTE CURSOR FOR
	SELECT A.CD_CLIENTE, COUNT(B.CD_CLIENTE) AS 'QTD_CONTA', SUM(B.SALDO) AS 'SALDO TOTAL'
	FROM TB_CLIENTE A INNER JOIN TB_CONTA B
	ON (A.CD_CLIENTE = B.CD_CLIENTE)
	GROUP BY A.CD_CLIENTE

	OPEN C_CLIENTE
	FETCH C_CLIENTE INTO @CD_CLIENTE, @QTD_CONTA, @SALDO_TOTAL

	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			EXEC SP_CLASSIFICA_CLIENTE @QTD_CONTA, @SALDO_TOTAL, @STATUS
			IF @STATUS = 1
				UPDATE TB_CLIENTE
				SET TIPO_CLIENTE = 'VIP'
				WHERE CD_CLIENTE = @CD_CLIENTE

			ELSE IF @STATUS = 0
				UPDATE TB_CLIENTE
				SET TIPO_CLIENTE = 'NORMAL'
				WHERE CD_CLIENTE = @CD_CLIENTE

			FETCH C_CLIENTE INTO @CD_CLIENTE, @QTD_CONTA, @SALDO_TOTAL
		END
	CLOSE C_CLIENTE
	DEALLOCATE C_CLIENTE

SELECT * FROM TB_CLIENTE
SELECT * FROM TB_CONTA

EXEC SP_ATUALIZA_CLIENTE