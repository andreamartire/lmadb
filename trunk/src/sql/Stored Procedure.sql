/*ORACLE MI DA IL SEGUENTE ERRORE: ORA-00955: nome già utilizzato da un oggetto esistente!! MAH*/
CREATE PROCEDURE S2(IN ? VARCHAR(11), OUT F VARCHAR(11))
return F as VARCHAR(11);

DECLARE
     prec:=0 Integer;
     corr:=0 Integer;

BEGIN
     SELECT count(*) into prec
     FROM Bene, Fornitore
     WHERE Bene.sotto_categoria_bene=? AND Fornitore.partita_iva=Bene.fornitore
    
     IF prec>corr
        corr:=prec
        F:=Fornitore.partita_iva
     ENDIF
END


/*IN FASE DI PROGETTAZIONE :D S1

SELECT B.codice, SUM(B.importo)
FROM Bando as B, Finanziamento as F, Bene as Bn
WHERE B.codice=Bn.numero_inventario_generico AND F.bando=B.codice
GROUP BY (B.codice)

*/