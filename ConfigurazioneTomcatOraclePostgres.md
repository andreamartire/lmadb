_Lo scopo della guida è installare un DBMS, PostgreSQL (preferibile) o Oracle XE, e il web-server Apache Tomcat, e configurare un ambiente eclipse in cui lavorare_

### Requisiti minimi: ###
  * <a href='http://www.oracle.com/technetwork/java/javase/downloads/index.html'>Java Development Kit - jdk </a>
  * <a href='http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR1/eclipse-jee-helios-SR1-linux-gtk.tar.gz'>Eclipse for Java EE</a>
  * Un po di pazienza



&lt;hr&gt;



# DBMS #

## _Oracle 10G XE_ ##

### Installazione ###
> Windows -> scaricare e installare <a href='http://download.oracle.com/otn/nt/oracle10g/xe/10201/OracleXE.exe'>questo exe</a> <br>
<blockquote>GNU/Linux -> scaricare <a href='http://download.oracle.com/otn/linux/oracle10g/xe/10201/oracle-xe_10.2.0.1-1.0_i386.deb'>questo deb</a></blockquote>

<h3>Configurazione</h3>
<blockquote>GNU/Linux -> <code>sudo /etc/init.d/oracle-xe configure</code> inserite una pass, infine scegliete se avviarlo automaticamente o no<br>
Windows -> durante l'installazione viene chiesta la pass e viene visualizzata una finestra con le info necessarie</blockquote>

<h3>Far partire il server oracle</h3>
<blockquote>GNU/Linux -> <code>sudo /etc/init.d/oracle-xe restart</code><br>
Windows -> viene installato come servizio quindi parte sempre all'avvio..</blockquote>

<h3>Primo avvio</h3>
<blockquote>nel vostro browser preferito andate all'indirizzo: <a href='http://localhost:8080/apex'>http://localhost:8080/apex</a> <br>
appare la pagina di login in oracle, inserite "system" come username e come password quella scelta in fase di configurazione <br>
ora siete nella pagina di gestione del dbms. Administration -> DataBase Users -> Create per creare il vostro account <br>
scegliete una username e una password e spuntate la casellina DBA dopo di che cliccate su create <br>
ora effettuate il logout e poi il login con l'account appena creato <br></blockquote>

<blockquote>questa è l'interfaccia da DBA, per creare tabelle graficamente andate in Object Browser -> Create, per scrivere codice SQL andate in SQL -> SQL Commands <br></blockquote>

<blockquote>per caricare lo script di creazione del nostro db andate in SQL -> SQL Scripts <br>
qui scegliete la View "Details" e cliccate su Go <br>
dovreste vedere "no data found"...per caricare lo script cliccate sul pulsante Upload, sfoglia per arrivare al file e poi Upload <br>
ora trovate il file nella tabella, cliccate sul semaforino Run e poi confermate col pulsante Run <br>
per vedere il risultato dell'importazione cliccate su View Results<br>
se tutto è andato bene dovreste vedere: With Errors 0 <br></blockquote>

<blockquote>a questo punto il db è caricato sul server oracle...per vederlo potete tornare alla home e scegliere Object Browser</blockquote>

<br><br>

<h2><i>PostgreSQL 8.4</i></h2>

<h3>Installazione</h3>

<blockquote>GNU/Linux -> <code>$ sudo apt-get install postgresql phppgadmin</code></blockquote>

<blockquote><i>postgresql è l'applicazione dbms vera e propria, phppgadmin è l'applicativo web per gestire il dbms, qualcosa di simile all'apex di oracle.</i></blockquote>

<blockquote><b>NB: riavviare il sistema dopo l'installazione anche se non viene chiesto</b></blockquote>


<h3>Configurazione e Creazione database</h3>

<blockquote>Impostazione di una password per il superuser postgres: <code>$ sudo passwd postgres</code></blockquote>

<blockquote>Login come superutente: <code>$ su postgres</code></blockquote>

<blockquote>Lanciamo il prompt di comandi SQL di postgres: <code>$ psql</code></blockquote>

<blockquote>Creiamo il nostro utente dba: <code># CREATE USER basididati WITH PASSWORD 'basididati' CREATEDB;</code></blockquote>

<blockquote>Creiamo il nostro database: <code># CREATE DATABASE database WITH OWNER basididati;</code></blockquote>

<blockquote>Usciamo da psql: <code># \q</code></blockquote>

<blockquote>Logout postgres: <code>$ exit</code></blockquote>


<h3>Importazione script SQL per la definizione del database</h3>

<blockquote>Entrare nell'ambiente phpPgAdmin da browser:<br>
<blockquote><a href='http://localhost/phppgadmin'>http://localhost/phppgadmin</a></blockquote></blockquote>

<blockquote>Nel menu a sinistra cliccare su "PostgreSQL"</blockquote>

<blockquote>Cliccare su "database"</blockquote>

<blockquote>Nella pagina che appare cliccare su "SQL" nella barra delle icone</blockquote>

<blockquote>Cliccare su "Sfoglia" e selezionare lo script SQL da caricare</blockquote>

<blockquote>Cliccare su "Esegui"</blockquote>

<br>
<br>
<hr><br>
<br>
<br>
<br>
<h1>TOMCAT</h1>

<h3>Ottenere Tomcat 6.x</h3>
Scaricare la versione 6 di tomcat: <br>
<ul><li>GNU/Linux - <a href='http://apache.panu.it/tomcat/tomcat-6/v6.0.24/bin/apache-tomcat-6.0.24.tar.gz'>http://apache.panu.it/tomcat/tomcat-6/v6.0.24/bin/apache-tomcat-6.0.24.tar.gz</a>
</li><li>Windows - <a href='http://apache.panu.it/tomcat/tomcat-6/v6.0.24/bin/apache-tomcat-6.0.24.exe'>http://apache.panu.it/tomcat/tomcat-6/v6.0.24/bin/apache-tomcat-6.0.24.exe</a></li></ul>

<h3>Installazione</h3>

<ul><li>GNU/Linux:<br>
<blockquote>Estrarre l'archivio e copiare la cartella tomcat estratta nella directory<br>
in cui si vuole installarlo. (in questo esempio /usr/local/tomcat)<br>
Aprire come root il file conf/server.xml e cambiare porta da 8080 a 8181:<br>
<pre><code>&lt;Connector port="8181" protocol="HTTP/1.1" <br>
connectionTimeout="20000" <br>
redirectPort="8443" /&gt;<br>
</code></pre>
Per avviare il server: sh /usr/local/tomcat/bin/startup.sh<br>
Per fermare il server: sh /usr/local/tomcat/bin/shutdown.sh</blockquote></li></ul>

<ul><li>Windows:<br>
<blockquote>Eseguire l'eseguibile scaricato e seguire l'installazione. Scegliere "full" come tipo di installazione. Scegliere la porta 8181 e impostare uno username e una password. <br>
A fine installazione scegliere di avviare tomcat.<br>
Tomcat verrà installato nella directory: C:\Programmi\Apache Software Foundation\Tomcat 6.0</blockquote></li></ul>

Una volta installato ed avviato il server aprire un browser e inserire <a href='http://127.0.0.1:8181/'>http://127.0.0.1:8181/</a> nella barra degli indirizzi; se viene visualizzata la pagina di benvenuto di tomcat l'installazione è andata a buon fine.<br>
<br>
Per testare ulteriormente il server web creare un file test.html nella directory webapps/ROOT di tomcat, contenente questo testo:<br>
<br>
<pre><code>&lt;html&gt;<br>
  &lt;head&gt;<br>
    &lt;title&gt;Test Tomcat&lt;/title&gt;<br>
  &lt;/head&gt;<br>
  &lt;body&gt;<br>
    &lt;h1&gt;Prova andata a buon fine&lt;/h1&gt;<br>
  &lt;/body&gt;<br>
&lt;/html&gt;<br>
</code></pre>

Da browser inserire <a href='http://127.0.0.1:8181/test.html'>http://127.0.0.1:8181/test.html</a>, il risultato dovrebbe essere<br>
una pagina dal titolo "Test Tomcat" e contenente "Prova andata a buon fine"<br>
<br>
<h3>Configurazione di tomcat</h3>
<blockquote>Per creare un utente manager di tomcat, aprire il file tomcat-users.xml nella cartella conf/ di tomcat e inserire all'interno dei tag <br>
<br>
<tomcat-users><br>
<br>
 .. <br>
<br>
</tomcat-users><br>
<br>
:<br>
<pre><code>&lt;role rolename="manager"/&gt;<br>
&lt;user username="USERNAME" password="PASSWORD" roles="manager"/&gt;<br>
</code></pre>
Per testare la buona riuscita dell'operazione, riavviare tomcat, andare su <a href='http://127.0.0.1:8181/manager/html'>http://127.0.0.1:8181/manager/html</a> e inserire nome utente e password scritti nel file.<br>
Dovrebbe caricarsi la pagina del manager di tomcat.</blockquote>

<blockquote>Per far si che le servlet e le jsp create possono connettersi al database, bisogna importare in tomcat i driver JDBC del DBMS in uso:<br>
Copiare i driver JDBC del DBMS nella cartella lib di tomcat <br>
<blockquote>(Windows > C:\Programmi\Apache Software Foundation\Tomcat 6.0\lib <br>   		GNU/Linux > /usr/local/tomcat/lib ). <br>
Per Oracle copiare il jar <a href='http://download.oracle.com/otn/utilities_drivers/jdbc/10204/ojdbc14.jar'>ojdbc14.jar</a><br>
Per postgreSQL copiare il jar <a href='http://jdbc.postgresql.org/download/postgresql-8.4-701.jdbc4.jar'>postgresql-8.4-701.jdbc4.jar</a></blockquote></blockquote>

<blockquote><i>OPZIONALE: se non volete creare la connessione col classico Class.forName etc</i><br>
Aprire il file context.xml nella cartella conf di tomcat con un editor di testo e sostituire la<br>
parte interna al tag <br>
<br>
<context><br>
<br>
 <br>
<br>
</context><br>
<br>
 con la seguente:<br>
<pre><code>&lt;Resource auth="Container" driverClassName="oracle.jdbc.OracleDriver" maxActive="4" maxIdle="2" <br>
maxWait="5000" name="jdbc/oraclexe" password="TUAPASSWORD" type="javax.sql.DataSource" <br>
url="jdbc:oracle:thin:@localhost:1521:xe" username="TUOUSERNAME"/&gt;<br>
<br>
&lt;Resource auth="Container" driverClassName="org.postgresql.Driver" maxActive="4" maxIdle="2" <br>
maxWait="5000" name="jdbc/postgres" password="TUAPASSWORD" type="javax.sql.DataSource" <br>
url="jdbc:postgresql://localhost/database" username="TUOUSERNAME"/&gt;<br>
</code></pre>
Salvare il file e passare ad eclipse.</blockquote>

<h3>Integrazione in Eclipse EE</h3>

1. <b>Creare il server tomcat per eclipse</b>
<ul><li>New -> Other -> Server -> Server<br>
</li><li>Server's Host Name: localhost<br>
</li><li>Select the server type -> Apache -> tomcat v6.0 Server<br>
</li><li>next<br>
</li><li>tomcat installation directory: /usr/local/tomcat<br>
</li><li>finish</li></ul>

2. <b>Creare un progetto</b>
<ul><li>New -> Dynamic Web Project<br>
</li><li>Project name: your project name<br>
</li><li>Target Runtime: Apache Tomcat v6.0<br>
</li><li>finish</li></ul>

3. <b>Creare servlet e jsp</b>
<ul><li>click destro sul progetto appena creato<br>
</li><li>New -> Servlet<br>
</li><li>Class name: TestServlet<br>
</li><li>Finish</li></ul>

Si aprirà nell'editor la servlet appena creata, con già scritte le intestazioni dei metodi doGet e doPost; <br>
Copiare nel metodo doGet:<br>
<pre><code>PrintWriter out = response.getWriter();<br>
<br>
out.println( <br>
		"&lt;html&gt;" +<br>
		   "&lt;head&gt;" +<br>
		      "&lt;title&gt;Test Servlet&lt;/title&gt;" +<br>
		   "&lt;/head&gt;" +<br>
		   "&lt;body&gt;" +<br>
		      "&lt;center&gt;&lt;font size=4&gt;Test Servlet ok!&lt;/font&gt;&lt;center&gt;" +<br>
		   "&lt;/body&gt;" +<br>
		"&lt;/html&gt;" <br>
);<br>
</code></pre>

Stoppare il server tomcat se avviato<br>
<ul><li>Windows: click destro sull'icona di tomcat nella barra delle applicazione, e selezionare Stop Service;<br>
<blockquote>Per evitare che si avvii automaticamente: click destro -> Configure -> Startup type: Manual -> Stop -> Ok<br>
</blockquote></li><li>GNU/Linux: eseguire lo script shutdown.sh</li></ul>

Eseguire la servlet: Click destro -> Run as -> Run on Server<br>
Se tutto è andato bene apparirà una pagina nel web browser con il test Test Servlet ok.<br>
<br>
<br>
<br>
<p><p>