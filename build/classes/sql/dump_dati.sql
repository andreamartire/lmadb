--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: personale; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY personale (matricola, codice_fiscale, nome, cognome) FROM stdin;
1	rssnnt80l14b219c	Antonio	Rossi
2	vrdnnt75c09d122w	Giuseppe	Verdi
\.


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY account (username, password, email, data_registrazione, tipologia, personale) FROM stdin;
admin	asd	sasaloria@hotmail.com	2010-03-12	amministratore	\N
addetto	asd	deadlyomen17@gmail.com	2010-03-12	addetto amministrativo	\N
antonio	asd	antonio.rossi@mail.it	2010-03-12	dipendente	1
giuseppe	asd	giuseppe@mail.it	2010-03-12	dipendente	2
\.


--
-- Data for Name: gruppodilavoro; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY gruppodilavoro (codice, denominazione) FROM stdin;
gruppo2	marketing
gruppo3	segreteria
gruppo1	ricerca e sviluppo
gruppo4	gruppo casuale
\.


--
-- Data for Name: allocazione; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY allocazione (codice, personale, gruppo_di_lavoro, data_inizio, data_fine) FROM stdin;
2	1	gruppo1	2010-02-01	2010-03-20
\.


--
-- Data for Name: categoriabene; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY categoriabene (sigla, nome) FROM stdin;
SA	Strumenti e Attrezzature
MA	Mobili e Arredi
MB	Materiale Bibliografico
\.


--
-- Data for Name: fornitore; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY fornitore (partita_iva, nome_organizzazione, tipologia, telefono, email, indirizzo) FROM stdin;
00102456210	exeura spa	azienda	0984-982130	info@exeura.it	rende, via di merda
\.


--
-- Data for Name: sottocategoriabene; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY sottocategoriabene (codice, nome, categoria_bene) FROM stdin;
1	notebook	SA
2	stampanti	SA
3	scrivanie	MA
4	manuali	MB
5	Divano	MA
\.


--
-- Data for Name: bene; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY bene (numero_inventario_generico, numero_inventario_seriale, importo, data_acquisto, garanzia, data_attivazione, data_scadenza, targhetta, descrizione, conforme, obsoleto, sotto_categoria_bene, fornitore) FROM stdin;
1	1/SA	899	2010-03-12	1 anno	2010-03-12	\N	acer 5920G	notebook acer alte prestazioni	S	N	1	\N
2	1/MA	200	2010-03-12	\N	\N	\N	Scrivania 1	scrivania per ufficio	S	N	3	\N
\.


--
-- Data for Name: assegnazione; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY assegnazione (codice, gruppo_di_lavoro, bene, data_inizio, data_fine, note) FROM stdin;
ass1	gruppo1	1	2010-02-01	2010-03-20	gruppo assegnazione
\.


--
-- Data for Name: bando; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY bando (codice, legge, denominazione, data_bando, percentuale_finanziamento) FROM stdin;
bando1	legge 201/2002	bando di prova	2010-03-01	70
bando3	legge 201/2002	bando di merda	2010-03-01	15
\.


--
-- Data for Name: dotazione; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY dotazione (codice, personale, bene, data_inizio, data_fine, note) FROM stdin;
dt1	1	1	2010-03-02	2010-03-30	acer5920 assegnato
dt5	1	2	2010-03-01	2010-03-30	ti ho assegnato una scrivania
dt6	2	1	2010-02-01	2010-03-20	
\.


--
-- Data for Name: finanziamento; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY finanziamento (bene, bando, numero_progressivo) FROM stdin;
\.


--
-- Data for Name: stanza; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY stanza (codice, denominazione, posizione, note) FROM stdin;
2	stanza1	1	fuck
\.


--
-- Data for Name: postazione; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY postazione (codice, personale, stanza, data_inizio, data_fine) FROM stdin;
\.


--
-- Data for Name: richiesta; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY richiesta (codice, personale, sotto_categoria_bene, data, motivazione, esito) FROM stdin;
1	1	1	2010-03-12	mi serve un notebook	S
3	1	4	2010-03-12	sarebbe utile un manuale di java ee	N
2	1	3	2010-03-12	mi serve una scrivania	S
4	1	4	2010-03-13	manuale c++	S
5	1	5	2010-03-14	mi serve un divano	N
\.


--
-- Data for Name: sequences; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY sequences (name, startval, incr, minval, maxval, currval, cycle) FROM stdin;
matricole	0	1	-2147483648	2147483647	2	F
stanza	0	1	-2147483648	2147483647	2	F
assegnazioni	0	1	-2147483648	2147483647	2	F
allocazioni	0	1	-2147483648	2147483647	2	F
sottoCategoriaBene	0	1	-2147483648	2147483647	6	F
bando	0	1	-2147483648	2147483647	3	F
dotazioni	0	1	-2147483648	2147483647	7	F
richieste	0	1	-2147483648	2147483647	5	F
\.


--
-- Data for Name: ubicazione; Type: TABLE DATA; Schema: public; Owner: basididati
--

COPY ubicazione (codice, bene, stanza, data_inizio, data_fine) FROM stdin;
\.


--
-- PostgreSQL database dump complete
--

