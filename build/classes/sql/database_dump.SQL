CREATE TABLE Personale ( 
	matricola INTEGER not null,
	codice_fiscale VARCHAR(16), 
	nome VARCHAR(25),
	cognome VARCHAR(25),

	PRIMARY KEY (matricola)
);

CREATE TABLE Account ( 
	username VARCHAR(32) not null,
	password VARCHAR(32) not null,
	email VARCHAR(50) not null,
	data_registrazione DATE,
	tipologia VARCHAR(30), 
		CHECK (tipologia IN ('amministratore', 'addetto amministrativo', 'dipendente')),
	personale INTEGER,

	PRIMARY KEY (username),
	CONSTRAINT account_fk_personale
		FOREIGN KEY (personale) REFERENCES Personale(matricola)
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
	sigla VARCHAR(2) not null, 
		CHECK (sigla IN ('MA', 'MB', 'SA')),
	nome VARCHAR(50),
	
	PRIMARY KEY ( sigla )
);

CREATE TABLE SottoCategoriaBene ( 
	codice VARCHAR(10) not null, 
	nome VARCHAR(20), 
	categoria_bene VARCHAR(2),
			
	PRIMARY KEY ( codice ),
	CONSTRAINT sottocategoria_fk_categoria
		FOREIGN KEY ( categoria_bene ) REFERENCES CategoriaBene ( sigla )
);

CREATE TABLE Bene (
	numero_inventario_generico INTEGER NOT NULL,
	numero_inventario_seriale VARCHAR(10),
	importo INTEGER,
	data_acquisto DATE,
	garanzia VARCHAR(50),
	data_attivazione DATE,
	data_scadenza DATE,
	targhetta VARCHAR(30),
	descrizione VARCHAR(100),
	conforme CHAR(1),
		CHECK (conforme IN ('S', 'N')),
	obsoleto CHAR(1),
		CHECK (obsoleto IN ('S', 'N')),
	sotto_categoria_bene VARCHAR(10),
	fornitore VARCHAR(11),

	PRIMARY KEY (numero_inventario_generico),
	CONSTRAINT bene_fk_sottocategoria
		FOREIGN KEY (sotto_categoria_bene) REFERENCES SottoCategoriaBene(codice),
	CONSTRAINT bene_fk_fornitore
		FOREIGN KEY (fornitore) REFERENCES Fornitore (partita_iva)
);

CREATE TABLE Bando (
	codice VARCHAR(10) NOT NULL,
	legge VARCHAR(100),
	denominazione VARCHAR(50),
	data_bando DATE,
	percentuale_finanziamento VARCHAR(10),

	PRIMARY KEY (codice)
);

CREATE TABLE Finanziamento(
	bene INTEGER,
	bando VARCHAR(10) NOT NULL,
	numero_progressivo INTEGER NOT NULL,

	PRIMARY KEY (bando, numero_progressivo),
	CONSTRAINT finanziamento_fk_bando
		FOREIGN KEY ( bando ) REFERENCES Bando(codice),
	CONSTRAINT finanziamento_fk_bene
		FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico )
);

CREATE TABLE Dotazione ( 
	codice VARCHAR(10) NOT NULL,
	personale INTEGER,
	bene INTEGER,
	data_inizio DATE,
	data_fine DATE,
	note VARCHAR(100),

	PRIMARY KEY ( codice ),
	CONSTRAINT dotazione_fk_personale
		FOREIGN KEY ( personale ) REFERENCES Personale ( matricola ),
	CONSTRAINT dotazione_fk_bene
		FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico ),
	CONSTRAINT dotazione_check_data
		CHECK (data_inizio < data_fine)
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
  	CONSTRAINT assegnazione_fk_gruppo
		FOREIGN KEY ( gruppo_di_lavoro ) REFERENCES GruppoDiLavoro ( codice ),
  	CONSTRAINT assegnazione_fk_bene
		FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico ),
	CONSTRAINT assegnazione_check_data
		CHECK (data_inizio < data_fine)
);

CREATE TABLE Richiesta(
	codice INTEGER NOT NULL,
   	personale INTEGER,
   	sotto_categoria_bene VARCHAR(10),
   	data DATE,
   	motivazione VARCHAR(400),
   	esito CHAR(1), 
   		CHECK (esito IN ('S', 'N', '-')),
		       	
   	PRIMARY KEY ( codice ),
   	CONSTRAINT richiesta_fk_personale
		FOREIGN KEY ( personale ) REFERENCES Personale(matricola),
   	CONSTRAINT richiesta_fk_sottocategoria
		FOREIGN KEY ( sotto_categoria_bene ) REFERENCES SottoCategoriaBene( codice )
);

CREATE TABLE Allocazione(
	codice VARCHAR(10) NOT NULL,
 	personale INTEGER,
 	gruppo_di_lavoro VARCHAR(11),
 	data_inizio DATE,
 	data_fine DATE,
 	
 	PRIMARY KEY(codice),
 	CONSTRAINT allocazione_fk_personale
		FOREIGN KEY ( personale ) REFERENCES Personale(matricola),
 	CONSTRAINT allocazione_fk_gruppo
		FOREIGN KEY ( gruppo_di_lavoro ) REFERENCES GruppoDiLavoro( codice ),
	CONSTRAINT allocazione_check_data
		CHECK (data_inizio < data_fine)
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
	CONSTRAINT ubicazione_fk_bene
		FOREIGN KEY ( bene ) REFERENCES Bene( numero_inventario_generico ),
	CONSTRAINT ubicazione_fk_stanza
		FOREIGN KEY ( stanza ) REFERENCES Stanza( codice ),
	CONSTRAINT ubicazione_check_data
		CHECK (data_inizio < data_fine)
);

CREATE TABLE Postazione(
	codice VARCHAR(10) NOT NULL,
	personale INTEGER,
	stanza VARCHAR(10),
	data_inizio DATE,
	data_fine DATE,

	PRIMARY KEY(codice),
	CONSTRAINT postazione_fk_personale
		FOREIGN KEY ( personale ) REFERENCES Personale( matricola ),
	CONSTRAINT postazione_fk_stanza
		FOREIGN KEY ( stanza ) REFERENCES Stanza( codice ),
	CONSTRAINT postazione_check_data
		CHECK (data_inizio < data_fine)
);	

-- Tabella per la gestione delle sequenze --
CREATE TABLE sequences (
	name VARCHAR(20) PRIMARY KEY,
	startval INTEGER NOT NULL,
	incr INTEGER,
	minval INTEGER,
	maxval INTEGER,
	currval INTEGER,
	cycle CHAR(1) CHECK (cycle IN ('T', 'F'))
);