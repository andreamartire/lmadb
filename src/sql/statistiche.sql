-- statistica 1 - dato un bando, ritorna la somma degli importi dei beni finanziati attraverso questo bando --

-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica1( bando IN VARCHAR )
RETURN NUMBER IS 
somma NUMBER;

BEGIN
	SELECT sum(importo) INTO somma
	FROM bene B JOIN finanziamento F ON B.numero_inventario_generico = F.bene
	WHERE F.bando = bando;

	RETURN somma;
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica1( bando IN VARCHAR )
RETURNS INTEGER AS $$
DECLARE somma INTEGER;

BEGIN
	SELECT sum(importo) INTO somma
	FROM bene B JOIN finanziamento F ON B.numero_inventario_generico = F.bene
	WHERE F.bando = bando;

	RETURN somma;
END;
$$ LANGUAGE plpgsql;


-- statistica 2 - data una sottocat ritorna il fornitore che ha fornito più beni di questa sottocat -- 

-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica2( sottocategoria IN VARCHAR )
RETURN VARCHAR IS 
forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria
	GROUP BY fornitore
	HAVING count(numero_inventario_generico) >= ALL (
		SELECT count(numero_inventario_generico)
		FROM bene
		WHERE sotto_categoria_bene = sottocategoria
		GROUP BY fornitore
	);

	RETURN forn;
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica2( sottocategoria IN VARCHAR )
RETURNS VARCHAR AS $$
DECLARE 
	forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria
	GROUP BY fornitore
	HAVING count(numero_inventario_generico) >= ALL (
		SELECT count(numero_inventario_generico)
		FROM bene
		WHERE sotto_categoria_bene = sottocategoria
		GROUP BY fornitore
	);

	RETURN forn;
END;
$$ LANGUAGE plpgsql;

-- alternativa con cursore: --
-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica2( sottocategoria IN VARCHAR )
RETURN VARCHAR IS 
forn VARCHAR(11);
nummax NUMBER;
CURSOR c1 IS
	SELECT count(numero_inventario_generico) AS numbeni, fornitore
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria
	GROUP BY fornitore;

BEGIN
	nummax := 0;
	forn := 'nessuno';
	FOR rec IN c1 
	LOOP
		IF rec.numbeni > nummax THEN
			nummax := rec.numbeni;
  			forn := rec.fornitore;
		END IF;
	END LOOP;

	RETURN forn;
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica2( sottocategoria IN VARCHAR )
RETURNS VARCHAR AS $$ 
DECLARE 
	forn VARCHAR;
	nummax INTEGER;
	c1 CURSOR IS
	 SELECT count(numero_inventario_generico) AS numbeni, fornitore
	 FROM bene
	 WHERE sotto_categoria_bene = sottocategoria
	 GROUP BY fornitore;

BEGIN
	nummax := 0;
	forn := 'nessuno';
	FOR rec IN c1 
	LOOP
		IF rec.numbeni > nummax THEN
			nummax := rec.numbeni;
  			forn := rec.fornitore;
		END IF;
	END LOOP;

	RETURN forn;
END;
$$ LANGUAGE plpgsql;

-- statistica 3 --

-- prima interpretazione: il fornitore che fornito un bene con l'importo  --
-- più basso o più alto, di una data sottocat e in una dato periodo  --
-- (le probabilità che sia unico sono pochissime e la function si aspetta un solo valore -> errore) --
-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica3( sottocategoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURN VARCHAR IS 
forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria 
		AND data_acquisto >= datainizio 
		AND data_acquisto <= datafine
		AND (importo >= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		) OR importo <= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		));

	RETURN forn;
END;

-- seconda interpretazione: --

-- statistica3.1: fornitore importo più basso --
-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica31( sottocategoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURN VARCHAR IS 
forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria AND data_acquisto >= datainizio AND data_acquisto <= datafine
		AND importo <= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		);

	RETURN forn;
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica31( sottocategoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURNS VARCHAR AS $$
DECLARE
	forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria AND data_acquisto >= datainizio AND data_acquisto <= datafine
		AND importo <= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		);

	RETURN forn;
END;
$$ language plpgsql;

-- statistica3.2: fornitore importo più alto --
-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica32( sottocategoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURN VARCHAR IS 
forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria AND data_acquisto >= datainizio AND data_acquisto <= datafine
		AND importo >= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		);

	RETURN forn;
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica32( sottocategoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURNS VARCHAR AS $$
DECLARE 
	forn VARCHAR(11);

BEGIN
	SELECT fornitore INTO forn
	FROM bene
	WHERE sotto_categoria_bene = sottocategoria AND data_acquisto >= datainizio AND data_acquisto <= datafine
		AND importo >= ALL (
			SELECT importo
			FROM bene
			WHERE sotto_categoria_bene = sottocategoria
		);

	RETURN forn;
END;
$$ language plpgsql;

-- statistica 4 - visualizzare la percentuale dei beni acquistati in un dato periodo,  --
-- di una data categoria, coperti da un bando di finanziamento. --
-- PL/SQL --
CREATE OR REPLACE FUNCTION statistica4( categoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURN VARCHAR IS 
percent NUMBER;
benitot NUMBER;
benifinanziati NUMBER;

BEGIN
	SELECT count(*) INTO benitot
	FROM bene B JOIN sottocategoriabene S ON B.sotto_categoria_bene = S.codice
	WHERE S.categoria_bene = categoria AND B.data_acquisto >= datainizio AND B.data_acquisto <= datafine;

	SELECT count(*) into benifinanziati
	FROM bene B JOIN finanziamento F ON F.bene = B.numero_inventario_generico 
		JOIN sottocategoriabene S ON B.sotto_categoria_bene = S.codice
	WHERE S.categoria_bene = categoria AND B.data_acquisto >= datainizio AND B.data_acquisto <= datafine;
	
    IF benitot = 0 THEN
        percent := 0;
    ELSE 
        percent := benifinanziati /  benitot * 100;
    END IF;

	RETURN percent || '%';
END;

-- PL/pgSQL --
CREATE OR REPLACE FUNCTION statistica4( categoria IN VARCHAR, datainizio IN DATE, datafine IN DATE )
RETURNS VARCHAR AS $$
DECLARE 
	percent NUMERIC;
	benitot NUMERIC;
	benifinanziati NUMERIC;

BEGIN
	SELECT count(*) INTO benitot
	FROM bene B JOIN sottocategoriabene S ON B.sotto_categoria_bene = S.codice
	WHERE S.categoria_bene = categoria AND B.data_acquisto >= datainizio AND B.data_acquisto <= datafine;

	SELECT count(*) into benifinanziati
	FROM bene B JOIN finanziamento F ON F.bene = B.numero_inventario_generico 
		JOIN sottocategoriabene S ON B.sotto_categoria_bene = S.codice
	WHERE S.categoria_bene = categoria AND B.data_acquisto >= datainizio AND B.data_acquisto <= datafine;
	
    IF benitot = 0 THEN
        percent := 0;
    ELSE 
        percent := benifinanziati /  benitot * 100;
    END IF;

	RETURN percent || '%';
END;
$$ language plpgsql;