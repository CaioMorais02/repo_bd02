CREATE DATABASE rev_bd

USE rev_bd

CREATE TABLE TB_DVD (
	CD_DVD INT NOT NULL PRIMARY KEY,
	TITULO VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL
)

CREATE TABLE TB_CLIENTE (
	CD_CLIENTE INT NOT NULL PRIMARY KEY,
	NM_CLIENTE VARCHAR(50) NOT NULL
)

CREATE TABLE TB_LOCACAO (
	CD_CLIENTE INT NOT NULL REFERENCES TB_CLIENTE,
	CD_DVD INT NOT NULL REFERENCES TB_DVD,
	DT_LOCACAO DATE NOT NULL,
	VALOR FLOAT NOT NULL,
	DT_DEVOLUCAO DATE,
	PRIMARY KEY(CD_CLIENTE, CD_DVD, DT_LOCACAO)
)

/* Inserts para o exerc�cio de Revisao */

-- Inserir dados na tabela TB_DVD
INSERT INTO TB_DVD (CD_DVD, TITULO, CATEGORIA)
VALUES (1, 'Filme 1', 'A��o');

-- Inserir dados na tabela TB_CLIENTE
INSERT INTO TB_CLIENTE (CD_CLIENTE, NM_CLIENTE)
VALUES (1, 'Jo�o Silva');

-- Inserir dados na tabela TB_LOCACAO
INSERT INTO TB_LOCACAO (CD_CLIENTE, CD_DVD, DT_LOCACAO, VALOR, DT_DEVOLUCAO)
VALUES (1, 1, '2023-06-19', 10.99, '2023-06-22');

-- Inserir mais dados na tabela TB_DVD
INSERT INTO TB_DVD (CD_DVD, TITULO, CATEGORIA)
VALUES (2, 'Filme 2', 'Com�dia');

INSERT INTO TB_DVD (CD_DVD, TITULO, CATEGORIA)
VALUES (3, 'Filme 3', 'Drama');

-- Inserir mais dados na tabela TB_CLIENTE
INSERT INTO TB_CLIENTE (CD_CLIENTE, NM_CLIENTE)
VALUES (2, 'Maria Souza');

INSERT INTO TB_CLIENTE (CD_CLIENTE, NM_CLIENTE)
VALUES (3, 'Pedro Santos');

INSERT INTO TB_CLIENTE (CD_CLIENTE, NM_CLIENTE)
VALUES (4, 'Caio Morais');

-- Inserir mais dados na tabela TB_LOCACAO
INSERT INTO TB_LOCACAO (CD_CLIENTE, CD_DVD, DT_LOCACAO, VALOR, DT_DEVOLUCAO)
VALUES (2, 1, '2023-06-18', 8.99, '2023-06-21');

INSERT INTO TB_LOCACAO (CD_CLIENTE, CD_DVD, DT_LOCACAO, VALOR, DT_DEVOLUCAO)
VALUES (3, 2, '2023-06-20', 7.99, '2023-06-24');

INSERT INTO TB_LOCACAO (CD_CLIENTE, CD_DVD, DT_LOCACAO, VALOR)
VALUES (3, 3, '2023-06-20', 7.99);

--------------------------------------------------------------------------------------

SELECT D.TITULO, C.NM_CLIENTE
FROM TB_DVD D INNER JOIN TB_LOCACAO L
ON (D.CD_DVD = L.CD_DVD)
INNER JOIN TB_CLIENTE C
ON (L.CD_CLIENTE = C.CD_CLIENTE)

--------------------------------------------------------------------------------------

SELECT D.TITULO, COUNT(D.CD_DVD) AS 'QUANTIDADE_DE_ALUGUEIS'
FROM TB_DVD D INNER JOIN TB_LOCACAO L
ON (D.CD_DVD = L.CD_DVD)
GROUP BY D.TITULO

--------------------------------------------------------------------------------------

SELECT D.CATEGORIA, COUNT(D.CD_DVD) AS 'QUANTIDADE_DE_ALUGUEIS'
FROM TB_DVD D INNER JOIN TB_LOCACAO L
ON (D.CD_DVD = L.CD_DVD)
GROUP BY D.CATEGORIA
HAVING COUNT(D.CD_DVD) > 100

--------------------------------------------------------------------------------------

SELECT D.TITULO, COUNT(D.CD_DVD) AS 'QUANTIDADE_DE_ALUGUEIS'
FROM TB_DVD D INNER JOIN TB_LOCACAO L
ON (D.CD_DVD = L.CD_DVD)
WHERE L.DT_DEVOLUCAO IS NOT NULL
GROUP BY D.TITULO

--------------------------------------------------------------------------------------

SELECT D.TITULO, COUNT(D.CD_DVD) AS 'QUANTIDADE_DE_ALUGUEIS'
FROM TB_DVD D INNER JOIN TB_LOCACAO L
ON (D.CD_DVD = L.CD_DVD)
WHERE YEAR(L.DT_LOCACAO) = '2018'
GROUP BY D.TITULO
HAVING COUNT(D.CD_DVD) >= 2

--------------------------------------------------------------------------------------

SELECT C.NM_CLIENTE, COUNT(C.CD_CLIENTE) AS 'QUANTIDADE_DE_ALUGUEIS'
FROM TB_CLIENTE C LEFT OUTER JOIN TB_LOCACAO L
ON (C.CD_CLIENTE = L.CD_CLIENTE)
GROUP BY C.NM_CLIENTE

--------------------------------------------------------------------------------------

SELECT NM_CLIENTE FROM TB_CLIENTE
WHERE CD_CLIENTE NOT IN (SELECT CD_CLIENTE FROM TB_LOCACAO)