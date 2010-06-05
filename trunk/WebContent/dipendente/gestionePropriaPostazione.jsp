<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jdbc.JDBC" %>
<%@ page import="java.sql.*" %>
<%@page import="util.ConnectionManager"%>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestione Propria Postazione</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
<%!
HttpSession sess;
Connection conn;

public ResultSet getDatiPostazione() throws Exception{
	conn=ConnectionManager.getConnection();
	PreparedStatement st=conn.prepareStatement(
			"SELECT ST.denominazione,ST.posizione,ST.note,PT.data_inizio,PT.data_fine"+
			" FROM stanza ST,account AC,postazione PT"+
			" WHERE AC.username=? AND AC.personale=PT.personale AND PT.data_inizio<=current_date"+
			" AND PT.data_fine>=current_date AND PT.stanza=ST.codice");
	st.setString(1,(String)sess.getAttribute("name"));
	return st.executeQuery(); 
}

public ResultSet getDatiPostazioneFilData(String d) throws Exception{
	conn=ConnectionManager.getConnection();
	SimpleDateFormat formatter = new SimpleDateFormat( "dd-MM-yyyy" );
	PreparedStatement st=conn.prepareStatement(
			"SELECT ST.denominazione,ST.posizione,ST.note,PT.data_inizio,PT.data_fine"+
			" FROM stanza ST,account AC,postazione PT"+
			" WHERE AC.username=? AND AC.personale=PT.personale AND PT.data_inizio<=?"+
			" AND PT.data_fine>=? AND PT.stanza=ST.codice");
	st.setString(1,(String)sess.getAttribute("name"));
	st.setDate(2,new Date(formatter.parse(d).getTime()));
	st.setDate(3,new Date(formatter.parse(d).getTime()));
	return st.executeQuery();
	
}

%>
</head>
<body>
<script type="text/javascript">
function checkData(form) {
	var dataRegExp = /^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$/;
	if (!form.data.value.match( dataRegExp ) ) {
		window.alert("Inserisci la data nel formato dd-MM-yyyy");
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

<form action="gestionePropriaPostazione.jsp?data=" name="form" onsubmit="return checkData(this)">
<p><font size=3> Filtra i risultati</font></p>

<font size=2>Data: </font><input type="text" name="data" ></input>
<input type="submit" value="Filtra i Risultati"></input>

</form>

<hr></hr>

<p><font size=3> Dati della Postazione Attuale</font></p>

<%
ResultSet rs=null;
boolean filtro=false;
if(request.getParameter("data")==null){
	
rs=getDatiPostazione();

	
if(!rs.isBeforeFirst()){%>
		<p><font size=3> Non sei allocato in nessuna Postazione</font></p>
		
<%}
}else if(!request.getParameter("data").equals("")){
	
	String data=request.getParameter("data");
	rs=getDatiPostazioneFilData(data);
	filtro=true;
	
	if(!rs.isBeforeFirst()){%>
	<p><font size=3> Non sei assegnato a nessuna postazione filtrando con questa Data</font></p>
	<%}}%>

<%if(rs.isBeforeFirst()){%>
<table border="1">
<tr><th>Nome Stanza</th><th>Posizione</th><th>Note</th><th>Data Inizio</th><th>Data Fine</th></tr>
<%while(rs.next()){ %>
<tr><td><%=rs.getString("denominazione")%></td><td><%=rs.getString("posizione") %></td><td><%=rs.getString("note")%></td><td><%=rs.getString("data_inizio")%></td><td><%=rs.getString("data_fine")%></td></tr>
<%}%>
</table>
<%} %>
<%if(filtro){ %>
<hr></hr>
<p><a href="gestionePropriaPostazione.jsp"><button>Torna a Gestione Propria Postazione</button></a></p>
<%}else{%>
<hr></hr>
<p><a href="gestionepostazionegruppo.jsp"><button>Indietro</button></a></p><%} %>
</body>
</html>