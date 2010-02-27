CREATE TABLE Personale ( 
	matricola INTEGER not null,
	codice_fiscale VARCHAR(16), 
	nome VARCHAR(25),
	cognome VARCHAR(25),

	PRIMARY KEY (matricola)
);

CREATE TABLE Account ( 
	username VARCHAR(30) not null,
	password VARCHAR(32) not null,
	email VARCHAR(50) not null,
	data_registrazione DATE,
	tipologia VARCHAR(30), 
		CHECK (tipologia IN ('amministratore', 'addetto amministrativo', 'dipendente')),
	personale INTEGER,

	PRIMARY KEY (username),
	CONSTRAINT fk_matricola
		FOREIGN KEY (personale) REFERENCES Personale(matricola)
		ON DELETE CASCADE
);

CREATE TABLE  Fornitore ( 
	partita_iva VARCHAR(11) not null, 
	nome_organizzazione VARCHAR(20) not null, 
	tipologia VARCHAR(20),
		CHECK (tipologia IN ('banca', 'azienda', 'ente pubblico', 'persona fisica')),
	telefono VARCHAR(20),
	email VARCHAR(40),
	indirizzo VARCHAR(50),
			
	PRIMARY KEY ( partita_iva )
);

CREATE TABLE CategoriaBene ( 
	sigla VARCHAR(20) not null, 
		CHECK (sigla IN ('MA', 'MB', 'SA')),
	nome VARCHAR(50),
	
	PRIMARY KEY ( sigla )
);

CREATE TABLE SottoCategoriaBene ( 
	codice VARCHAR(10) not null, 
	nome VARCHAR(20), 
	categoria_bene VARCHAR(20),
			
	PRIMARY KEY ( codice ),
	CONSTRAINT fk_categoria_bene
		FOREIGN KEY ( categoria_bene ) REFERENCES CategoriaBene ( sigla )
		ON DELETE CASCADE
);

CREATE TABLE Bene (
	numero_inventario_generico INTEGER NOT NULL,
	numero_inventario_seriale INTEGER,
	importo INTEGER,
	data_acquisto DATE,
	garanzia VARCHAR(50),
	data_attivazione DATE,
	data_scadenza DATE,
	conforme CHAR(1),
		CHECK (conforme IN ('S', 'N')),
	obsoleto CHAR(1),
		CHECK (obsoleto IN ('S', 'N')),
	sotto_categoria_bene VARCHAR(10),
	fornitore VARCHAR(11),

	PRIMARY KEY (numero_inventario_generico),
	CONSTRAINT fk_sotto_categoria_bene
		FOREIGN KEY (sotto_categoria_bene) REFERENCES SottoCategoriaBene(codice)
		ON DELETE SET NULL,
	CONSTRAINT fk_fornitore
		FOREIGN KEY (fornitore) REFERENCES Fornitore (partita_iva)
		ON DELETE SET NULL
);

CREATE TABLE Bando(
	codice VARCHAR(10) NOT NULL,
	legge VARCHAR(100),
	denominazione VARCHAR(50),
	data_bando DATE,
	percentuale_finaziamento VARCHAR(10),

	PRIMARY KEY (codice)
);

CREATE TABLE Finanziamento(
	bene INTEGER,
	bando VARCHAR(10) NOT NULL,
	numero_progressivo INTEGER NOT NULL,

	PRIMARY KEY (bando, numero_progressivo),
	CONSTRAINT fk_bando
		FOREIGN KEY (bando) REFERENCES Bando(codice)
		ON DELETE CASCADE,
	CONSTRAINT fk_bene
		FOREIGN KEY (bene) REFERENCES Bene ( numero_inventario_generico )
		ON DELETE SET NULL
);

CREATE TABLE Dotazione ( 
	codice VARCHAR(10) NOT NULL,
	dipendente INTEGER,
	bene INTEGER,
	data_inizio DATE,
	data_fine DATE,
	note VARCHAR(100),

	PRIMARY KEY ( codice ),
	CONSTRAINT fk_dipendente
		FOREIGN KEY ( dipendente ) REFERENCES Personale ( matricola )
		ON DELETE CASCADE,
	CONSTRAINT fk_bene_dotazione
		FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico ) 
		ON DELETE CASCADE
);

CREATE TABLE GruppoDiLavoro (
	codice VARCHAR(10) NOT NULL,
	denominazione VARCHAR(20),
	
	PRIMARY KEY ( codice )
);

CREATE TABLE Assegnazione (
	codice VARCHAR(10) NOT NULL,
  	gruppo_di_lavoro VARCHAR(10),
  	bene INTEGER,
  	data_inizio DATE,
  	data_fine DATE,
  	note VARCHAR(100),
  	
  	PRIMARY KEY ( codice ),
  	CONSTRAINT fk_gruppo_di_lavoro
		FOREIGN KEY ( gruppo_di_lavoro ) REFERENCES GruppoDiLavoro ( codice )
		ON DELETE CASCADE,
  	CONSTRAINT fk_bene_assegnazione
		FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico )
		ON DELETE CASCADE
);

CREATE TABLE Richiesta(
	codice VARCHAR(10) NOT NULL,
   	matricola INTEGER,
   	sotto_categoria_bene VARCHAR(10),
   	data DATE,
   	motivazione VARCHAR(50),
   	esito CHAR(1), 
   		CHECK (esito IN ('S', 'N')),
		       	
   	PRIMARY KEY ( codice ),
   	CONSTRAINT fk_matricola_rich
		FOREIGN KEY ( matricola ) REFERENCES Personale(matricola)
		ON DELETE CASCADE,
   	CONSTRAINT fk_sotto_cat_bene_rich
		FOREIGN KEY ( sotto_categoria_bene ) REFERENCES SottoCategoriaBene( codice )
		ON DELETE CASCADE
);

CREATE TABLE Allocazione(
	codice VARCHAR(10) NOT NULL,
 	matricola INTEGER,
 	gruppo_di_lavoro VARCHAR(11),
 	data_inizio DATE,
 	data_fine DATE,
 	
 	PRIMARY KEY(codice),
 	CONSTRAINT fk_matr_all
		FOREIGN KEY(matricola) REFERENCES Personale(matricola)
		ON DELETE CASCADE,
 	CONSTRAINT fk_grup_di_lav_all
		FOREIGN KEY(gruppo_di_lavoro) REFERENCES GruppoDiLavoro( codice )
		ON DELETE CASCADE
);

CREATE TABLE Stanza(
	codice VARCHAR(10) NOT NULL,
	denominazione VARCHAR(11),
	posizione VARCHAR(10),
	note VARCHAR(50),
   		
   	PRIMARY KEY (codice)
);

CREATE TABLE Ubicazione(
	codice VARCHAR(10) NOT NULL,
	bene INTEGER,
	stanza VARCHAR(10),
	data_inizio DATE,
	data_fine DATE,

	PRIMARY KEY (codice),
	CONSTRAINT fk_bene_ubicazione
		FOREIGN KEY(bene) REFERENCES Bene( numero_inventario_generico )
		ON DELETE CASCADE,
	CONSTRAINT fk_stanza
		FOREIGN KEY(stanza) REFERENCES Stanza( codice )
		ON DELETE CASCADE
);

CREATE TABLE Postazione(
	codice VARCHAR(10) NOT NULL,
	matricola INTEGER,
	stanza VARCHAR(10),
	data_inizio DATE,
	data_fine DATE,

	PRIMARY KEY(codice),
	CONSTRAINT fk_matricola_postazione
		FOREIGN KEY(matricola) REFERENCES Personale(matricola)
		ON DELETE CASCADE,
	CONSTRAINT fk_stanza_postazione
		FOREIGN KEY(stanza) REFERENCES Stanza( codice )
		ON DELETE CASCADE
);	
/
CREATE OR REPLACE TRIGGER triggerPersonale
    AFTER UPDATE ON PERSONALE
FOR EACH ROW
    WHEN (old.matricola != new.matricola) 
DECLARE 
    newmatr VARCHAR(10);
    oldmatr VARCHAR(10);
BEGIN
	newmatr := :new.matricola;
	oldmatr := :old.matricola;
	UPDATE account SET personale = newmatr WHERE personale = oldmatr;
	UPDATE allocazione SET matricola = newmatr WHERE matricola = oldmatr;
	UPDATE postazione SET matricola = newmatr WHERE matricola = oldmatr;
	UPDATE richiesta SET matricola = newmatr WHERE matricola = oldmatr;
	UPDATE dotazione SET dipendente = newmatr WHERE dipendente = oldmatr;
END;
/
CREATE OR REPLACE TRIGGER triggerGruppoDiLavoro
        AFTER UPDATE ON GruppoDiLavoro
FOR EACH ROW
        WHEN (old.codice != new.codice) 
DECLARE 
        newcodice VARCHAR(10);
        oldcodice VARCHAR(10);
BEGIN
        newcodice := :new.codice;
        oldcodice := :old.codice;
       	UPDATE Ubicazione SET stanza = newcodice WHERE stanza = oldcodice;
       	UPDATE Postazione SET stanza = newcodice WHERE stanza = oldcodice;
END;
/
CREATE OR REPLACE TRIGGER triggerGruppoDiLavoro
        AFTER UPDATE ON GruppoDiLavoro
FOR EACH ROW
        WHEN (old.codice != new.codice) 
DECLARE 
        newcodice VARCHAR(10);
        oldcodice VARCHAR(10);
BEGIN
        newcodice := :new.codice;
        oldcodice := :old.codice;
       	UPDATE Assegnazione SET gruppo_di_lavoro = newcodice WHERE gruppo_di_lavoro = oldcodice;
       	UPDATE Allocazione SET gruppo_di_lavoro = newcodice WHERE gruppo_di_lavoro = oldcodice;
END;
/
CREATE OR REPLACE TRIGGER triggeBando
        AFTER UPDATE ON Bando
FOR EACH ROW
        WHEN (old.codice != new.codice) 
DECLARE 
        newcodice VARCHAR(10);
        oldcodice VARCHAR(10);
BEGIN
        newcodice := :new.codice;
        oldcodice := :old.codice;
       	UPDATE Finanziamento SET bando = newcodice WHERE bando = oldcodice;
END;
/
CREATE OR REPLACE TRIGGER triggerBene
        AFTER UPDATE ON BENE
FOR EACH ROW
        WHEN (old.numero_inventario_generico != new.numero_inventario_generico) 
DECLARE 
        newinv VARCHAR(11);
        oldinv VARCHAR(11);
BEGIN
        newinv := :new.numero_inventario_generico;
        oldinv := :old.numero_inventario_generico;
        UPDATE finanziamento SET bene = newinv WHERE bene = oldinv;
        UPDATE assegnazione SET bene = newinv WHERE bene = oldinv;
        UPDATE ubicazione SET bene = newinv WHERE bene = oldinv;
        UPDATE dotazione SET bene = newinv WHERE bene = oldinv;
END;
/
CREATE OR REPLACE TRIGGER triggerFornitore
    AFTER UPDATE ON FORNITORE
FOR EACH ROW
    WHEN (old.partita_iva != new.partita_iva) 
DECLARE 
    newpiva VARCHAR(11);
    oldpiva VARCHAR(11);
BEGIN
    newpiva := :new.partita_iva;
    oldpiva := :old.partita_iva;
    UPDATE bene SET fornitore = newpiva WHERE fornitore = oldpiva;
END;
/
CREATE OR REPLACE TRIGGER triggerCategoriaBene
    AFTER UPDATE ON CategoriaBene
FOR EACH ROW
    WHEN (old.sigla != new.sigla) 
DECLARE 
    newsigla VARCHAR(10);
    oldsigla VARCHAR(10);
BEGIN
    newsigla := :new.sigla;
    oldsigla := :old.sigla;
   	UPDATE SottoCategoriaBene SET categoria_bene = newsigla WHERE categoria_bene = oldsigla;
END;
/
CREATE OR REPLACE TRIGGER triggerSottoCategoriaBene
        AFTER UPDATE ON SottoCategoriaBene
FOR EACH ROW
        WHEN (old.codice != new.codice) 
DECLARE 
        newcodice VARCHAR(10);
        oldcodice VARCHAR(10);
BEGIN
        newcodice := :new.codice;
        oldcodice := :old.codice;
       	UPDATE Bene SET sotto_categoria_bene = newcodice WHERE sotto_categoria_bene = oldcodice;
       	UPDATE Richiesta SET sotto_categoria_bene = newcodice WHERE sotto_categoria_bene = oldcodice;
END;
