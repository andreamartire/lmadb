<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="util.ConnectionManager"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Gestion Stanza</title>
<link rel="stylesheet" type="text/css" href="../style.css" />
</head>
<body>
<%! Connection conn; %>
<%
HttpSession sess = request.getSession(false);
if( sess == null || !sess.getAttribute("type").equals("addetto amministrativo") ) {
	%><p><i><font size="4" color="#FF8000">Autenticazione fallita</font></i></p>
	<p>
	<a href="login.html"><button>Indietro</button></a>
	</p><%
	return;
}

conn = ConnectionManager.getConnection();
%>
<center><i><font size="5">Profilo Addetto Amministrativo</font></i></center><hr>
<p><i><font size="4">Gestione Stanza</font></i></p><%

String stanza = request.getParameter("idStanza");
String done =  request.getParameter("done");

if( done != null ) {
	if( done.equals("true") ) {
		%><p><i><font size="2" color="BLUE">Modifica andata a buon fine</font></i></p><%
	} else {
		%><p><i><font size="2" color="RED">Modifica fallita</font></i></p><%
	}
}

String denominazione = "", posizione = "", note = "";

PreparedStatement st = conn.prepareStatement("SELECT * FROM stanza WHERE codice = ?");
st.setString( 1, stanza );
ResultSet rs = st.executeQuery();

if( rs.next() ) {
	denominazione = rs.getString("denominazione");
	posizione = rs.getString("posizione");
	note = rs.getString("note");
} else {
	// TODO
}
%>

<p><font size="4">Informazioni Stanza:</font></p>
<form action="../ModificaStanza" method="get">
	<table>
		<tr><td align="right"><i>Codice:</i></td><td><input type="text" name="codice" readonly="readonly" value="<%=stanza %>"></td><td></td></tr>
		<tr><td align="right"><i>Denominazione:</i></td><td><input type="text" name="denominazione" value="<%=denominazione %>"></td></tr>
		<tr><td align="right"><i>Posizione:</i></td><td><input type="text" name="posizione" value="<%=posizione %>"></td></tr>
		<tr><td align="right"><i>Note:</i></td><td><input type="text" name="note" value="<%=note %>"></td></tr>
		<tr><td><input type=submit value="Salva"></td></tr>
	</table>
</form>

<p>
<a href="gestioneStanze.jsp"><button>Indietro</button></a>
</p>
</body>
</html>