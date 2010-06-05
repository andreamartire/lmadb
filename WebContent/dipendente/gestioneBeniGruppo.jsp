<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jdbc.JDBC" %>
<%@ page import="util.ConnectionManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Beni Gruppo</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
Connection conn;
HttpSession sess;

public ResultSet getBeniAssegnatiGruppoCorrFiltTarghNSotto(String t, String nC) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT A.bene, B.targhetta, S.codice, S.nome,B.descrizione,  " +
			"FROM assegnazione A, bene B, sottocategoriabene S " +
			"WHERE B.sotto_categoria_bene = S.codice AND B.numero_inventario_generico = A.bene AND " +
			"A.data_inizio <= current_date AND A.data_fine >= current_date AND upper(B.targhetta) LIKE upper(?) AND upper(S.nome) LIKE upper(?) "+ 
			"AND A.gruppo_di_lavoro IN (" +
			"SELECT gruppo_di_lavoro " +
			"FROM allocazione AL, account AC " + 
			"WHERE username = ? AND AC.personale = AL.personale AND data_inizio <= current_date AND data_fine >= current_date");
			
			st.setString( 1,"%"+t+"%");
			st.setString( 2,"%"+nC+"%");
			st.setString( 3, (String)sess.getAttribute("name") );
			
	return st.executeQuery();
	
}

public ResultSet getBeniAssegnatiGruppoLavoroCorr() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT A.bene, B.targhetta, S.codice, S.nome,B.descrizione,GDL.denominazione " +
			"FROM assegnazione A, bene B, sottocategoriabene S,GruppoDiLavoro GDL " +
			"WHERE B.sotto_categoria_bene = S.codice AND B.numero_inventario_generico = A.bene AND " +
			"A.data_inizio <= current_date AND A.data_fine >= current_date AND A.gruppo_di_lavoro IN (" +
			"SELECT gruppo_di_lavoro " +
			"FROM allocazione AL, account AC " + 
			"WHERE username = ? AND AC.personale = AL.personale AND data_inizio <= current_date AND data_fine >= current_date) "+
			"AND A.gruppo_di_lavoro = GDL.codice");
	st.setString( 1, (String)sess.getAttribute("name") );
	return st.executeQuery();
}

public ResultSet getBeniAssegnatiGruppoCorrFiltTargh(String t) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT A.bene, B.targhetta, S.codice, S.nome,B.descrizione " +
			"FROM assegnazione A, bene B, sottocategoriabene S " +
			"WHERE B.sotto_categoria_bene = S.codice AND B.numero_inventario_generico = A.bene AND " +
			"A.data_inizio <= current_date AND A.data_fine >= current_date AND upper(B.targhetta) LIKE upper(?) "+
			"AND A.gruppo_di_lavoro IN (" +
			"SELECT gruppo_di_lavoro " +
			"FROM allocazione AL, account AC " + 
			"WHERE username = ? AND AC.personale = AL.personale AND data_inizio <= current_date AND data_fine >= current_date)");
	st.setString(1,"%"+t+"%");
	st.setString(2, (String)sess.getAttribute("name") );
	
	return st.executeQuery();
}

public ResultSet getBeniDotazioneCorrFiltnomeSott(String nC) throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st = conn.prepareStatement(
			"SELECT A.bene, B.targhetta, S.codice, S.nome,B.descrizione " +
			"FROM assegnazione A, bene B, sottocategoriabene S " +
			"WHERE B.sotto_categoria_bene = S.codice AND B.numero_inventario_generico = A.bene AND " +
			"A.data_inizio <= current_date AND A.data_fine >= current_date AND upper(S.nome) LIKE upper(?) "+
			"AND A.gruppo_di_lavoro IN (" +
			"SELECT gruppo_di_lavoro " +
			"FROM allocazione AL, account AC " + 
			"WHERE username = ? AND AC.personale = AL.personale AND data_inizio <= current_date AND data_fine >= current_date)");
	st.setString( 1,"%"+nC+"%");
	st.setString( 2, (String)sess.getAttribute("name") );
	
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

<form action="gestioneBeniGruppo.jsp?tar=targhetta&NSC=NomeSottocategoria" name="form" onsubmit="return Check(this)">
<p><font size=3> Filtra i risultati</font></p>

<font size=2>Targhetta: </font><input type="text" name="targhetta" ></input>
<font size=2>Nome SottoCategoria: </font><input type="text" name="NomeSottocategoria"></input>
<input type="submit" value="Filtra i Risultati"></input>

</form>

<hr></hr>

<p><font size=3> Elenco beni correntemente assegnati al gruppo di lavoro</font></p>

<%
ResultSet rs;
boolean filtro=false;
if(request.getParameter("targhetta")==null && request.getParameter("NomeSottocateroria")==null){
	
rs=getBeniAssegnatiGruppoLavoroCorr();

	
if(!rs.isBeforeFirst()){%>
		<p><font size=3> Non ci sono Beni correntemente assegnati al gruppo di lavoro</font></p>
		
<%}
}else if(!request.getParameter("targhetta").equals("") && request.getParameter("NomeSottocategoria").equals("")){
	
	String targhetta=request.getParameter("targhetta");
	rs=getBeniAssegnatiGruppoCorrFiltTargh(targhetta);
	filtro=true;
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati al gruppo di lavoro filtrati con questa Targhetta</font></p>
	<%}
}else if(!request.getParameter("NomeSottocategoria").equals("") && request.getParameter("targhetta").equals("")){
	
	String nomeSottoCategoria=request.getParameter("NomeSottocategoria");
	rs=getBeniDotazioneCorrFiltnomeSott(nomeSottoCategoria);
	filtro=true;
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati al gruppo di lavoro filtrati con questo Nome SottoCategoria</font></p>
<%}
	
}else {
	String targhetta=request.getParameter("targhetta");
	String nomeSottoCategoria=request.getParameter("NomeSottocategoria");
	filtro=true;
	
	rs=getBeniAssegnatiGruppoCorrFiltTarghNSotto(targhetta,nomeSottoCategoria);
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non ci sono Beni correntemente assegnati al gruppo di lavoro filtrati con questa Targhetta e questo Nome SottoCategoria</font></p>
<%}}%>

<%if(rs.isBeforeFirst()){%>
<table border="1">
<tr><th>Bene</th><th>SottoCategoria Bene</th><th>Nome Gruppo Di Lavoro</th><th>Descrizione</th><th>Dettagli</th></tr>
<%while(rs.next()){ %>
<tr><td><%=rs.getString("bene")+"-"+rs.getString("targhetta") %></td><td><%=rs.getString("codice")+"-"+rs.getString("nome") %></td><td><%=rs.getString("denominazione") %></td>
<td><%=rs.getString("descrizione") %></td><td><a href=visualizzaDatiBene.jsp?Codbene=<%=rs.getString("bene")%>><button>Dettagli</button></a></tr>
<%}%>
</table>
<%} %>
<%if(filtro){ %>
<hr></hr>
<p><a href="gestioneBeniGruppo.jsp"><button>Torna a Gestione Beni</button></a></p>
<%}else{%>
<hr></hr>
<p><a href="gestioneBeni.jsp"><button>Indietro</button></a></p><%} %>
</body>
</html>