CREATE TABLE Personale ( 
				matricola VARCHAR(10),
				codice_fiscale VARCHAR(16), 
				nome VARCHAR(25),
				cognome VARCHAR(25),
			
				PRIMARY KEY (matricola)
);

CREATE TABLE Account ( 
				username VARCHAR(30),
				password VARCHAR(32),
				email VARCHAR(50),
				data_registrazione DATE,
				tipologia VARCHAR(30),
				personale VARCHAR(10),

				PRIMARY KEY (username),
				CONSTRAINT fk_matricola
					FOREIGN KEY (personale) REFERENCES Personale(matricola)
);

CREATE TABLE  Fornitore ( 
				partita_iva VARCHAR(11), 
				nome_organizzazione VARCHAR(20), 
				tipologia VARCHAR(20),
				telefono VARCHAR(20),
				email VARCHAR(40),
				indirizzo VARCHAR(50),
						
				PRIMARY KEY ( partita_iva )
);
	
CREATE TABLE CategoriaBene ( 
				sigla VARCHAR(20),
				nome VARCHAR(50),
				
				PRIMARY KEY ( sigla )
);
	
CREATE TABLE SottoCategoriaBene ( 
				codice VARCHAR(10), 
				nome VARCHAR(20), 
				categoria_bene VARCHAR(20),
						
				PRIMARY KEY ( codice ),
				CONSTRAINT fk_categoria_bene
					FOREIGN KEY ( categoria_bene ) REFERENCES CategoriaBene ( sigla )
);

CREATE TABLE Bene (
				numero_inventario_generico INTEGER,
				numero_inventario_seriale INTEGER,
				importo FLOAT,
				data_acquisto DATE,
				garanzia VARCHAR(50),
				data_attivazione DATE,
				data_scadenza DATE,
				conforme CHAR(1),
				obsoleto CHAR(1),
				sotto_categoria_bene VARCHAR(10),
				fornitore VARCHAR(11),

				PRIMARY KEY (numero_inventario_generico),
				CONSTRAINT fk_sotto_categoria_bene
					FOREIGN KEY (sotto_categoria_bene) REFERENCES SottoCategoriaBene(codice),
				CONSTRAINT fk_fornitore
					FOREIGN KEY (fornitore) REFERENCES Fornitore (partita_iva)
);

CREATE TABLE Bando(
				codice VARCHAR(10),
				legge VARCHAR(100),
				denominazione VARCHAR(50),
				data_bando DATE,
				percentuale_finaziamento VARCHAR(10),

				PRIMARY KEY (codice)
);

CREATE TABLE Finanziamento(
				bene INTEGER,
				bando VARCHAR(10),
				numero_progressivo INTEGER,

				PRIMARY KEY (bando, numero_progressivo),
				CONSTRAINT fk_bando
					FOREIGN KEY (bando) REFERENCES Bando(codice),
				CONSTRAINT fk_bene
					FOREIGN KEY (bene) REFERENCES Bene ( numero_inventario_generico )
);

CREATE TABLE Dotazione ( 
				codice VARCHAR(10),
				dipendente VARCHAR(10),
				bene INTEGER,
				data_inizio DATE,
				data_fine DATE,
				note VARCHAR(199),
				
				PRIMARY KEY ( codice ),
				CONSTRAINT fk_dipendente
					FOREIGN KEY ( dipendente ) REFERENCES Personale ( matricola ),
				CONSTRAINT fk_bene_dotazione
					FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico ) 
);

CREATE TABLE GruppoDiLavoro (
				codice VARCHAR(10),
				denominazione VARCHAR(20),
				
				PRIMARY KEY ( codice )
);

CREATE TABLE Assegnazione(
				codice VARCHAR(10) NOT NULL,
			  	gruppo_di_lavoro VARCHAR(10),
			  	bene INTEGER,
			  	data_inizio DATE,
			  	data_fine DATE,
			  	note VARCHAR(50),
			  	
			  	PRIMARY KEY ( codice ),
			  	CONSTRAINT fk_gruppo_di_lavoro
					FOREIGN KEY ( gruppo_di_lavoro ) REFERENCES GruppoDiLavoro ( codice ),
			  	CONSTRAINT fk_bene_assegnazione
					FOREIGN KEY ( bene ) REFERENCES Bene ( numero_inventario_generico )
);

CREATE TABLE Richiesta(
				codice VARCHAR(10) NOT NULL,
		       	matricola VARCHAR(10),
		       	sottocategoria_bene VARCHAR(10),
		       	data DATE,
		       	motivazione VARCHAR(50),
		       	esito CHAR(1),
		       	
		       	PRIMARY KEY ( codice ),
		       	CONSTRAINT fk_matricola_rich
					FOREIGN KEY ( matricola ) REFERENCES Personale(matricola),
		       	CONSTRAINT fk_sotto_cat_bene_rich
					FOREIGN KEY ( sottocategoria_bene ) REFERENCES SottoCategoriaBene( codice )
);

CREATE TABLE Allocazione(
				codice VARCHAR(10) NOT NULL,
			 	matricola VARCHAR(10),
			 	gruppo_di_lavoro VARCHAR(11),
			 	data_inizio DATE,
			 	data_fine DATE,
			 	
			 	PRIMARY KEY(codice),
			 	CONSTRAINT fk_matr_all
					FOREIGN KEY(matricola) REFERENCES Personale(matricola),
			 	CONSTRAINT fk_grup_di_lav_all
					FOREIGN KEY(gruppo_di_lavoro) REFERENCES GruppoDiLavoro( codice )
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
					FOREIGN KEY(bene) REFERENCES Bene( numero_inventario_generico ),
				CONSTRAINT fk_stanza
					FOREIGN KEY(stanza) REFERENCES Stanza( codice )
);

CREATE TABLE Postazione(
				codice VARCHAR(10) NOT NULL,
				matricola VARCHAR(10),
				stanza VARCHAR(10),
				data_inizio DATE,
				data_fine DATE,
			
				PRIMARY KEY(codice),
				CONSTRAINT fk_matricola_postazione
					FOREIGN KEY(matricola) REFERENCES Personale(matricola),
				CONSTRAINT fk_stanza_postazione
					FOREIGN KEY(stanza) REFERENCES Stanza( codice )
);