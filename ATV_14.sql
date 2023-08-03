CREATE DATABASE ATV_14

USE ATV_14

CREATE OR ALTER FUNCTION dbo.SP_IMPOSTO_DE_RENDA(@RENDA NUMERIC(10, 2))
RETURNS NUMERIC(10, 2)
AS
BEGIN
	IF @RENDA < 1372.82
		RETURN 0

	ELSE 
		IF @RENDA < 2743.25
			RETURN (@RENDA + (@RENDA * 15/100) - 205.92)

	RETURN (@RENDA + (@RENDA * 15/100) - 205.92)
END

DECLARE @IMPOSTO NUMERIC(10, 2)
EXEC @IMPOSTO = dbo.SP_IMPOSTO_DE_RENDA 1500.00
PRINT @IMPOSTO