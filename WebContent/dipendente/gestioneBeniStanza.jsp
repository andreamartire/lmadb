<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Beni Stanza</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
Connection conn;
HttpSession sess;

public ResultSet getBeniAssegnatiPropriaStanzaCorrFiltTarghNSottoC(String t, String nC) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT U.bene, B.targhetta, S.codice, S.nome,ST.denominazione,B.descrizione" +
			"FROM sottocategoriabene S, ubicazione U, account A, postazione P, bene B, stanza ST " +
			"WHERE A.username = ? AND P.personale = A.personale AND P.stanza = U.stanza AND "+
			"U.data_inizio<=current_date AND U.data_fine>=current_date AND " +
			"B.numero_inventario_generico = U.bene AND S.codice = B.sotto_categoria_bene "+
			"AND upper(B.targhetta) LIKE upper(?) AND upper(S.nome) LIKE upper(?) AND U.Stanza = ST.codice ");
	st.setString( 1, (String)sess.getAttribute("name") );
	st.setString( 2,"%"+t+"%");
	st.setString( 3,"%"+nC+"%");
	return st.executeQuery();
	
}

public ResultSet getBeniAssegnatiPropriaStanzaCorr() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT U.bene, B.targhetta, S.codice, S.nome,ST.denominazione,B.descrizione " +
			"FROM sottocategoriabene S, ubicazione U, account A, postazione P, bene B, stanza ST " +
			"WHERE A.username = ? AND P.personale = A.personale AND P.stanza = U.stanza AND "+
			"U.data_inizio<=current_date AND U.data_fine>=current_date AND " +
			"B.numero_inventario_generico = U.bene AND S.codice = B.sotto_categoria_bene AND U.Stanza= ST.codice");
	st.setString( 1, (String)sess.getAttribute("name") );
	return st.executeQuery();
}

public ResultSet getBeniAssegnatiPropriaStanzaCorrFiltTargh(String t) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT U.bene, B.targhetta, S.codice, S.nome,ST.denominazione,B.descrizione " +
			"FROM sottocategoriabene S, ubicazione U, account A, postazione P, bene B, stanza ST " +
			"WHERE A.username = ? AND P.personale = A.personale AND P.stanza = U.stanza AND "+
			"U.data_inizio<=current_date AND U.data_fine>=current_date AND " +
			"B.numero_inventario_generico = U.bene AND S.codice = B.sotto_categoria_bene AND upper(B.targhetta) LIKE upper(?) AND U.Stanza= ST.codice");
	st.setString( 1, (String)sess.getAttribute("name") );
	st.setString(2,"%"+t+"%");
	return st.executeQuery();
}

public ResultSet getBeniAssegnatiPropriaStanzaCorrFiltNSott(String nC) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT U.bene, B.targhetta, S.codice, S.nome,ST.denominazione,B.descrizione " +
			"FROM sottocategoriabene S, ubicazione U, account A, postazione P, bene B, stanza ST " +
			"WHERE A.username = ? AND P.personale = A.personale AND P.stanza = U.stanza AND "+
			"U.data_inizio<=current_date AND U.data_fine>=current_date AND " +
			"B.numero_inventario_generico = U.bene AND S.codice = B.sotto_categoria_bene AND upper(S.nome) LIKE upper(?) AND U.Stanza= ST.codice");
	st.setString( 1, (String)sess.getAttribute("name") );
	st.setString(2,"%"+nC+"%");
	return st.executeQuery();
}

%>
</head>
<body>

<script type="text/javascript">
function Check(form){

	if(form.targhetta.value=="" && form.NomeSottocategoria.value==""){
		window.alert("Inserisci almeno un dato");
		return false;
	}
	return true;
	
}
</script>

<%
sess=request.getSession(false);
if( sess == null || !sess.getAttribute("type").equals("dipendente") ) {
	%><p><i><font size="4">Autenticazione fallita</font></i></p>
	<p>
	<a href="../login.html"><button>Indietro</button></a>
	</p>
	<%return;
}
%>

<center><i><font size="5">Profilo Dipendente</font></i></center><hr>

<form action="gestioneBeniStanza.jsp?tar=targhetta&NSC=NomeSottocategoria" name="form" onsubmit="return Check(this)">
<p><font size=3> Filtra i risultati</font></p>

<font size=2>Targhetta: </font><input type="text" name="targhetta" ></input>
<font size=2>Nome SottoCategoria: </font><input type="text" name="NomeSottocategoria"></input>
<input type="submit" value="Filtra i Risultati"></input>

</form>

<hr></hr>

<p><font size=3> Elenco beni correntemente assegnati alla propria Stanza</font></p>

<%
ResultSet rs;
boolean filtro=false;
if(request.getParameter("targhetta")==null && request.getParameter("NomeSottocateroria")==null){
	
rs=getBeniAssegnatiPropriaStanzaCorr();

	
if(!rs.isBeforeFirst()){%>
		<p><font size=3> Non ci sono Beni correntemente assegnati nella propria Stanza</font></p>
		
<%}
}else if(!request.getParameter("targhetta").equals("") && request.getParameter("NomeSottocategoria").equals("")){
	
	String targhetta=request.getParameter("targhetta");
	rs=getBeniAssegnatiPropriaStanzaCorrFiltTargh(targhetta);
	filtro=true;
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati filtrati con questa Targhetta</font></p>
	<%}
}else if(!request.getParameter("NomeSottocategoria").equals("") && request.getParameter("targhetta").equals("")){
	
	String nomeSottoCategoria=request.getParameter("NomeSottocategoria");
	rs=getBeniAssegnatiPropriaStanzaCorrFiltNSott(nomeSottoCategoria);
	filtro=true;
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati filtrati con questo Nome SottoCategoria</font></p>
<%}
	
}else {
	String targhetta=request.getParameter("targhetta");
	String nomeSottoCategoria=request.getParameter("NomeSottocategoria");
	filtro=true;
	
	rs=getBeniAssegnatiPropriaStanzaCorrFiltTarghNSottoC(targhetta,nomeSottoCategoria);
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati filtrati con questa Targhetta e questo Nome SottoCategoria</font></p>
<%}}%>

<%if(rs.isBeforeFirst()){%>
<table border="1">
<tr><th>Bene</th><th>SottoCategoria Bene</th><th>Descrizione</th><th>Dettagli</th></tr>
<%while(rs.next()){ %>
<tr><td><%=rs.getString("bene")+"-"+rs.getString("targhetta") %></td><td><%=rs.getString("codice")+"-"+rs.getString("nome") %></td>
<td><%=rs.getString("descrizione") %></td><td><a href=visualizzaDatiBene.jsp?Codbene=<%=rs.getString("bene")%>><button>Dettagli</button></a></tr>
<%}%>
</table>
<%} %>
<%if(filtro){ %>
<hr></hr>
<p><a href="gestioneBeniStanza.jsp"><button>Torna a Gestione Beni</button></a></p>
<%}else{%>
<hr></hr>
<p><a href="gestioneBeni.jsp"><button>Indietro</button></a></p><%} %>
</body>
</html>